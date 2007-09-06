package DoQueue::Schema::ApiKeys;
use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("api_keys");
__PACKAGE__->add_columns(
  "kid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "owner",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "key",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },                         
);
__PACKAGE__->set_primary_key("kid");
__PACKAGE__->add_unique_constraint('apikey' => [qw/key/]);
__PACKAGE__->belongs_to(owner => 'DoQueue::Schema::Users');

1;
