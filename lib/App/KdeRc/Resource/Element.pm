package App::KdeRc::Resource::Element;

# ABSTRACT: Parse a resource.yml config file

use 5.010001;
use Moose;
use namespace::autoclean;

has 'file' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'group' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'subgroup' => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

has 'key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'value' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);


__PACKAGE__->meta->make_immutable;

1;
