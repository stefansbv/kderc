# -*- mode-cperl -*-
#
# Test the Resource::Element object container
#
use 5.010;
use strict;
use warnings;
use Test::More 0.96;

use App::KdeRc::Resource::Element;

subtest 'String group attribute' => sub {
    my $args = {
        file  => 'kdeglobals',
        group => 'KDE-Global GUI Settings',
        key   => 'GraphicEffectsLevel',
        value => 0,
    };

    ok my $elem = App::KdeRc::Resource::Element->new($args), 'constructor';
    isa_ok $elem, 'App::KdeRc::Resource::Element';

    is $elem->file, 'kdeglobals', 'file attribute';
    is_deeply $elem->group, ['KDE-Global GUI Settings'], 'group attribute';
    is $elem->key, 'GraphicEffectsLevel', 'key attribute';
    is $elem->value, 0, 'value attribute';
};

subtest 'Array group attribute' => sub {
    my $args = {
        file  => 'powermanagementprofilesrc',
        group => [ 'AC', 'SuspendSession' ],
        key   => 'idleTime',
        value => '600000',
    };

    ok my $elem = App::KdeRc::Resource::Element->new($args), 'constructor';
    isa_ok $elem, 'App::KdeRc::Resource::Element';

    is $elem->file, 'powermanagementprofilesrc', 'file attribute';
    is_deeply $elem->group, [ 'AC', 'SuspendSession' ], 'group attribute';
    is $elem->key,   'idleTime', 'key attribute';
    is $elem->value, '600000',   'value attribute';
};

done_testing();

# end
