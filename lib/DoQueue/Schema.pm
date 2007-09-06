package DoQueue::Schema;

use strict;
use warnings;

use base 'DBIx::Class::Schema';
__PACKAGE__->load_components(qw/Schema::RestrictWithObject/);
__PACKAGE__->load_classes;

sub connect {
    my $s = shift->SUPER::connect(@_);
    $s->storage->sql_maker->quote_char('`');
    $s->storage->sql_maker->name_sep('.');
    return $s;
}

1;
