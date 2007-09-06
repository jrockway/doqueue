#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 9;
use DoQueue::Test::Database;
use DateTime;

my $s = DoQueue::Test::Database->connect;
sub rs { $s->resultset($_[0]) }

my $me  = rs('Users')->create({ openid => 'http://www.jrock.us/' });
my $foo = rs('Users')->create({ openid => 'http://example.com/foo' });

## user has tasks

# none yet
is_deeply([$me->tasks], [], 'no tasks for me yet');
is_deeply([$foo->tasks], [], 'no tasks for foo yet');

# create some
my $common = { created => DateTime->now, priority => 0 };

my $task1 = rs('Tasks')->create({ %$common,
                                  owner => $me,
                                  task  => 'do some stuff',
                                });

my $task2 = rs('Tasks')->create({ %$common,
                                  owner => $foo,
                                  task  => 'stuff for foo'
                                });

my $task3 = rs('Tasks')->create({ %$common,
                                  owner => $foo,
                                  task => 'more stuff for foo'
                                });

# check again
my @me_g  = sort map {$_->task} ($me->tasks);
my @me_e  = ('do some stuff');

my @foo_g = sort map {$_->task} ($foo->tasks);
my @foo_e = sort ('more stuff for foo', 'stuff for foo');

is_deeply(\@me_g, \@me_e, 'got tasks for me');
is_deeply(\@foo_g, \@foo_e, 'got tasks for foo');

# tasks have owner
sub cp { $_[0]->openid cmp $_[1]->openid }
is(0, cp($task1->owner, $me),  'task1 owner is me');
is(0, cp($task2->owner, $foo), 'task2 owner is foo');
is(0, cp($task2->owner, $foo), 'task2 owner is foo');

# try some metadata
my $metadata = rs('TaskMetadata')->create({ task  => $task3,
                                            tag   => 'key',
                                            value => 'value',
                                          });

is($metadata->task->task, 'more stuff for foo', 'metadata knows about task');
is([$task3->metadata]->[0]->tag, 'key', 'got key == key for metadata');

