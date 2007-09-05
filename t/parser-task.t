#!/usr/bin/env perl
# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

use strict;
use warnings;
use DoQueue::Parser::Task;
use Test::TableDriven (
  parse => { 
            'test todo' 
            => { order    => 0,
                 task     => 'test todo',
                 metadata => {}
               },
            
            'test todo [foo=bar]' 
            => { order    => 0,
                 task     => 'test todo',
                 metadata => { foo => ['bar'] },
               },

            '24: test todo [foo=bar]' 
            => { order    => 24,
                 task     => 'test todo',
                 metadata => { foo => ['bar'] },
               },

            '24: test todo'
            => { order    => 24,
                 task     => 'test todo',
                 metadata => {},
               },
           },
                       
);

sub parse {
    return DoQueue::Parser::Task->parse($_[0]);
}

runtests;
