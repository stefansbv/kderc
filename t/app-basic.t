# -*- mode-cperl -*-
#
# Test the application commands, parameters and options
#
use 5.010;
use strict;
use warnings;
use Test::Most;

use App::KdeRc;

# Command: run

subtest 'Command "run" with full options' => sub {
    MooseX::App::ParsedArgv->new( argv => [qw(run --dryrun --verbose --in t/kde.yml)] );
    my $app = App::KdeRc->new_with_command();
    isa_ok( $app, 'App::KdeRc::Command::Run' );
    is( $app->dryrun, 1, 'Option "--dryrun" is set' );
    is( $app->verbose, 1, 'Option "--verbose" is set' );
    is( $app->resource_file, 't/kde.yml', 'Option "--in" is set' );
};

subtest 'Command "run" without options' => sub {
    MooseX::App::ParsedArgv->new(argv => [qw(run --in t/kde.yml)]);
    my $app = App::KdeRc->new_with_command();
    isa_ok($app, 'App::KdeRc::Command::Run');
    is( $app->dryrun, undef, 'Option "--dryrun" is not set' );
    is( $app->verbose, undef, 'Option "--verbose" is not set' );
    is( $app->resource_file, 't/kde.yml', 'Option "--in" is set' );
};

# Command: export

subtest 'Command "export" with full options' => sub {
    MooseX::App::ParsedArgv->new( argv => [qw(export --dryrun --verbose --in t/kde.yml)] );
    my $app = App::KdeRc->new_with_command();
    isa_ok( $app, 'App::KdeRc::Command::Export' );
    is( $app->dryrun, 1, 'Option "dryrun" is set' );
    is( $app->verbose, 1, 'Option "verbose" is set' );
    is( $app->resource_file, 't/kde.yml', 'Option "--in" is set' );
};

subtest 'Command "export" without options' => sub {
    MooseX::App::ParsedArgv->new( argv => [qw(export --in t/kde.yml)] );
    my $app = App::KdeRc->new_with_command();
    isa_ok( $app, 'App::KdeRc::Command::Export' );
    is( $app->dryrun, undef, 'Option "dryrun" is not set' );
    is( $app->verbose, undef, 'Option "verbose" is not set' );
    is( $app->resource_file, 't/kde.yml', 'Option "--in" is set' );
};

done_testing();

# end
