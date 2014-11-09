package App::KdeRc::Resource::Element;

# ABSTRACT: Parse a resource.yml config file

use 5.010001;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

subtype 'GroupArrayRef', as 'ArrayRef';
coerce  'GroupArrayRef', from 'Str', via { [ $_ ] };

has 'file' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'group' => (
    is      => 'ro',
    isa     => 'GroupArrayRef',
    coerce  => 1,
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
