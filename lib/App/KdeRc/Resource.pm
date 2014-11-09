package App::KdeRc::Resource;

# ABSTRACT: Read a kde.yml config file

use 5.010001;
use utf8;

use Moose;
use MooseX::Iterator;
use MooseX::Types::Path::Tiny qw(Path);
use namespace::autoclean;

use YAML::Tiny;
use Try::Tiny;

use App::KdeRc::Resource::Read;
use App::KdeRc::Resource::Write;
use App::KdeRc::Resource::Element;
use App::KdeRc::Resource::Metadata;

has count => (
    traits  => ['Counter'],
    is      => 'rw',
    isa     => 'Int',
    default => 0,
    handles => {
        inc_counter => 'inc',
    },
);

has _resource => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_build_resource'
);

sub _build_resource {
    my $self = shift;
    my $contents = try { $self->reader->contents }
    catch {
        $self->reader_exception($_);
    };
    $contents = [] unless ref $contents; # recover
    my @records;
    foreach my $res ( @{ $contents } ) {
        push @records, App::KdeRc::Resource::Element->new($res);
        $self->inc_counter;
    }
    return \@records;
}

has 'metadata' => (
    is      => 'ro',
    isa     => 'App::KdeRc::Resource::Metadata',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $meta = try { $self->reader->metadata }
        catch {
            $self->reader_exception($_);
        };
        return App::KdeRc::Resource::Metadata->new($meta);
    },
);

has 'resource_iter' => (
    metaclass    => 'Iterable',
    iterate_over => '_resource',
);

has 'resource_file' => (
    is  => 'rw',
    isa => Path,
);

has 'reader' => (
    is      => 'rw',
    isa     => 'App::KdeRc::Resource::Read',
    lazy    => 1,
    default => sub {
        my $self = shift;
        App::KdeRc::Resource::Read->new(
            resource_file => $self->resource_file );
    },
);

has 'writer' => (
    is      => 'rw',
    isa     => 'App::KdeRc::Resource::Write',
    lazy    => 1,
    default => sub {
        my $self = shift;
        App::KdeRc::Resource::Write->new(
            resource_file => $self->resource_file );
    },
);

sub reader_exception {
    my ( $self, $exception ) = @_;
    if ( my $e = Exception::Base->catch($exception) ) {
        if ( $e->isa('Exception::IO') ) {
            say "[EE] ", $e->message, ' : ', $e->pathname;
        }
        elsif ( $e->isa('Exception::Config::YAML') ) {
            say "[EE] ", $e->usermsg, ' ', $e->logmsg;
        }
        else {
            say "[EE] Unknown exception: $_";
        }
    }
    return;
}

__PACKAGE__->meta->make_immutable;

1;

=head1 DESCRIPTION

Build an iterable data structure from a L<resource.yml> file.  The
elements of the data structure are Resource::Element objects.

=head1 ATTRIBUTES

=head2 _resource

An array reference containing the Resource::Element objects.

=head2 resource_file

A path string to a L<resource.yml> file.

=head2 resource_iter

A meta class attribute for the itertor.

=head3 count

A count attribute for the number of resource elements.

=cut
