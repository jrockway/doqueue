# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Controller::Signup;
use strict;
use warnings;

use base 'Catalyst::Controller::FormBuilder';

sub signup :Path :Args(0) :Form('signup') {
    my ($self, $c) = @_;
    my $f = $self->formbuilder;
    
    if ($f->submitted() && $f->validate()) {
        my ($openid, $username) = map { $f->field($_) } qw/openid username/;
        my $user = eval {
            $c->model('DBIC::Users')->create({ openid   => $openid,
                                               username => $username,
                                             });
        };
        if ($user) {
            warn "added user ok";
            $c->flash->{message} = "Welcome to [doqueue], $username!";
            $c->res->redirect($c->uri_for('/'));
            $c->detach;
        }

        if (!$user && (my ($col) = ($@ =~ /(username|openid)/))) {
            $c->stash->{error} = "There was a slight problem with your entry;".
              " there is already a user with that $col in the database.  ".
                "Maybe you already signed up?";
        }
        else {
            die "Internal error: $@";
        }
    }
    
    $c->view->template('signup');   
}

1;
