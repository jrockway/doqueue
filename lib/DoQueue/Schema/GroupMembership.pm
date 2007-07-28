package DoQueue::Schema::GroupMembership;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("group_membership");
__PACKAGE__->add_columns(
  "uid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "gid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);


# Created by DBIx::Class::Schema::Loader v0.04002 @ 2007-07-28 12:08:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LbyqqVqQLy12KHBnRO8ohA

__PACKAGE__->set_primary_key('uid', 'gid');

1;
