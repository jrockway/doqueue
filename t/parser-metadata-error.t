#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;
use DoQueue::Parser::Metadata;
use Test::TableDriven (
  error => { 'foo' => 'foo',
             'bar' => 'bar',
             '='   => '=',
           },
);

sub error {
    my $in = shift;
    eval { DoQueue::Parser::Metadata->parse($in) };
    my $error = $@;
    $error =~ m{parse error; cannot parse '(.+)' into a key/value};
    return $1 || $@;
}

runtests;
