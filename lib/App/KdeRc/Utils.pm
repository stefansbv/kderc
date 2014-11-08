package App::KdeRc::Utils;

use 5.0100;
use utf8;
use Moose::Role;
use MooseX::App::Role;
use MooseX::Types::Path::Tiny qw(Path);

use Capture::Tiny ':all';
use Path::Tiny;
use YAML::Tiny;

option 'file' => (
    is       => 'ro',
    isa      => Path,
    required => 1,
    coerce   => 1,
    documentation =>
        q[Path to the KDE config file.  Defaults to ./kde.yml],
    default => sub {
        my $self = shift;
        return path $self->config_file;
    },
);

has 'config_file' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
    default  => sub {'kde.yml'},
);

sub kde_version {
    my $cmd  = 'kreadconfig';
    my @args = ('-version');
    my ( $stdout, $stderr, $exit ) = capture { system( $cmd, @args ) };
    die "Can't determine KDE version!\n Error: $stderr"     if $stderr;
    die "Can't determine KDE version! Error: exitval=$exit" if $exit != 0;
    die "Can't determine KDE version! Error: no output"     if !$stdout;
    my @version = split /\n/, $stdout;
    my $ver;
    foreach my $line (@version) {
        ($ver) = $line =~ m{((\d+\.?)+)}gm if $line =~ m{KDE};
    }
    return $ver;
}

sub configure {
    my ($self, $rec) = @_;
    my $cmd = 'kwriteconfig';
    my @args;
    push @args, '--file' , $rec->file;
    push @args, '--group', $rec->group;
    push @args, '--group', $rec->subgroup if $rec->subgroup;
    push @args, '--key'  , $rec->key;
    push @args, $rec->value;
    say "$cmd, @args" if $self->verbose;
    my ( $stdout, $stderr, $exit ) = capture { system( $cmd, @args ) };
    die "Can't execute '$cmd'!\n Error: $stderr"     if $stderr;
    die "Can't execute '$cmd'! Error: exitval=$exit" if $exit != 0;
    return;
}

1;
