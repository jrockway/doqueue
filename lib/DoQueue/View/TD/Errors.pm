package DoQueue::View::TD::Errors;
use strict;
use warnings;

use Template::Declare::Tags;
use DoQueue::View::TD::Wrapper;

template 'not_found' => sub {
    wrapper {
        p { attr { class => 'error' };
            "The requested page could not be found."
        };
    }
};


1;
