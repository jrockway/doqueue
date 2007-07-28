package DoQueue::Test::Database;
use strict;
use warnings;

use Directory::Scratch;
use base 'DoQueue::Schema';

=head1 NAME

DoQueue::Test::Database - create a DoQueue::Schema database that
goes away when the program exits

=head1 SYNOPSIS

    use DoQueue::Test::Database;
    my $schema = DoQueue::Test::Database->connect;

    # now it's just a DoQueue::Schema
    $schema->resultset('Users')->find(...); 
    # etc.

=head1 METHODS

=head2 connect

Connect to the test database.

=cut

sub connect {
    my $self = shift;
    my $tmp = Directory::Scratch->new;
    my $db  = $tmp->touch('test_database');
    my $dsn = "DBI:SQLite:$db";
    my $s = $self->SUPER::connect($dsn);
    $s->deploy;

    # set a big fat global so Catalyst can pick this up
    $ENV{DOQUEUE_TEST_DATABASE} = $s;

    return $s;
}

1;
