package App::KdeRc::Command::Export;

# ABSTRACT: Export as shell script

use 5.010001;
use utf8;
use Path::Tiny;
use MooseX::App::Command;
use namespace::autoclean;

extends qw(App::KdeRc);

use App::KdeRc::Resource;

sub execute {
    my ( $self ) = @_;

    my $res = App::KdeRc::Resource->new(
        resource_file => $self->resource_file,
    );
    my $iter = $res->resource_iter;

    say "";
    say "KDE version = ", $self->kde_version_string;
    say "Resource:";
    say "  File        = ", $self->resource_file;
    say "  Version     = ", $res->metadata->version;
    say "  Subversion  = ", $res->metadata->subversion;
    say "  Patch       = ", $res->metadata->patch;
    say "  Config path = ", $res->metadata->configpath;
    say "";

    my @cmds;
    while ( $iter->has_next ) {
        my $rec = $iter->next;
        my ($cmd, @args) = $self->kde_config_prepare($rec);
        push @cmds, "$cmd @args\n";
    }
    $self->export_script(@cmds);

    return;
}

sub export_script {
    my ($self, @cmds) = @_;

    # Add a header and a footer
    unshift @cmds, "#!bin/bash\n#\n# Generated using App::KdeRc\n\n";
    push    @cmds, "\n";

    path("file.sh")->spew(@cmds);
    return;
}

__PACKAGE__->meta->make_immutable;

1;
