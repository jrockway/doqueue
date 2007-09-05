#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;
use DoQueue::Parser::Metadata;
use Test::TableDriven (
  meta => { q{}                  => {},
            'foo=bar'            => { foo => ['bar'] },
            'Foo bar = baz quux' => { 'Foo bar' => ['baz quux'] },
            'foo=bar,bar=baz'    => { foo => ['bar'], bar => ['baz'] },
            'foo=bar,foo=baz'    => { foo => [qw/bar baz/] },
            'foo =bar,Quux= baz' => { foo => ['bar'], 'Quux' => ['baz']},
            'a  =b'              => { a => ['b'] },
            'a =b'               => { a => ['b'] },
            'a =b,     a=    b'  => { a => [('b')x2] },
            ' a= b'              => { a => ['b'] },
          },
);

sub meta {
    my $in = shift;
    return DoQueue::Parser::Metadata->parse($in);
}

runtests;
