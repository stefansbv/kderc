# -*- mode-cperl -*-
#
# Test the Resource Read module
#
use 5.010;
use strict;
use warnings;
use Test::More 0.96;

use App::KdeRc::Resource::Read;
use App::KdeRc::Resource::Element;

ok my $reader = App::KdeRc::Resource::Read->new(
    resource_file => 't/kde.yml'
), 'read a test resource file';

subtest 'Element no 1' => sub {
    my $res1 = $reader->contents->[0];
    ok my $elem = App::KdeRc::Resource::Element->new($res1), 'constructor';
    isa_ok $elem, 'App::KdeRc::Resource::Element';

    is $elem->file, 'kdeglobals', 'file attribute';
    is_deeply $elem->group, ['KDE-Global GUI Settings'], 'group attribute';
    is $elem->key, 'GraphicEffectsLevel', 'key attribute';
    is $elem->value, 0, 'value attribute';
};

subtest 'Element no 2' => sub {
    my $res1 = $reader->contents->[1];
    ok my $elem = App::KdeRc::Resource::Element->new($res1), 'constructor';
    isa_ok $elem, 'App::KdeRc::Resource::Element';

    is $elem->file, 'powermanagementprofilesrc', 'file attribute';
    is_deeply $elem->group, [ 'AC', 'SuspendSession' ], 'group attribute';
    is $elem->key,   'idleTime', 'key attribute';
    is $elem->value, '600000',   'value attribute';
};

done_testing();

# end
