# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::View::TD::AddTask;
use strict;
use warnings;

use Template::Declare::Tags;
use DoQueue::View::TD::Wrapper;

template 'queue/add/task' => sub {
    wrapper {
        outs_raw(c->stash->{FormBuilder}->render);
    };
};

1;
