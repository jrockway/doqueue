package DoQueue::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

=head1 METHODS

=head2 default

404 catch-all

=cut

sub default : Private {
    $_[1]->detach('/not_found');
}

=head2 main

Main page

=cut

sub main :Path :Args(0) {}

=head2 not_found

Show a 404 page.

=cut

sub not_found :Private {
    my ($self, $c) = @_;
    $c->view->template('not_found');
    $c->stash->{title} = 'Page Not Found';
    $c->res->status(404);
}

=head2 access_denied

=cut

sub access_denied :Private {
    my ($self, $c) = @_;
    $c->view->template('not_found');
    $c->stash->{title} = 'Access not allowed';
    $c->res->status(404);
}

=head2 end

Render view.

=cut 

sub end : ActionClass('RenderView') {}

1;
