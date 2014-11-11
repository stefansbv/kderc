kderc
=====
Ștefan Suciu
2014-11-11

Version: 0.005 alpha

`KDE` configuration helper tool.


Acknowledgements
----------------

Inspired from the `kdeSetup.sh` script of the
[linuxTweaks](https://github.com/ryanpcmcquen/linuxTweaks) project.
Thank you!


Description
-----------

The main difference between this application and `kdeSetup.sh` script
is that the `KDE` configuration options are stored separately in a `YAML`
file.

Another important difference is a feature to read and collect the
existing configuration before applying the new configuration and
create a so called reset `YAML` file.  This reset file can be used to
restore the old configurations.

The down side of this approach is a much heavier dependency chain, in
this particular case: Perl and a number of required modules (`Moose`,
`MooseX::App`, etc.).

Two items in the `kde-font.yml` example configuration file:

```YAML
---
settings:
  -
    file: kdeglobals
    group: General
    key: desktopFont
    value: 'Sans Serif,11,-1,5,50,0,0,0,0,0'
  -
    file: kdeglobals
    group: General
    key: fixed
    value: Monospace,11,-1,5,50,0,0,0,0,0
```


Requirements
------------

Requirements:

KDE4:
- kwriteconfig
- kreadconfig

Perl and the required modules:
- Moose
- MooseX::App
- (...)


Quick Usage
-----------

Run the KDE configure commands but use `--dryrun`, first, to see how
the commands will look like and how will be the values changed:

```
% kderc run --in kde-fonts.yml --dryrun
```

Change the KDE fonts configuration section:

```
% kderc run --in kde-fonts.yml
```

License And Copyright
---------------------

Copyright (C) 2014 Ștefan Suciu

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 2 dated June, 1991 or at your option
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

A copy of the GNU General Public License is available in the source tree;
if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
