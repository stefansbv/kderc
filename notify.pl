#!/usr/bin/perl

use strict;
use warnings;

use Linux::Inotify2;
use File::HomeDir;

my $home = File::HomeDir->my_home;
my $watch_dir = "$home/.kde/share/config";

$|++;

my $inotify = Linux::Inotify2->new
    or die "Unable to create new inotify object: $!";

$inotify->watch(
    $watch_dir,
    IN_CLOSE_WRITE,
    sub {
        my $event = shift;
        my $name = $event->fullname;
        # print "$name was accessed\n" if $event->IN_ACCESS;
        print "$name was modified\n" if $event->IN_MODIFY;
        print "$name is new\n"       if $event->IN_CLOSE_WRITE;
        print "...\n";
        # $event->w->cancel;
    }
) or die "watch creation failed: $!";

1 while $inotify->poll;
