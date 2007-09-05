package DoQueue::Schema::Users;

use strict;
use warnings;

use DateTime;
use DoQueue::Error::User;
use DoQueue::Parser::Task;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "uid",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "openid",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "username",
  { data_type => "TEXT", is_nullable => 1, size => undef },
);
__PACKAGE__->set_primary_key("uid");
__PACKAGE__->add_unique_constraint(openid   => [qw/openid/]);
__PACKAGE__->add_unique_constraint(username => [qw/username/]);
__PACKAGE__->has_many(tasks => 'DoQueue::Schema::Tasks', 'owner');

sub add_task {
    my ($self, $task_def) = @_;
    
    # parse the task definition
    my $task = eval { DoQueue::Parser::Task->parse($task_def) };
    DoQueue::Error::User->throw($@) if $@;
    
    my $add_task = sub {
        my $created_task = $self->
          create_related(tasks => { task     => $task->{task},
                                    priority => $task->{order},
                                    created  => DateTime->now,
                                    private  => 0,
                                 });
        foreach my $key (keys %{$task->{metadata}}) {
            foreach my $value (@{$task->{metadata}{$key}}) {
                $created_task->
                  create_related(metadata => { key   => $key,
                                               value => $value,
                                             });
            }
        }
        return $created_task;
    };
    
    return $self->result_source->storage->txn_do($add_task);
}

1;
