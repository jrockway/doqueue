package DoQueue::View::TD::Wrapper;
use strict;
use warnings;

use base 'Exporter';
use Template::Declare::Tags;

our @EXPORT = qw/wrapper/;

sub top_msg($){
    my $msg = shift;
    if (c->stash->{$msg}) {
        p { 
            attr { id => $msg};
            c->stash->{$msg};
        };
    }
}

sub wrapper(&) {
    my $content = shift;
    my $title = c->stash->{title};
    $title = '[doqueue]'. ($title ? " - $title" : q{});
    
    smart_tag_wrapper {
        html {
            head {
                title { $title };
                link {
                    attr { rel  => 'stylesheet',
                           href => c->uri_for('/static/main.css'),
                           type => 'text/css',
                       };
                };
            };
            body {
                h1 { $title };
                do { top_msg $_ } for qw/error message/;
                $content->();
            };
        }
    }
}

1;
