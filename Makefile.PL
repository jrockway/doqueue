use inc::Module::Install;

name 'DoQueue';
all_from 'lib/DoQueue.pm';

requires 'Catalyst' => '5.7007';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'YAML'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
#requires 'DateTime';
requires 'Catalyst::View::Template::Declare';
requires 'Catalyst::Model::DBIC::Schema';
requires 'DBD::SQLite';
#requires 'DateTime::Format::MySQL';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;