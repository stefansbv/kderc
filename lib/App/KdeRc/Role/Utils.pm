package App::KdeRc::Role::Utils;

# ABSTRACT: KdeRc utilities

use 5.0100;
use utf8;
use Moose::Role;
use MooseX::App::Role;
use Capture::Tiny ':all';
use YAML::Tiny;
use Path::Tiny;
use File::Which qw(which where);

# kde4-config --localprefix -> /home/user/.kde/

sub kde_config_path {
    my $self = shift;
    my $major = $self->get_kde_version_major;
    if ( $major == 4 ) {
        my $cmd  = 'kde4-config';
        my @args = ( '--path', 'config' );
        my ( $stdout, $stderr, $exit ) = capture { system( $cmd, @args ) };
        die "Can't determine KDE config path!\n Error: $stderr" if $stderr;
        die "Can't determine KDE config path! Error: exitval=$exit"
            if $exit != 0;
        die "Can't determine KDE config path! Error: no output" if !$stdout;
        foreach my $path ( split /:/, $stdout ) {
            return $path if $path =~ m{^/home};
        }
    }
    if ( $major == 5 ) {
        return '~/.config';
    }
}

sub get_kde_version {
    my $self = shift;
    my @cmds = (
        [ 'kde4-config', '--kde-version' ],
        [ 'plasmashell', '--version' ],
    );
    foreach my $rec ( (@cmds) ) {
        my $cmd      = shift @{$rec};
        my $cmd_path = which $cmd;
        if ($cmd_path) {
            my @args = @{$rec};
            my ( $version, $stderr, $exit )
                = capture { system( $cmd, @args ) };
            die "Can't determine KDE version!\n Error: $stderr" if $stderr;
            die "Can't determine KDE version! Error: exitval=$exit"
                if $exit != 0;
            die "Can't determine KDE version! Error: no output" if !$version;
            chomp $version;
            $version =~ s/plasmashell\s//;
            my @parts = split /[.]/, $version;
            return \@parts;
        }
    }
}

sub get_kde_version_major {
    my $self = shift;
    return $self->get_kde_version->[0];
}

sub kde_config_prepare {
    my ($self, $rec) = @_;
    my $cmd = $self->get_kde_version_major == 5 ? 'kwriteconfig5' : 'kwriteconfig';
    my @args;
    push @args, '--file', quote_string($rec->file);
    push @args, '--group', quote_string($_) foreach @{$rec->group};
    push @args, '--key', quote_string($rec->key);
    push @args, '--type', quote_string($rec->type) if $rec->type;
    push @args, '--';
    push @args, quote_string($rec->value);
    return ($cmd, @args);
}

sub kde_config_write {
    my ($self, $rec) = @_;
    my ($cmd, @args) = $self->kde_config_prepare($rec);
    say "# $cmd @args" if $self->verbose;
    my ( $stdout, $stderr, $exit ) = capture { system( $cmd, @args ) };
    die "Can't execute '$cmd'!\n Error: $stderr"     if $stderr;
    die "Can't execute '$cmd'! Error: exitval=$exit" if $exit != 0;
    return;
}

sub kde_config_read {
    my ($self, $rec) = @_;
    my $cmd = $self->get_kde_version_major == 5 ? 'kreadconfig5' : 'kreadconfig';
    my @args;
    push @args, '--file', quote_string($rec->file);
    push @args, '--group', quote_string($_) foreach @{$rec->group};
    push @args, '--key', quote_string($rec->key);
    my ( $stdout, $stderr, $exit ) = capture { system( $cmd, @args ) };
    chomp $stdout;
    die "Can't execute '$cmd'!\n Error: $stderr"     if $stderr;
    die "Can't execute '$cmd'! Error: exitval=$exit" if $exit != 0;
    return $stdout;
}

sub quote_string {
    my $str = shift;
    return unless $str;
    $str    = qq{$str} if $str =~ m{\s};
    return $str;
}

sub test_file_path {
    my $self = shift;
    return path $self->kde_config_path, $self->test_file_name;
}

1;
