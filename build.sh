#!/bin/bash

pp -I lib \
   --output=bin/kderc \
   --compress 6 \
   -M='MooseX::Clone::' \
   -M='MooseX::App::Plugin::**' \
   -M='MooseX::App::**' \
   -M='Pod::Elemental::' \
   -M='MooseX::Enumeration::' \
   -M='MooseX::Iterator::' \
   -M='App::KdeRc::' \
   --bundle bin/kderc.pl
