#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 5;

use DoQueue::Test::Database::Live;
use Test::WWW::Mechanize::Catalyst 'DoQueue';
use JSON;

my $schema = schema;
my $mech = Test::WWW::Mechanize::Catalyst->new;

my $me = $schema->resultset('Users')->create({ username => 'jrockway',
                                               openid   => 'http://jrock.us/',
                                             });
my $api_key = $me->get_api_key->key;
my $task = $me->add_task('1: this is a test [foo=bar,foo=baz,bar=1]');

is $task->id, '1', 'created task 1';

$mech->add_header('X-DoqueueKey' => $api_key);
$mech->get_ok('http://localhost/api/tasks/1');
my $res = jsonToObj($mech->content);
like $res->{tasks}[0]{task}, qr/this is a test/;

$mech->get_ok('http://localhost/api/metadata/1');
$res = jsonToObj($mech->content);
is scalar @{$res->{metadata}}, 3, '3 metadata';
