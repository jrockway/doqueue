# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::View::TD::Account;
use strict;
use warnings;

use Template::Declare::Tags;
use DoQueue::View::TD::Wrapper;

template 'account/login' => sub {
    wrapper {
        h2 { 'Log in' };
        p {
            'Enter your OpenID URL, host name, or i-name to log in.'
        };
        form {
            attr { method => 'post',
                   action => c->uri_for('/login'),
            };
            label {
                attr { for => 'claimed_uri' };
                'OpenID'
            };
            input {
                attr { id    => 'claimed_uri',
                       name  => 'claimed_uri',
                       type  => 'text',
                       class => 'openid',
                };
              };
            input { 
                attr { type  => 'submit',
                       name  => 'submit', 
                       value => 'Log in',
                };
            }
        }
    }
};

template 'account/set_username' => sub {    
    wrapper {
        h2 { 'Pick a username' };
        p {
            "Select a username that you'd like to use on [doqueue]"
        };
        form {
            attr { method => 'post',
                   action => c->uri_for('/account/set_username'),
            };
            label {
                attr { for => 'desired_name' };
                'Username'
            };
            input {
                attr { id    => 'desired_name',
                       name  => 'desired_name',
                       type  => 'text',
                };
              };
            input { 
                attr { type  => 'submit',
                       name  => 'submit', 
                       value => 'Go',
                };
            }
        }
    }
};

template 'account/cleared_keys' => sub {
    wrapper {
        h2 { 'API keys deleted' };
        p { "All API keys associated with your account have been ".
              "deactivated."
          };
    }
};

template 'account/api_key' => sub {
    wrapper {
        h2 { 'API key' };
        p { outs("Your new API key is: ");
            tt { c->stash->{key} };
        };
        p { "Any other keys will continue to work until you deactivate them." };
    }
};

template 'account/logout' => sub {
    wrapper {
        h2 { 'Logout complete' };
        p { 'You have been logged out of [doqueue].' };
    };
};

1;
