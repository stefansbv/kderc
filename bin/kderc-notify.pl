#!/usr/bin/env perl
# PODNAME: kderc-notify.pl
# ABSTRACT: KDE directory/file change notifications

use strict;
use warnings;

use Linux::Inotify2;
use File::HomeDir;

my $home = File::HomeDir->my_home;
my $watch_dir1 = "$home/.kde/share/config";
my $watch_dir2 = "$home/.config";

$|++;

my $inotify = Linux::Inotify2->new
    or die "Unable to create new inotify object: $!";

$inotify->watch(
    $watch_dir1,
    IN_CLOSE_WRITE,
    sub {
        my $event = shift;
        my $name = $event->fullname;
        # print "$name was accessed\n" if $event->IN_ACCESS;
        print "$name was modified\n" if $event->IN_MODIFY;
        print "$name is new\n"       if $event->IN_CLOSE_WRITE;
        print "...\n";
        #$event->w->cancel;
    }
) or die "watch creation failed: $!";

$inotify->watch(
    $watch_dir2,
    IN_CLOSE_WRITE,
    sub {
        my $event = shift;
        my $name = $event->fullname;
        # print "$name was accessed\n" if $event->IN_ACCESS;
        print "$name was modified\n" if $event->IN_MODIFY;
        print "$name is new\n"       if $event->IN_CLOSE_WRITE;
        print "...\n";
        #$event->w->cancel;
    }
) or die "watch creation failed: $!";

1 while $inotify->poll;
