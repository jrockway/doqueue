package DoQueue::View::TD::Queue;
use strict;
use warnings;

use DoQueue::View::TD::Wrapper;
use Template::Declare::Tags;
use Graphics::ColorUtils;

sub fmt_metadata($) {
    my $metadata = shift;
    return if keys %$metadata == 0;
    
    span {
        attr { class => 'task_metadata'};
        ul {
            attr { class => 'metadata' };
            foreach my $key (keys %$metadata){
                foreach my $value (@{$metadata->{$key}}){
                    my $color = 
                      c->session->{colors}{"$key|$value"} ||= 
                        hsv2rgb((c->session->{color_idx}++*101)%360, .3, 1);
                    li {
                        span {
                            attr { class => "one_metadata",
                                   style => "background-color: $color"};
                            "$key=$value";
                        }
                    }
                }
            }
        };
    };
}

sub fmt_task($) {
    my $task = shift;
    div { 
        attr { class => 'task' }; 
        span {
            no warnings 'uninitialized';
            my $class = 'task_text';
            $class .= ' added' if $task->id == c->stash->{added_id};

            attr { class => $class };
            outs($task->task);
        };
        fmt_metadata $task->metadata_hash;
    }
}

sub add_task_form() {
    div {
        attr { class => 'add_new_task' };
        form { 
            attr { name   => 'add_new_task', 
                   action => c->uri_for('/queue/add'),
                   method => 'post',
                   };
            
            label {
                attr { for => 'task' };
                "Add a task:";
            };
            input { 
                attr { type => 'text',
                       name => 'task',
                       id   => 'task',
                   };
            };
            input {
                attr { type  => 'submit',
                       name  => 'submit',
                       value => 'Go',
                   }
            }
        }
    }
}

sub task_links($){
    my $task = shift;
    p {
        attr { class => 'task_links' };
        my $id = $task->id;
        
        if ($task->deleted) {
            a { 
                attr { 
                    href => c->uri_for("/task/$id/reopen");
                };
                'Reopen'
            };
            a { 
                attr { 
                    href => c->uri_for("/task/$id/blow_away");
                };
                'Delete forever'
            }
        }
        else {
            a { 
                attr { 
                    href => c->uri_for("/task/$id/close"),
                    class => 'close',
                };
                'Close'
            };
            a { 
                attr { 
                    href => c->uri_for("/task/$id/edit");
                };
                'Edit'
            };
        }
    }
}

sub render_tasks {
    div {
        attr { id => 'my_queue' };
        my @tasks = @{c->stash->{tasks}};
        if (@tasks) {
            ul {
                foreach my $task (@tasks) {
                    li { 
                        fmt_task $task;
                        task_links $task;
                    }
                }
            }
        }
        else {
            "No deleted tasks!  Get to work!";
        }
    }
}

template 'queue/show' => sub {
    wrapper {
        my $user = c->stash->{user}->username ."'s";
        $user = 'your' if c->stash->{user}->id == c->user->id; 
        my $queue = 'doqueue';
        $queue = 'deleted tasks' if (c->stash->{showing_deleted});
        p { "Here's $user $queue." };
        
        if (!@{c->stash->{tasks}} && !c->stash->{showing_deleted}) {
            p { "Your life is meaningless!  You have nothing to do!" }
        }
        else {
            render_tasks();
        }
        add_task_form;

        if (c->stash->{showing_deleted}) {
            a {
                attr { href => c->uri_for("/my/queue") };
                'Back to your open tasks'
            }
        }
        elsif (c->stash->{tasks_rs}->deleted->count > 0){
            a {
                my $id = c->user->id;
                attr { href => c->uri_for("/queue/$id/deleted") };
                'View deleted tasks'
            }
        } 
    }
};

1;
