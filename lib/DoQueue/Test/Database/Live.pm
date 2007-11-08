package DoQueue::Test::Database::Live;
use strict;
use warnings;

use DoQueue::Schema;
use Directory::Scratch;
use YAML qw(DumpFile);
use FindBin qw($Bin);

use base 'Exporter';
our @EXPORT = qw/schema/;

my $schema;
my $config;
BEGIN {
    my $tmp = Directory::Scratch->new;
    my $db  = $tmp->touch('db');

    my $dsn = "DBI:SQLite:$db";
    $schema = DoQueue::Schema->connect($dsn);
    $schema->deploy;
    $config = "$Bin/../doqueue_local.yml";
    DumpFile($config, {'Model::DBIC' => {connect_info => [$dsn]}});
}

sub schema { $schema };

END { unlink $config };

1;
