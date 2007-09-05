# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Parser::Task;
use strict;
use warnings;
use Carp;
use Readonly;
use DoQueue::Parser::Metadata;

=head2 DoQueue::Parser::Task->parse

Accepts a string like "1: do some work [importance=3,tags=foo,tags=bar]" and
returns a data structure like:

  { order    => 1,
    task     => 'do some work',
    metadata => { importance => [3],
                  tags       => [qw/foo bar/],
                },
  }

The order is optional, as is the metadata.  Metadata is parsed with
C<DoQueue::Parser::Metadata>.  Order defaults to 0.  Metadata defaults
to C<{}>.

=cut

Readonly my $ORDER => qr/(?:(\d+):)/;
Readonly my $TASK  => qr/([^[]+)/;
Readonly my $META  => qr/(?:\[(.+)\])/;

sub parse {
    my ($class, $in) = @_;
    if ( my ($order, $task, $metadata) = ($in =~ /$ORDER? $TASK $META?/xo) ){
        _trim($task);
        return { order    => $order || 0, 
                 task     => $task,
                 metadata => DoQueue::Parser::Metadata->parse($metadata||''),
               };
    }

    croak 'parse error';
}

sub _trim {
    DoQueue::Parser::Metadata::_trim(@_);
}
1;
