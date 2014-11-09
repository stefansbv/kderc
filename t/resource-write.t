# -*- mode-cperl -*-
#
# Test the Resource Write module
#
use 5.010;
use strict;
use warnings;
use Test::Most;

use App::KdeRc::Resource::Write;

my $file = 't/new-kde.yml';

unlink $file;                                # cleanup

subtest 'Test write to yml file' => sub {

    ok my $rw = App::KdeRc::Resource::Write->new( resource_file => $file ),
        'write a test resource file';

    is $rw->resource_file, $file, 'has resource file name';
    is $rw->resource_file->is_file, undef, 'resource file does not exists';

    my $data = {
        settings => [
            {   group => [ 'AC', 'SuspendSession' ],
                value => '600000',
                file  => 'powermanagementprofilesrc',
                key   => 'idleTime'
            },
        ],
        kde => {
            version    => '4',
            patch      => '2',
            configpath => '~/.kde',
            subversion => '14'
        }
    };

    ok $rw->metadata( $data->{kde} ), 'write metadata';
    ok $rw->contents( $data->{settings} ), 'write contents';

    lives_ok { $rw->create_yaml } 'write resource file';
};

done_testing();

# end
