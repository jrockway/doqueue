#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use DoQueue::Schema;
use YAML;

my @connect_info = @{YAML::LoadFile("$Bin/../doqueue.yml")->
                                {'Model::DBIC'}{connect_info}};

my $schema = DoQueue::Schema->connect(@connect_info) or die "Failed to connect";
$schema->deploy;
