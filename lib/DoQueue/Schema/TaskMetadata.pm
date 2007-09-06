# Copyright (c) 2007 Jonathan Rockway <jrockway@cpan.org>

package DoQueue::Schema::TaskMetadata;
use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('task_metadata');
__PACKAGE__->add_columns(
  "mid",
  { data_type => "INTEGER", is_nullable => 0, size => undef,
    is_auto_increment => 1},
  "tid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "tag",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "value",
  { data_type => "TEXT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key('mid');
__PACKAGE__->belongs_to( task => 'DoQueue::Schema::Tasks', 'tid');

1;
