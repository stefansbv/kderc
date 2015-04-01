#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

use POE;
use Linux::Inotify2;
use File::HomeDir;

my $home = File::HomeDir->my_home;
my $watch_dir = "$home/.kde/share/config";
die "No such dir $watch_dir" unless -d $watch_dir;

say "watching $watch_dir...";

$|++;

POE::Session->create(
    inline_states => {
        _start => sub {
            $_[KERNEL]->alias_set('notify');
            $_[HEAP]{inotify} = new Linux::Inotify2
                or die "Unable to create new inotify object: $!";

            $_[HEAP]{inotify}->watch( $watch_dir, IN_CLOSE_WRITE,
                $_[SESSION]->postback("watch_hdlr") )
                or die "Unable to watch dir: $!";

            my $inotify_FH;
            open $inotify_FH, "<&=" . $_[HEAP]{inotify}->fileno
                or die "Can't fdopen: $!\n";
            $_[KERNEL]->select_read( $inotify_FH, "inotify_poll" );
        },
        inotify_poll => sub {
            $_[HEAP]{inotify}->poll;
        },
        watch_hdlr => \&watch_hdlr,
    },
);

sub watch_hdlr {
    my $event = $_[ARG1][0];

    my $name = $event->fullname;

    print "$name was accessed\n"              if $event->IN_ACCESS;
    print "$name is no longer mounted\n"      if $event->IN_UNMOUNT;
    print "$name is gone\n"                   if $event->IN_IGNORED;
    print "$name is new\n"                    if $event->IN_CLOSE_WRITE;
    print "events for $name have been lost\n" if $event->IN_Q_OVERFLOW;
}

POE::Kernel->run();

exit 0;
