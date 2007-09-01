package DoQueue::View::TD::Queue;
use strict;
use warnings;

use DoQueue::View::TD::Wrapper;
use Template::Declare::Tags;

sub fmt_task($) {
    my $task = shift;
    return $task->task;
}

template show_queue => sub {
    wrapper {
        p { 'Here is '. c->stash->{user}->openid. "'s queue." };
        ul {
            while (my $task = c->stash->{queue}->next) {
                li { fmt_task $task }
            }
        }
    }
};

1;
