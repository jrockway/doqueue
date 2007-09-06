package DoQueue::View::TD::Main;
use strict;
use warnings;

use DoQueue::View::TD::Wrapper;
use Template::Declare::Tags;

template main => sub {
    wrapper {
        if (c->user) {
            p { "You're logged in as ". c->user->username. "." };
            h2{ 'Todos' };
            a { attr { href => c->uri_for('/my/queue') };
                "View my queue";
            };
            a { attr { href => c->uri_for('/queue/add') };
                "Add a todo";
            };
            h2 { 'API' };
            a { attr { href => c->uri_for('/account/get_api_key') };
                "Get an API key";
            };
            a { attr { href => c->uri_for('/account/invalidate_api_keys') };
                "Invalidate all API keys";
            };
            h2 { 'Account' };
            a { attr { href => c->uri_for('/logout') };
                "Log out";
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
