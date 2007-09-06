# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Controller::Task;
use strict;
use warnings;
use DoQueue::Parser::Metadata;

use base 'Catalyst::Controller::FormBuilder';

sub task_setup :Chained('/') PathPart('task') CaptureArgs(1) {
    my ($self, $c, $task_id) = @_;
    my $task = $c->model('DBIC::Restricted::Tasks')->find($task_id);
    $c->detach('/not_found') unless $task;
    $c->flash->{added_id} = $task_id;
    $c->stash->{task} = $task;
}

sub reopen :Chained('task_setup') PathPart Args(0) {
    my ($self, $c) = @_;
    $c->stash->{task}->reopen;
    $c->flash->{message} = "The task was reopened";
    $c->res->redirect($c->uri_for('/my/queue'));
}

sub close :Chained('task_setup') PathPart Args(0) {
    my ($self, $c) = @_;
    $c->stash->{task}->close;
    $c->flash->{message} = "The task was closed.";
    $c->res->redirect($c->uri_for('/my/queue'));
}

sub blow_away :Chained('task_setup') PathPart Args(0) {
    my ($self, $c) = @_;
    $c->stash->{task}->delete;
    $c->flash->{message} = "That task is gone forever!";
    my $username = $c->user->username;
    $c->res->redirect($c->uri_for("/queue/$username/deleted"));
}

sub edit :Chained('task_setup') PathPart Args(0) Form('edit_task') {
    my ($self, $c) = @_;
    my $task = $c->stash->{task};
    my $metadata = join "\n", 
      map {$_->tag .'='. $_->value } $task->metadata->all;
    
    $metadata ||= '';
    
    my $f = $self->formbuilder;
    $f->field(name => 'task', value => $task->task);
    $f->field(name => 'metadata', value => $metadata);

    my $meta = $f->field('metadata');
    $meta =~ s/(^\n+|\n+$)+//g;
    $meta =~ s/\n/,/g;
    my $metadata = eval {
        DoQueue::Parser::Metadata->parse($meta);
    };
    if (!$metadata) {
        $c->stash->{error} = 'The metadata is not valid.';
    }
        
    if ($f->submitted && $f->validate) {
        $task->update_task($f->field('task'), $metadata);
        $c->flash->{added_id} = $task->id;
        $c->res->redirect($c->uri_for('/my/queue'));
    }
    $c->view->template('task/edit');
}

1;
