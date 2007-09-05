# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Error::User;
use strict;
use warnings;
use Carp;

use overload '""' => sub { ${$_[0]} }; # unbox scalar reference

=head1 NAME

DoQueue::Error::User - errors that we can display back to the user

=head1 METHODS

=head2 DoQueue::Error::User->throw('message');

dies with message blessed into DoQueue::Error::User

=cut

sub throw {
    my ($class, $msg) = @_;
    my $error = bless \$msg => $class;
    croak $error;
}

1;
