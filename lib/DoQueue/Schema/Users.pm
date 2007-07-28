package DoQueue::Schema::Users;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "uid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "openid",
  { data_type => "TEXT", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("uid");


# Created by DBIx::Class::Schema::Loader v0.04002 @ 2007-07-28 12:08:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g4CZqaC3pkV9I9xnX3ssNg

__PACKAGE__->add_unique_constraint(openid => [qw/openid/]);
__PACKAGE__->has_many(tasks => 'DoQueue::Schema::Tasks', 'owner');

1;
