use inc::Module::Install;

name 'DoQueue';
all_from 'lib/DoQueue.pm';

requires 'Catalyst' => '5.7007';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'YAML';
requires 'DateTime';
requires 'Catalyst::View::Template::Declare' => '0.02';
requires 'Catalyst::Model::DBIC::Schema';
requires 'DBIx::Class';
requires 'DBD::SQLite';
requires 'DateTime::Format::MySQL';
requires 'Catalyst::Controller::BindLex';
requires 'Catalyst::Controller::FormBuilder';
requires 'Catalyst::Plugin::Authentication::Credential::OpenID' => '0.03';
requires 'Catalyst::Plugin::Authentication' => '0.10';
requires 'Catalyst::Plugin::Authentication::Store::DBIx::Class';
requires 'Graphics::ColorUtils';
requires 'Catalyst::Plugin::Authorization::ACL';
requires 'Crypt::Random';
requires 'Catalyst::Controller::REST';

build_requires 'Test::TableDriven';
build_requires 'Test::More';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
