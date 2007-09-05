#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;
use Test::More tests => 11;
use DoQueue::Test::Database;
use Test::Exception;

my $schema = DoQueue::Test::Database->connect;

my $user = $schema->resultset('Users')->
  create( { openid   => 'http://jrock.us',
            username => 'jrockway',
          }
        );
          
is $user->tasks->count, 0, 'no tasks yet';

my $task;
lives_ok {
    $task = $user->add_task('1: this is a task [foo=bar,foo=baz,baz=quux]');
} 'adding a task succeeds';

throws_ok {
    $user->add_task('task [this is good]');
} qr/parse error/, 'parse error; insert fails';

eval {
    $user->add_task('task [this is good]');
};
isa_ok $@, 'DoQueue::Error::User', '$user';
like $@, qr/parse error/, 'message unboxes ok';

is $user->tasks->count, 1, 'only one task added';
is $task->owner->username, 'jrockway', 'task added for jrockway';
isa_ok $task->created, 'DateTime', 'creation time isa datetime';

my @metadata = $task->metadata_rs->all;
is scalar @metadata, 3, '3 pieces of metadata';

my $baz = $task->metadata->search({ key => 'baz' })->first;
is $baz->value, 'quux', 'baz => quux';

my $metadata = $task->metadata_hash;
is_deeply $metadata, { baz => [qw/quux/], foo => [qw/bar baz/] },
  'got expected metadata hash';
