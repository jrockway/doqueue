# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Parser::Metadata;
use strict;
use warnings;
use Carp;
use Readonly;

=head2 parse

Given a string like foo=bar, returns a data structure like C<{ foo =>
['bar'] }>.

Parse works like this:

=over

=item partition pairs

We split at commas, so C<foo=bar,bar=baz> is split into C<foo=bar> and
C<bar=baz>.

=item extract key/value

Then we split at the first equals sign, so C<foo=bar> becomes C<foo>, C<bar>.
If there is no equals sign, then we have a parse error.

C<foo=bar=baz> splits to C<foo>, C<bar=baz>.

=back

The same key can appear once, and each value is appeneded to a list of
values for a given key.  Even if there is only one value for a key, it
is still returned as an arrayref.

=cut
Readonly my $NOT_EQUALS => qr/([^=]+)/;

sub parse {
    my ($class, $in) = @_;

    my %result;
    my @pairs  = split /,/, $in;
    foreach my $pair (@pairs) {
        if (my ($key, $value) = ($pair =~ /^ $NOT_EQUALS = $NOT_EQUALS $/xo)) {
            _trim($key, $value);
            $result{$key} ||= [];
            push @{$result{$key}}, $value;
        }
        else {
            croak "parse error; cannot parse '$pair' into a key/value";
        }
    }
    
    return \%result;
}

sub _trim {
    do { s/^\s+//; s/\s+$// } for @_;
}

1;
