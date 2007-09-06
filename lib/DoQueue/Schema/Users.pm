package DoQueue::Schema::Users;

use strict;
use warnings;

use DateTime;
use DoQueue::Error::User;
use DoQueue::Parser::Task;
use Crypt::Random qw(makerandom);

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "uid",
  { data_type => "INTEGER", is_nullable => 0, size => undef,
    is_auto_increment => 1},
  "openid",
  { data_type => "VARCHAR", is_nullable => 0, size => 64 },
  "username",
  { data_type => "VARCHAR", is_nullable => 1, size => 64 },
);
__PACKAGE__->set_primary_key("uid");
__PACKAGE__->add_unique_constraint(url  => [qw/openid/]);
__PACKAGE__->add_unique_constraint(name => [qw/username/]);
__PACKAGE__->has_many(tasks => 'DoQueue::Schema::Tasks', 'owner');
__PACKAGE__->has_many(api_keys => 'DoQueue::Schema::ApiKeys', 'owner');

# restricted resultsets for use with Catalyst
sub restrict_Tasks_resultset {
    my $self = shift;
    return $self->related_resultset('tasks');
}

sub restrict_TaskMetadata_resultset {
    my $self = shift;
    my $unrestricted = shift;
    return $unrestricted->search_rs( { 'task.owner' => $self->id },
                                     { join => [qw/task/] }
                                   );
}

sub restrict_ApiKeys_resultset {
    my $self = shift;
    return $self->related_resultset('api_keys');
}

sub restrict_Users_resultset {
    my $self = shift;
    my $unrestricted = shift;
    # only allow user to see himself (TODO: friends)
    return $unrestricted->search_rs( { uid => $self->uid } );
}

sub get_api_key {
    my $self = shift;
    my $rand = makerandom( Size => 128, Strength => 0);
    return $self->create_related(api_keys => { apikey => "$rand" });
}

sub add_task {
    my ($self, $task_def) = @_;
    
    # parse the task definition
    my $parsed_task = eval { DoQueue::Parser::Task->parse($task_def) };
    DoQueue::Error::User->throw($@) if $@;
    
    my $add_task = sub {
        # rewrite priorities
        my $tasks = $self->related_resultset('tasks')->active;
        my $i = 0;
        while (my $task = $tasks->next) {
            $task->update({ priority => $i * 2 + 1});
            $i++;
        }
        
        my $created_task = $self->
          create_related(tasks => { task     => $parsed_task->{task},
                                    priority => $parsed_task->{order},
                                    created  => DateTime->now,
                                    private  => 0,
                                 });
        
        foreach my $key (keys %{$parsed_task->{metadata}}) {
            foreach my $value (@{$parsed_task->{metadata}{$key}}) {
                $created_task->
                  create_related(metadata => { tag   => $key,
                                               value => $value,
                                             });
            }
        }
        return $created_task;
    };
    
    return $self->result_source->storage->txn_do($add_task);
}

1;
