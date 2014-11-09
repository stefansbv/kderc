package App::KdeRc;

# ABSTRACT: Configure KDE

use utf8;
use Moose;
use 5.0100;

use MooseX::App qw(Color);
use MooseX::Types::Path::Tiny qw(Path);
use Path::Tiny;

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
    documentation =>
        q[Path to the KDE config file.  Defaults to ./kde.yml],
    default => sub {
        my $self = shift;
        return path $self->file_name;
    },
);

has 'file_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => sub {'kde.yml'},
);

__PACKAGE__->meta->make_immutable;

1;
