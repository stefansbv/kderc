package App::KdeRc::Resource::Metadata;

# ABSTRACT: Parse a resource.yml config file

use 5.010001;
use Moose;
use namespace::autoclean;

has 'version' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'subversion' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'patch' => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

has 'configpath' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'description' => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

__PACKAGE__->meta->make_immutable;

1;
