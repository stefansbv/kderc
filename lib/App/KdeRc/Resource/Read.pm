package App::KdeRc::Resource::Read;

# ABSTRACT: Read a 'kde.yml' file

use 5.010001;
use utf8;
use Moose;
use MooseX::Types::Path::Tiny qw(Path);
use namespace::autoclean;

use YAML::Tiny 1.57;                         # errstr deprecated
use Try::Tiny;

use App::KdeRc::Exceptions;

has 'resource_file' => (
    is     => 'ro',
    isa    => Path,
    coerce => 1,
);

has 'contents' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_build_contents'
);

has 'metadata' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {{}},
);

sub _build_contents {
    my $self = shift;
    my $file = $self->resource_file;
    return [] unless $file->is_file;
    my $yaml = try { YAML::Tiny->read( $file->stringify ) }
    catch {
        Exception::Config::YAML->throw(
            usermsg => 'Failed to load the resource file.',
            logmsg  => $_,
        );
    };
    $self->metadata( $yaml->[0]{kde} );
    return $yaml->[0]{settings};
}

__PACKAGE__->meta->make_immutable;

1;
