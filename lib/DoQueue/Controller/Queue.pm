package DoQueue::Controller::Queue;
use strict;
use warnings;
use DoQueue::Parser::Task;

use base qw/Catalyst::Controller::BindLex/;

sub my_queue :Path('/my/queue') :Args(0) {
    my ($self, $c) = @_;
    
    $self->queue_setup($c, $c->user->uid);
    $self->display($c);
    $c->detach;
}

sub queue_setup :Chained('/') PathPart('queue') CaptureArgs(1) {
    my ($self, $c, $user_id) = @_;
    
    # load user
    my $user :Stashed = $c->model('DBIC::Users')->find($user_id);
    $c->detach('/not_found') unless $user;

    my $active = $user->tasks->active;
    my @tasks :Stashed = $active->all;
}

sub display :Chained('queue_setup') PathPart('display') Args(0) {
    my ($self, $c) = @_;
    $c->view->template('queue/show');
}

1;
