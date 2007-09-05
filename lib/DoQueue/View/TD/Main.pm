package DoQueue::View::TD::Main;
use strict;
use warnings;

use DoQueue::View::TD::Wrapper;
use Template::Declare::Tags;

template main => sub {
    wrapper {
        if (c->user) {
            p { "You're logged in as ". c->user->username. "." };
            a { attr { href => c->uri_for('/my/queue') };
                "View my queue";
            };
            a { attr { href => c->uri_for('/queue/add') };
                "Add a todo";
            };
            a { attr { href => c->uri_for('/account/get_api_key') };
                "Get an API key";
            };
            a { attr { href => c->uri_for('/account/invalidate_api_keys') };
                "Invalidate all API keys";
            };
              
        }
        else {
            p { "You're not logged in." };
            a { 
                attr { href => c->uri_for('/login') };
                "Log in or create an account.";
            };
        }
    }
};

1;
