package DoQueue::Schema::ApiKeys;
use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("api_keys");
__PACKAGE__->add_columns(
  "owner",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "apikey",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },                         
);

__PACKAGE__->set_primary_key("apikey");
__PACKAGE__->belongs_to(owner => 'DoQueue::Schema::Users');
1;
