package App::KdeRc;

# ABSTRACT: Configure KDE

use utf8;
use Moose;
use 5.0100;

use MooseX::App qw(Color);
use MooseX::Types::Path::Tiny qw(Path);
use Path::Tiny;
use File::Basename;

with qw(App::KdeRc::Role::Utils);

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

option 'file' => (
    is       => 'ro',
    isa      => Path,
    required => 1,
    coerce   => 1,
    documentation => q[Path to the YAML KDE config file.],
);

has 'test_file_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => sub {'KDEtest.ini'},
);

has 'reset_file_path' => (
    is       => 'ro',
    isa      => Path,
    required => 1,
    default  => sub {
        my $self = shift;
        my ($name, $path, $ext) = fileparse( $self->file, qr/\.[^\.]+/ );
        return path( $path, "${name}-reset$ext" );
    },
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
