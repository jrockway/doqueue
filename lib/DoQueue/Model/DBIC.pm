package DoQueue::Model::DBIC;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'DoQueue::Schema',
    connect_info => [
        'DBI:SQLite:root/database',
        
    ],
);

=head1 NAME

DoQueue::Model::DBIC - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<DoQueue>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<DoQueue::Schema>

=head1 AUTHOR

Jonathan T. Rockway,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
