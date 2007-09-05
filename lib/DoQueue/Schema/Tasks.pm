package DoQueue::Schema::Tasks;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table('tasks');
__PACKAGE__->add_columns(
  "tid",
  { data_type => "INTEGER",  is_nullable => 0, size => undef },
  "owner",
  { data_type => "INTEGER",  is_nullable => 0, size => undef },
  "task",
  { data_type => "TEXT",     is_nullable => 0, size => undef },
  "priority",
  { data_type => "INTEGER",  is_nullable => 0, size => undef },
  "created",
  { data_type => "DATETIME", is_nullable => 0, size => undef },
  "private",
  { data_type => "BOOLEAN", is_nullable => 1, size => undef },
);
__PACKAGE__->set_primary_key('tid');

__PACKAGE__->belongs_to(owner => 'DoQueue::Schema::Users');
__PACKAGE__->has_many(metadata => 'DoQueue::Schema::TaskMetadata', 'tid');

# This syntax doesn't exist yet :)
# __PACKAGE__->add_index('idx_tasks_perowner' => [qw/owner/]);

sub metadata_hash {
    my $self = shift;
    my $metadata_rs = $self->search_related('metadata');

    my %result;
    while (my $datum = $metadata_rs->next) {
        my ($key, $value) = map { $datum->$_ } qw/key value/;
        $result{$key} ||= [];
        push @{$result{$key}}, $value;
    }
    return \%result;
}

1;
