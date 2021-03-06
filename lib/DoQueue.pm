package DoQueue;

use strict;
use warnings;

use Catalyst::Runtime '5.70';

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a YAML file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root 
#                 directory

use Catalyst qw/ConfigLoader Static::Simple
                Session::HMAC
                Authentication Authorization::ACL/;

our $VERSION = '0.01';

# Configure the application. 
#
# Note that settings in DoQueue.yml (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with a external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'DoQueue' );
__PACKAGE__->config( default_view => 'TD' );
__PACKAGE__->config( session => { key => 'hello', flash_to_stash => 1 } );

__PACKAGE__->config->{authentication} = 
 {  
  default_realm => 'openid',
  realms => {
             openid => {
                        credential => {
                                       class => 'OpenID',
                                       use_session => 1,
                                      },
                        store => {
                                  class      => 'DBIx::Class',
                                  user_class => 'DBIC::Users',
                                  id_field   => 'uid',
                                 }
                       }
            }
 };

# Start the application
__PACKAGE__->setup;

my $valid_user = sub {
    my ($c, $action) = @_;
    if (eval{$c->user->username}) {
        die $Catalyst::Plugin::Authorization::ACL::Engine::ALLOWED;
    }
    else {
        die $Catalyst::Plugin::Authorization::ACL::Engine::DENIED;
    }
};

__PACKAGE__->acl_add_rule('/queue', $valid_user);
__PACKAGE__->acl_add_rule('/task', $valid_user);
__PACKAGE__->allow_access('/');
__PACKAGE__->allow_access('/api'); # handles its own ACL
__PACKAGE__->allow_access('/account');

=head1 NAME

DoQueue - Catalyst based application

=head1 SYNOPSIS

    script/doqueue_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<DoQueue::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Jonathan T. Rockway,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
