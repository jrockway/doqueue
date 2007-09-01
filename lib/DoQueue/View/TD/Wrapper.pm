package DoQueue::View::TD::Wrapper;
use strict;
use warnings;

use base 'Exporter';
use Template::Declare::Tags;

our @EXPORT = qw/wrapper/;

sub wrapper(&) {
    my $content = shift;
    my $title = c->stash->{title};
    $title = 'doQueue'. ($title ? " - $title" : q{});
    
    smart_tag_wrapper {
        html {
            head {
                title { $title }
            };
            body {
                h1 { $title };
                $content->();
            };
        }
    }
}

1;
