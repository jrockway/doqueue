# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::View::TD::Task;
use strict;
use warnings;

use Template::Declare::Tags;
use DoQueue::View::TD::Wrapper;

template 'task/edit' => sub {
    wrapper {
        h2 { "Edit task" };
        outs_raw(c->stash->{FormBuilder}->render);
    }
};

1;
