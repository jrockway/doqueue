package DoQueue::Controller::Queue;
use strict;
use warnings;

use base 'Catalyst::Controller::BindLex';

sub my_queue :Path('/my/queue') :Args(0) {
    my ($self, $c) = @_;
    
    # who am i?
    my $me = $c->model('DBIC::Users')->find(1); # 1 for now
    
    $c->response->redirect($c->uri_for($c->action()));
    $c->detach;
}

sub queue_setup :Chained('/') PathPart('queue') CaptureArgs(1) {
    my ($self, $c, $user_id) = @_;
 
    # load user
    my $user :Stashed = $c->model('DBIC::Users')->find($user_id);
    $c->detach('/not_found') unless $user;

    my $queue :Stashed = $user->tasks;
}

sub display :Chained('queue_setup') PathPart('') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'show_queue';
}

1;
