package DoQueue::Schema::Tasks;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("tasks");
__PACKAGE__->add_columns(
  "tid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "owner",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "task",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "priority",
  { data_type => "FLOAT", is_nullable => 0, size => undef },
  "due",
  { data_type => "DATETIME", is_nullable => 0, size => undef },
  "created",
  { data_type => "DATETIME", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("tid");


# Created by DBIx::Class::Schema::Loader v0.04002 @ 2007-07-28 12:08:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AX8KjrHTHdlwkPXXYf1wRw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
