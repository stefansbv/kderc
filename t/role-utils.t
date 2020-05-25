# -*- mode-cperl -*-
#
# Test the Utils role
#
use 5.010;
use strict;
use warnings;
use Path::Tiny;
use File::HomeDir;

use Test2::V0;
use Test::Moose;
use MooseX::ClassCompositor;

use App::KdeRc;
use App::KdeRc::Resource::Element;
use App::KdeRc::Role::Utils;

my @attributes = ( qw() );
my @methods    = ( qw(kde_config_path get_kde_version kde_config_write kde_config_read quote_string test_file_path) );

my $instance;
my $class = MooseX::ClassCompositor->new( { class_basename => 'Test', } )
    ->class_for( 'App::KdeRc::Role::Utils', );
map has_attribute_ok( $class, $_ ), @attributes;
map can_ok( $class, $_ ), @methods;
# lives_ok{
    $instance = $class->new();
#} 'Test creation of an instance';

# is $instance->is_error_level('info'), 1, 'error level is info';
# is $instance->is_not_error_level('test'), 1, 'error level is not test';

like $instance->get_kde_version, qr/5|4/, 'KDE/plasma version';

my $args = {
    file  => 'kdeglobals',
    group => 'KDE-Global GUI Settings',
    key   => 'GraphicEffectsLevel',
    value => 0,
};
ok my $elem = App::KdeRc::Resource::Element->new($args), 'constructor';

my ($cmd, @args) = $instance->kde_config_prepare($elem);
like $cmd, qr/kwriteconfig/, 'the config write command match';
is \@args,
    [
        "--file",
        "kdeglobals",
        "--group",
        "KDE-Global GUI Settings",
        "--key",
        "GraphicEffectsLevel",
        "--",
    ]
    , 'the config write args match';

done_testing();

# end
