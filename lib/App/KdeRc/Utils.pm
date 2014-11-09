package App::KdeRc::Utils;

use 5.0100;
use utf8;
use Moose::Role;
use MooseX::App::Role;

use Capture::Tiny ':all';
use YAML::Tiny;

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
    my ($self, $rec, $dryrun) = @_;
    my $cmd = 'kwriteconfig';
    my @args;
    push @args, '--file', quote_string($rec->file);
    push @args, '--group', quote_string($_) foreach @{$rec->group};
    push @args, '--key', quote_string($rec->key);
    push @args, quote_string($rec->value);
    # say "# $cmd @args" if $dryrun;
    my ( $stdout, $stderr, $exit ) = capture { system( $cmd, @args ) };
    die "Can't execute '$cmd'!\n Error: $stderr"     if $stderr;
    die "Can't execute '$cmd'! Error: exitval=$exit" if $exit != 0;
    return;
}

sub collect {
    my ($self, $rec) = @_;
    my $cmd = 'kreadconfig';
    my @args;
    push @args, '--file', quote_string($rec->file);
    push @args, '--group', quote_string($_) foreach @{$rec->group};
    push @args, '--key', quote_string($rec->key);
    my ( $stdout, $stderr, $exit ) = capture { system( $cmd, @args ) };
    chomp $stdout;
    # TODO: Export as shell script
    say "#C: $cmd @args";
    say "#R: $stdout";
    say "#W: ", quote_string($rec->value);
    say "";
    die "Can't execute '$cmd'!\n Error: $stderr"     if $stderr;
    die "Can't execute '$cmd'! Error: exitval=$exit" if $exit != 0;
    return;
}

sub quote_string {
    my $str = shift;
    $str = qq{$str} if $str =~ m{\s};
    return $str;
}

1;
