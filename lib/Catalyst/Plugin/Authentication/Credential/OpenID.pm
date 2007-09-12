package Catalyst::Plugin::Authentication::Credential::OpenID;

use strict;
use warnings;
our $VERSION = '0.03';

use Net::OpenID::Consumer;
use LWPx::ParanoidAgent;
use Catalyst::Plugin::Authentication::User::Hash;

sub new {
    my ($class, $config, $app) = @_;
    return bless {_config => $config} => $class;
}

sub authenticate {
    my ($self, $c, $authstore, $authinfo) = @_;
    
    my $csr = Net::OpenID::Consumer->new(
        ua => LWPx::ParanoidAgent->new,
        args => $c->req->params,
        consumer_secret => sub { $_[0] },
    );

    if (my $uri = $c->req->param('claimed_uri')) {
        my $current = $c->req->uri;
        $current->query(undef); # no query
        my $identity = $csr->claimed_identity($uri)
            or Catalyst::Exception->throw($csr->err);
        my $check_url = $identity->check_url(
            return_to  => $current . '?openid-check=1',
            trust_root => $current,
            delayed_return => 1,
        );
        $c->res->redirect($check_url);
        return 0;
    } elsif ($c->req->param('openid-check')) {
        if (my $setup_url = $csr->user_setup_url) {
            $c->res->redirect($setup_url);
            return 0;
        } elsif ($csr->user_cancel) {
            return 0;
        } elsif (my $identity = $csr->verified_identity) {
            my $user = +{ map { $_ => scalar $identity->$_ }
                qw( url display rss atom foaf declared_rss 
                    declared_atom declared_foaf foafmaker ) };
            
            # lookup username=<url> or return a new user if none found
            return $authstore->find_user({openid => $identity->url}, $c) ||
              Catalyst::Plugin::Authentication::User::Hash->new($user);
        } else {
            Catalyst::Exception->throw("Error validating identity: " .
                                       $csr->err);
        }
    } else {
        return 0;
    }
}

1;
__END__

=for stopwords
    Flickr
    OpenID
    TypeKey
    app
    auth
    callback
    foaf
    foafmaker
    plugins
    rss
    url

=head1 NAME

Catalyst::Plugin::Authentication::Credential::OpenID - OpenID
credential for Catalyst Authentication framework

=head1 SYNOPSIS

  use Catalyst qw/
    Authentication
  /;

  __PACKAGE__->config->{authentication} = 
  { default_realm => 'openid',
    realms => {
        openid => {
            credential => {
                class => 'OpenID',
            },
            store => {
                class => 'Minimal',
                users => {
                   'http://jrock.us/' => { # username is their OpenID url
                       display => 'Jonathan Rockway',
                   },
                },
            }
        }
    }
  };

  # whatever in your Controller pm
  sub default : Private {
      my($self, $c) = @_;
      if ($c->user_exists) { ... }
  }

  sub signin_openid : Local {
      my($self, $c) = @_;

      if ($c->authenticate) {
          $c->res->redirect( $c->uri_for('/') );
      }
  }

  # foo.tt
  <form action="[% c.uri_for('/signin_openid') %]" method="GET">
  <input type="text" name="claimed_uri" class="openid" />
  <input type="submit" value="Sign in with OpenID" />
  </form>

=head1 DESCRIPTION

Catalyst::Plugin::Authentication::Credential::OpenID is an OpenID
credential for Catalyst::Plugin::Authentication framework.  

This plugin will pass a C<username> field set to the user's OpenID to
your store's C<find_user> method.  If C<find_user> doesn't return
anything, a new L<Catalyst::Plugin::Authentication::User::Hash> will
be returned instead of your store's user object.

=head1 METHODS

=over 4

=item authenticate

  $c->authenticate

Call this method in the action you'd like to authenticate the user via
OpenID. Returns 0 if auth is not successful, and the user object if
user is authenticated.

User class specified with I<user_class> config, which defaults to
Catalyst::Plugin::Authentication::User::Hash, will be instantiated
with the following parameters.

=over 8

=item url

=item display

=item rss

=item atom

=item foaf

=item declared_rss

=item declared_atom

=item declared_foaf

=item foafmaker

=back

See L<Net::OpenID::VerifiedIdentity> for details.

=back

=head1 DIFFERENCE WITH Authentication::OpenID

There's already Catalyst::Plugin::Authentication::OpenID
(Auth::OpenID) and this plugin tries to deprecate it.  It works with
the new Authentication API, and therefore supports realms and other
good things.

=over 4

=item *

Don't use this plugin with Auth::OpenID since method names will
conflict and your app won't work.

=item *

Auth::OpenID uses your root path (/) as an authentication callback but
this plugin uses the current path, which means you can use this plugin
with other Credential plugins, like Flickr or TypeKey.

=item *

This plugin is NOT a drop-in replacement for Auth::OpenID, but your
app needs only slight modifications to work with this one.

=item *

This plugin is based on Catalyst authentication framework, which means
you can specify I<user_class> or I<auth_store> in your app config and
this modules does the right thing, like other Credential modules. This
crates new User object if authentication is successful, and works with
Session too.

=back

=head1 AUTHOR

Six Apart, Ltd. E<lt>cpan@sixapart.comE<gt>

Jonthan Rockway C<jrockway@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Catalyst::Plugin::Authentication::OpenID>,
 L<Catalyst::Plugin::Authentication::Credential::Flickr>

=cut
