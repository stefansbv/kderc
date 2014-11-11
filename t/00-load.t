#!/bin/env perl

use Test::More tests => 7;

use_ok( 'App::KdeRc' );
use_ok( 'App::KdeRc::Exceptions' );
use_ok( 'App::KdeRc::Role::Utils' );
use_ok( 'App::KdeRc::Resource' );
use_ok( 'App::KdeRc::Resource::Read' );
use_ok( 'App::KdeRc::Resource::Element' );
use_ok( 'App::KdeRc::Command::Run' );
