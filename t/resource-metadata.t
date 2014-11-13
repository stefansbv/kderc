# -*- mode-cperl -*-
#
# Test the Resource::Metadata object
#
use 5.010;
use strict;
use warnings;
use Test::More 0.96;

use App::KdeRc::Resource::Metadata;

subtest 'Resource metadata' => sub {
    my $args = {
        version     => 4,
        subversion  => 14,
        patch       => 2,
        configpath  => '~/.kde',
        description => 'KDE test configs',
    };

    ok my $elem = App::KdeRc::Resource::Metadata->new($args), 'constructor';
    isa_ok $elem, 'App::KdeRc::Resource::Metadata';

    is $elem->version, 4, 'version is ok';
    is $elem->subversion, 14, 'subversion is ok';
    is $elem->patch, 2, 'patch is ok';
    is $elem->configpath, '~/.kde', 'config path is ok';
    like $elem->description, qr/KDE/, 'description is ok';
};

done_testing();

# end
