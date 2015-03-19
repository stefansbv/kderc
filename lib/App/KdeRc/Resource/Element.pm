package App::KdeRc::Resource::Element;

# ABSTRACT: Parse a resource.yml config file

use 5.010001;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

with qw(MooseX::Clone);

subtype 'GroupArrayRef', as 'ArrayRef';
coerce  'GroupArrayRef', from 'Str', via { [ $_ ] };

has 'file' => (
    is       => 'rw',
    isa      => 'Str',
    traits   => [qw(Clone)],
    required => 1,
);

has 'group' => (
    is      => 'ro',
    isa     => 'GroupArrayRef',
    traits  => [qw(Clone)],
    coerce  => 1,
);

has 'key' => (
    is       => 'ro',
    isa      => 'Str',
    traits   => [qw(Clone)],
    required => 1,
);

has 'value' => (
    is       => 'rw',
    isa      => 'Str',
    traits   => [qw(Clone)],
    required => 1,
);

has 'type' => (
    is       => 'rw',
    isa      => enum( [qw(bool string)] ),
    traits   => [qw(Clone)],
    required => 0,
);


__PACKAGE__->meta->make_immutable;

1;
