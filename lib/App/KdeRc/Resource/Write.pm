package App::KdeRc::Resource::Write;

# ABSTRACT: Write a resource file

use 5.010001;
use utf8;
use Moose;
use MooseX::Types::Path::Tiny qw(Path);
use namespace::autoclean;

use Try::Tiny;
use YAML::Tiny 1.57;                         # errstr deprecated

use App::KdeRc::Exceptions;

has 'resource_file' => (
    is     => 'ro',
    isa    => Path,
    coerce => 1,
);

has 'contents' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub {[]},
);

has 'metadata' => (
    is      => 'rw',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {{}},
);

sub create_yaml {
    my $self = shift;
    my $file = $self->resource_file;
    my $yaml = YAML::Tiny->new(
        {   settings => $self->contents,
            kde      => $self->metadata,
        }
    );
    unless ($file->parent->is_dir) {
        Exception::IO::PathNotFound->throw(
            message  => 'The parent dir was not found.',
            pathname => $file->parent->stringify,
        );
    }
    try   { $yaml->write($file->stringify) }
    catch {
        Exception::Config::YAML->throw(
            usermsg => "Failed to write resource file '$file'",
            logmsg  => $_,
        );
    };
    return;
}

__PACKAGE__->meta->make_immutable;

1;
