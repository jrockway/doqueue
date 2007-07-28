package DoQueue::Schema::GroupTaskViewers;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("group_task_viewers");
__PACKAGE__->add_columns(
  "tid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "gid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);


# Created by DBIx::Class::Schema::Loader v0.04002 @ 2007-07-28 12:08:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Rh17TTc1xYoBjOZDxY2Wbw

__PACKAGE__->set_primary_key(qw/tid gid/);

# index tid and gid 

1;
