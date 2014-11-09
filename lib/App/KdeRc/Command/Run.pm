package App::KdeRc::Command::Run;

# ABSTRACT: Run the command

use 5.010001;
use utf8;
use Data::Dump;

use MooseX::App::Command;
use namespace::autoclean;

extends qw(App::ConfigManager);

with qw(App::KdeRc::Utils);

use App::KdeRc::Resource;

sub execute {
    my ( $self ) = @_;

    say '=== Runing';

    my $file = $self->file;
    say "Resource = $file";
    my $res  = App::KdeRc::Resource->new( resource_file => $file);
    my $iter = $res->resource_iter;
    while ( $iter->has_next ) {
        my $rec = $iter->next;
        $rec->file('kdetest') if $self->dryrun;
        $self->configure($rec, $self->dryrun);
    }

    say "";
    say "Version     = ", $res->metadata->version;
    say "Subversion  = ", $res->metadata->subversion;
    say "Patch       = ", $res->metadata->patch;
    say "Config path = ", $res->metadata->configpath;
    say "";
    say "KDE version = ", $self->kde_version;

    return;
}

__PACKAGE__->meta->make_immutable;

1;
