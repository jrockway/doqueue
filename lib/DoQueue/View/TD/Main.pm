package DoQueue::View::TD::Main;
use strict;
use warnings;

use DoQueue::View::TD::Wrapper;
use Template::Declare::Tags;

template main => sub {
    wrapper {
        a { attr { href => c->uri_for('/my/queue') };
            "View my queue";
        }
        a { attr { href => c->uri_for('/queue/add') };
            "Add a todo";
        }
    }
};

1;
