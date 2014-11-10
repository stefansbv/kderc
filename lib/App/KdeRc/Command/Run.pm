package App::KdeRc::Command::Run;

# ABSTRACT: Run the command

use 5.010001;
use utf8;

use MooseX::App::Command;
use namespace::autoclean;

extends qw(App::KdeRc);

use App::KdeRc::Resource;
use App::KdeRc::Resource::Write;

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

        my $current_value = $self->kde_config_read($rec);

        $rec->file( $self->test_file_name )
            if $self->dryrun;    # overwrite output file

        $self->kde_config_write($rec, $self->dryrun);
    }

    # Test
    $self->write_reset_file;

    say "Output file path: ", $self->test_file_path->stringify
        if $self->dryrun;

    return;
}

sub write_reset_file {
    my $self = shift;

    my $reset = $self->reset_file_path;

    my $rw = App::KdeRc::Resource::Write->new( resource_file => $reset );

    # Test data
    my $data = {
        settings => [
            {   group => [ 'AC', 'SuspendSession' ],
                value => '600000',
                file  => 'powermanagementprofilesrc',
                key   => 'idleTime'
            },
        ],
        kde => {
            version    => '4',
            patch      => '2',
            configpath => '~/.kde',
            subversion => '14'
        }
    };

    $rw->metadata( $data->{kde} );
    $rw->contents( $data->{settings} );
    $rw->create_yaml;

    say "Write reset file: $reset...done";
    return;
}

__PACKAGE__->meta->make_immutable;

1;
