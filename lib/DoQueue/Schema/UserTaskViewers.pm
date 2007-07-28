package DoQueue::Schema::UserTaskViewers;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("user_task_viewers");
__PACKAGE__->add_columns(
  "tid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "uid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);


# Created by DBIx::Class::Schema::Loader v0.04002 @ 2007-07-28 12:08:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UxszfBywmMF5q6chCkVQTA

__PACKAGE__->set_primary_key(qw/tid uid/);

# index on tid and uid.

1;
