package DoQueue::Controller::Queue;
use strict;
use warnings;
use DoQueue::Parser::Task;

use base qw/Catalyst::Controller/;

sub my_queue :Path('/my/queue') :Args(0) {
    my ($self, $c) = @_;
    
    $self->queue_setup($c, $c->user->uid);
    $self->open($c);
    $c->detach;
}

sub queue_setup :Chained('/') PathPart('queue') CaptureArgs(1) {
    my ($self, $c, $user_id) = @_;
    
    # load user
    my $user = $c->model('DBIC::Restricted::Users')->find($user_id);
    if (!$user) {
        # lookup by username
        $user = $c->model('DBIC::Restricted::Users')->
          find($user_id, { key => 'name' });
    }
    $c->detach('/not_found') unless $user;
    
    my $tasks_rs = $user->tasks;

    $c->stash->{tasks_rs} = $tasks_rs;
    $c->stash->{user}     = $user;

}

sub open :Chained('queue_setup') PathPart Args(0) {
    my ($self, $c) = @_;
    my $tasks_rs = $c->stash->{tasks_rs};
    $c->stash->{tasks} = [$tasks_rs->active->all];
    $c->view->template('queue/show');
}

sub deleted :Chained('queue_setup') PathPart Args(0) {
    my ($self, $c) = @_;
    my $tasks_rs = $c->stash->{tasks_rs};

    # only let user see his own deleted tasks
    $c->detach('/not_found') 
      if eval { $c->user->uid != $tasks_rs->first->owner->uid };
    
    $c->stash->{tasks}  = [$tasks_rs->deleted->all];
    $c->stash->{showing_deleted} = 1;
    $c->view->template('queue/show');
}

1;
