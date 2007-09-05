package DoQueue::Controller::API;
use strict;
use warnings;

use base 'Catalyst::Controller::REST';

__PACKAGE__->config->{serialize}{default} = 'text/x-yaml';

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

sub tasks :Local ActionClass('REST'){
    my ($self, $c, $id) = @_;
    $c->stash->{id} = $id;
}

sub task_entity {
    my $task = shift;
    my @result;
    map { push @result, $_ => $task->$_ } qw/priority task id/;
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
    my $id = $c->stash->{id};

    my $task = $c->model('DBIC::Restricted::Tasks')->find($id);
    if (!$task) {
        $self->status_not_found($c, message => "No task with id $id");
    }
    else {
        my $entity = task_entity($task);
        my $ok = eval { $task->delete };
        if ($ok) {
            $self->status_ok($c, entity => $entity);
        }
        else {
            $self->status_bad_request($c, message => 'Failed');    
        }
    }
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
    $self->status_bad_request($c, message => "Failed");    
}

1;
