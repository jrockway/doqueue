package DoQueue::Model::DBIC::Restricted;
use strict;
use warnings;

use base 'Catalyst::Model';

sub new {
    my $class = shift;
    my $self  = $class->NEXT::new(@_);
    my $app   = shift;
    foreach my $moniker ($app->model('DBIC')->schema->sources) {
        my $classname = "${class}::$moniker";
        no strict 'refs';
        *{"${classname}::ACCEPT_CONTEXT"} = sub {
            shift;
            my $c = shift;
            my $user = eval { $c->user->get_object } || $c->user;
            $c->model('DBIC')->schema->
              restrict_with_object($user)->resultset($moniker);
        }
    }
    
    return $self;
};

sub ACCEPT_CONTEXT {
    my ($self, $c) = @_;
    my $user = eval { $c->user->get_object } || $c->user;
    return $c->model('DBIC')->schema->restrict_with_object($user);
}

1;
