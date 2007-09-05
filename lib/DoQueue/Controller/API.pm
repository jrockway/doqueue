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

sub tasks_GET {
    my ($self, $c) = @_;
    my $tasks = $c->user->tasks->active;
    my @tasks;
    foreach my $task ($tasks->all) {
        my @result;
        map { push @result, $_ => $task->$_ } qw/priority task/;
        push @result, metadata => $task->metadata_hash;
        push @tasks, {@result};
    }
    $self->status_ok($c, entity => { tasks => [@tasks]});
}

1;
