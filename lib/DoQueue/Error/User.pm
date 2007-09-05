# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Error::User;
use strict;
use warnings;
use Carp;

=head1 NAME

DoQueue::Error::User - errors that we can display back to the user

=head1 METHODS

=head2 DoQueue::Error::User->throw('message');

dies with message blessed into DoQueue::Error::User

=cut

sub throw {
    my $error = bless $_[0] => 'DoQueue::Error::User';
    croak $error;
}

1;
