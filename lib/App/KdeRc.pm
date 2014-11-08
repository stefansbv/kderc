package App::KdeRc;

# ABSTRACT: Configure KDE

use utf8;
use Moose;
use 5.0100;

use MooseX::App qw(Color);

app_namespace 'App::KdeRc::Command';

option 'dryrun' => (
    is            => 'rw',
    isa           => 'Bool',
    documentation => q[Simulate run commands.  Output to kdetest.],
);

option 'verbose' => (
    is            => 'rw',
    isa           => 'Bool',
    documentation => q[Verbose output.],
);

__PACKAGE__->meta->make_immutable;

1;
