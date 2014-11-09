package App::KdeRc::Command::Run;

# ABSTRACT: Run the command

use 5.010001;
use utf8;

use MooseX::App::Command;
use namespace::autoclean;

extends qw(App::KdeRc);

with qw(App::KdeRc::Utils);

use App::KdeRc::Resource;

sub execute {
    my ( $self ) = @_;

    my $res  = App::KdeRc::Resource->new( resource_file => $self->file );
    my $iter = $res->resource_iter;

    say "";
    say "KDE version = ", $self->kde_version;
    say "Resource:";
    say "  File        = ", $self->file;
    say "  Version     = ", $res->metadata->version;
    say "  Subversion  = ", $res->metadata->subversion;
    say "  Patch       = ", $res->metadata->patch;
    say "  Config path = ", $res->metadata->configpath;
    say "";

    while ( $iter->has_next ) {
        my $rec = $iter->next;
        $self->collect($rec);
        $rec->file('kdetest') if $self->dryrun; # overwrite output file
        $self->configure($rec, $self->dryrun);
    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;
