# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Controller::Task;
use strict;
use warnings;

use base 'Catalyst::Controller::BindLex';

sub task_setup :Chained('/') PathPart('task') CaptureArgs(1) {
    my ($self, $c, $task_id) = @_;
    my $task :Stashed = $c->model('DBIC::Restricted::Tasks')->find($task_id);
    $c->detach('/not_found') unless $task;
    $c->res->redirect($c->uri_for('/my/queue'));
    $c->flash->{added_id} = $task_id;
}

sub reopen :Chained('task_setup') PathPart Args(0) {
    my ($self, $c) = @_;
    my $task :Stashed;
    $task->reopen;
    $c->flash->{message} = "The task was reopened";
}

sub close :Chained('task_setup') PathPart Args(0) {
    my ($self, $c) = @_;
    my $task :Stashed;
    $task->close;
    $c->flash->{message} = "The task was closed.";
}

1;
