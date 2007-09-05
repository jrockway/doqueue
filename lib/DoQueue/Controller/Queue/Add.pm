# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Controller::Queue::Add;
use strict;
use warnings;
use base qw/Catalyst::Controller::FormBuilder/;


sub add_with_form :Path('/queue/add') Args(0) Form('add_task') {
    my ($self, $c) = @_;
    my $f = $self->formbuilder;
    
    $f->fields(task => $c->req->{task}); # support non-FB forms

    my $task   = $f->field('task');
    my $parses = eval { DoQueue::Parser::Task->parse($task) };
    if ($task && $parses){
        $c->detach('add_from_args', [$f->field('task')]);
    }
    if ($task && !$parses) {
        $c->stash->{error} = 'There was an error parsing the task.';
    }

    $c->view->template('add_task_form');
}

sub add_from_args :Path('/queue/add') Args(1) {
    my ($self, $c, $task_def) = @_;
    
    my $user = $c->user or die;
    my $task = eval {
        $user->add_task($task_def);
    };
    if (ref $@ && $@->isa('DoQueue::Error::User')){
        $c->flash->{error} = "There was an error parsing the task.";
        $c->res->redirect($c->uri_for('/queue/add'));
        $c->detach;
    }
    die $@ if $@; # internal error

    $c->flash->{added_id} = $task->id;
    $c->flash->{message} = 'The task was added.';
    $c->res->redirect($c->uri_for('/my/queue'));
    $c->detach;
}


1;
