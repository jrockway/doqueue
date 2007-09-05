# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Controller::Account;
use strict;
use warnings;
use base 'Catalyst::Controller';

sub login :Global :Args(0) {
    my ($self, $c) = @_;
    my $openid = $c->req->params->{claimed_uri};
    
    if ($c->req->param != 0) {
        if (!$openid && $c->req->params->{submit}) {
            $c->stash(error => 'Please enter your OpenID.');
            $c->detach;
        };
        
        if (eval {$c->authenticate}) {
            if (!$c->user->{url}) {
                $c->flash->{message} = 
                  'Successfully logged in as '. $c->user->username;
                $c->res->redirect($c->uri_for('/'));
            }
            else {
                # first time we've seen this openid
                $c->session->{first_time} = $c->user->{url};
                $c->res->redirect($c->uri_for('/account/set_username'));
            }
        }
        else {
            $c->log->debug("failed login for ". 
                           $c->req->params->{claimed_uri}. ": $@")
              if $c->debug;
            
            $c->stash(error => 
                      'You could not be authenticated with that OpenID');
        }
        
        $c->detach;
    };
};

sub set_username :Local Args(0){
    my ($self, $c) = @_;
    my $first = $c->session->{first_time};
    $c->detach('/not_found') unless $first;

    if (my $username = $c->req->params->{desired_name}) {
        my $user = eval {
            $c->model('DBIC::Users')->
              create({ username => $username,
                       openid   => $first,
                     });
        };

        if ($@) {
            $c->stash->{error} = 'That username is already in use.';
        }
        if ($user) {
            $c->session->{__user} = $user->id;
            $c->user(undef);
            $c->flash->{message} = "Welcome to [doqueue], $username!";
            $c->res->redirect($c->uri_for('/'));
            $c->detach;
        }
    }
    
    $c->view->template('account/set_username');
}

sub invalidate_api_keys :Local {
    my ($self, $c) = @_;
    $c->detach('/not_found') unless $c->user;
    $c->user->api_keys->delete;

    $c->view->template('account/cleared_keys');
}

sub get_api_key :Local {
    my ($self, $c) = @_;
    $c->detach('/not_found') unless $c->user;

    my $key = $c->user->get_api_key;
    $c->stash->{key} = $key->key;
    $c->view->template('account/api_key');
}

sub logout :Global :Args(0) {
    my ($self, $c) = @_;
    $c->logout;
}

1;
