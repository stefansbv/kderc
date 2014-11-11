package App::KdeRc::Command::Run;

# ABSTRACT: Run the command

use 5.010001;
use utf8;

use MooseX::App::Command;
use namespace::autoclean;

with qw(MooseX::Clone);

extends qw(App::KdeRc);

use App::KdeRc::Resource;

sub execute {
    my ( $self ) = @_;

    my $res = App::KdeRc::Resource->new(
        resource_file => $self->resource_file );
    my $iter = $res->resource_iter;

    say "";
    say "# KDE version: ", $self->kde_version;
    say "# Resource   : ";
    say "#   file        : ", $self->resource_file;
    say "#   KDE version : ", $res->metadata->version
        .'.'. $res->metadata->subversion
        .'.'. $res->metadata->patch;
    say "#   config path : ", $res->metadata->configpath;
    say '#   config count: ', $res->count;
    say "";

    my @origs;
    while ( $iter->has_next ) {
        my $rec  = $iter->next;
        my $orig = $rec->clone;
        my $current_value = $self->kde_config_read($rec);
        $orig->value($current_value);
        push @origs, $orig;
        $rec->file( $self->test_file_name )
            if $self->dryrun;    # overwrite output file
        $self->kde_config_write($rec, $self->dryrun);
    }

    $self->kde_config_write_reset( $res, @origs );

    say "Output file path [dry-run]: ", $self->test_file_path->stringify
        if $self->dryrun;

    return;
}

sub kde_config_write_reset {
    my ($self, $res, @data) = @_;
    my $metadata = {
        configpath => $res->metadata->configpath,
        patch      => $res->metadata->patch,
        subversion => $res->metadata->subversion,
        version    => $res->metadata->version,
    };
    my @settings;
    foreach my $rec (@data) {
        push @settings, {
            file  => $rec->file,
            group => $rec->group,
            key   => $rec->key,
            value => $rec->value,
        };
    }
    $res->writer->metadata($metadata);
    $res->writer->contents(\@settings);
    $res->writer->create_yaml;
    my $reset_file = $res->reset_file_path;
    say "Wrote reset file: $reset_file.";
    return;
}

__PACKAGE__->meta->make_immutable;

1;
