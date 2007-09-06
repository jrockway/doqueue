package DoQueue::Controller::API;
use strict;
use warnings;

use base qw/Catalyst::Controller::REST Catalyst::Controller::BindLex/;

__PACKAGE__->config->{serialize}{default} = 'text/x-json';

sub begin : ActionClass('Deserialize') {
    my ($self, $c) = @_;

    my $key  = $c->req->header('X-DoqueueKey');
    my $key_obj = $c->model('DBIC::ApiKeys')->find($key, {key => 'key'});
    my $user = eval { $key_obj->owner };
    
    # require either logged in user, or correct user+pass in headers
    if ( !$c->user && !$user ) {
        # login failed
        $c->res->status(403); # forbidden
        $c->res->body("You are not authorized to use the REST API.");
        $c->detach;
    }
    
    $c->user($user) if $user;
}

sub update_entity {
    my ($self, $c, $before, $update, $formatter) = @_;
    
    if (!$before) {
        $self->status_not_found($c, message => 'Not found');
    }
    else {
        my $after = eval { $update->($before) };
        if ($after) {
            $self->status_ok($c, entity => $formatter->($after));
        }
        else {
            $self->status_bad_request($c, message => 'Failed');
        }
    }
}

sub metadata :Local :Args(1) ActionClass('REST'){
    my $self = shift;
    my $c    = shift;
    my $tid :Stashed = shift;
}

sub metadata_entity {
    my $metadatum = shift;
    return { map { $_ => $metadatum->$_ } qw/id key value/ };
}

sub metadata_GET {
    my ($self, $c) = @_;
    my $tid :Stashed;
    my $task = $c->user->tasks->find($tid);
    if (!$task) {
        $self->status_not_found($c, message => "Task $tid not found");
        $c->detach;
    }
    
    my @metadata = eval { $c->user->tasks->find($tid)->metadata->all };    
    $self->status_ok($c, entity => { metadata => 
                                     [map { metadata_entity($_) } @metadata ]});
}

sub metadata_POST {
    my ($self, $c) = @_;
    my $tid :Stashed;
    my $data = $c->req->data;
    use YAML; die Dump($c->req);
    my $metadata = eval {
        $c->user->tasks->find($tid)->
          create_related(metadata => { key   => $data->{key},
                                       value => $data->{value},
                                     });
    };
    
    if ($metadata) {
        $self->status_ok($c, entity => metadata_entity($metadata));
    }
    else {
        $self->status_bad_request($c, message => 'Failed');
    }
}


# put and delete take metadata id instead of task id
sub metadata_PUT {
    my ($self, $c) = @_;
    my $tid :Stashed;
    my $new = $c->req->data;
    my $current  = $c->model('DBIC::Restricted::TaskMetadata')->find($tid);
    $self->update_entity($c, $current,
                         sub {
                             my $metadata = shift;
                             return $metadata->
                               update({ key   => $new->{key},
                                        value => $new->{value},
                                      });
                         }, \&metadata_entity);
}


sub tasks :Local ActionClass('REST'){
    my $self = shift;
    my $c    = shift;
    my $id :Stashed = shift;
}

sub task_entity {
    my $task = shift;
    my @result;
    push @result, $_ => $task->$_  for qw/priority task id/;
    push @result, metadata => $task->metadata_hash;
    return {@result};
}

sub tasks_GET {
    my ($self, $c) = @_;
    my $tasks = $c->model('DBIC::Restricted::Tasks')->active;
    my @tasks;
    foreach my $task ($tasks->all) {
        push @tasks, task_entity($task);
    }
    $self->status_ok($c, entity => { tasks => [@tasks]});
}

sub tasks_DELETE {
    my ($self, $c) = @_;
    my $id :Stashed;

    my $task = $c->model('DBIC::Restricted::Tasks')->find($id);
    $self->update_entity($c, $task, 
                         sub { $task->delete }, sub { {result => 'ok'} }); 
}

sub tasks_POST {
    my ($self, $c) = @_;
    my $data = $c->req->data;
    
    if (my $task_def = $data->{raw_task}) {
        my $task = eval {
            $c->user->add_task($task_def);
        };
        if (!$@) {
            $self->status_ok($c, entity => task_entity($task));
            $c->detach;
        }
    }
    $self->status_bad_request($c, message => 'Failed');    
}

1;
