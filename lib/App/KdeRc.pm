package App::KdeRc;

# ABSTRACT: A KDE configuration helper tool

use utf8;
use Moose;
use 5.0100;

use MooseX::App qw(Color);
use MooseX::Types::Path::Tiny qw(Path File);

with qw(App::KdeRc::Role::Utils);

app_namespace 'App::KdeRc::Command';

option 'dryrun' => (
    is            => 'rw',
    isa           => 'Bool',
    documentation => q[Redirect the output to 'KDEtest.ini'.],
);

option 'verbose' => (
    is            => 'rw',
    isa           => 'Bool',
    documentation => q[Verbose output.],
);

option 'resource_file' => (
    is            => 'ro',
    isa           => File,
    required      => 1,
    coerce        => 1,
    cmd_flag      => 'in',
    documentation => q[The input YAML config file.],
);

option 'resource_reset_file' => (
    is            => 'ro',
    isa           => Path,
    required      => 0,
    coerce        => 1,
    documentation => q[The output YAML configuration reset file.],
    cmd_flag      => 'out',
);

has 'test_file_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => sub {'KDEtest.ini'},
);

has 'kde_version' => (
    is      => 'ro',
    isa     => 'Str',
    builder => '_build_kde_version',
);

sub _build_kde_version {
    my $self = shift;
    return $self->get_kde_version;
}

__PACKAGE__->meta->make_immutable;

1;
