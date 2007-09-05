# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::View::TD::Signup;
use strict;
use warnings;

use Template::Declare::Tags;
use DoQueue::View::TD::Wrapper;

template 'signup' => sub {
    wrapper {
        p {
            "Sign up for [doqueue].  All you need is an OpenID...".
              "your username can be anything."
        };
        outs_raw(c->stash->{FormBuilder}->render);
    }
};

1;
