# Watch Tower [![Build Status](http://travis-ci.org/TechnoGate/watch_tower.png)](http://travis-ci.org/TechnoGate/watch_tower) [![Still Maintained](http://stillmaintained.com/TechnoGate/watch_tower.png)](http://stillmaintained.com/TechnoGate/watch_tower)

[![Click here to lend your support to: Open Source Projects and make a donation at www.pledgie.com!](http://pledgie.com/campaigns/16123.png?skin_name=chrome)](http://www.pledgie.com/campaigns/16123)

WatchTower helps you track how much time you spend on all of your projects, at
the project, directory, and file level.

# Introduction

Did you ever want to keep track of how much time you _really_ spend on all of
your projects? Sure, you can try to remember to keep running estimates of your
time in the hope that you can aggregate those estimates later into some
meaningful data. But sometimes you forget, or an error creeps into your
estimate. And those errors add up. Quickly.

You can try some tracking software that depends on you to start and stop
timers. But what happens if you forget to start or stop one of those timers?

What you need is a passive system that will take care of all of this for you,
so you can focus on the actual work, which is where WatchTower comes into
play.

WatchTower runs in the background and keeps track of the time spent editing
each file with one of the supported editors (listed below). Since WatchTower
keeps track of the time spent on each file, and it knows which project each
file belongs to, you can view details and statistics on each project, right
down to the file level.

# Features

- Tracks the supported editors (listed below) and records the time spent on
  all files as specified via the customized configuration file (Git and
  __code_path__ are supported).

- A WatchTower Home Page where you can see how much time you've spent on all
  watched projects, as well as a total summary. The default display includes
  all projects worked on during the current month, but the page includes a
  date picker for easy selection. You can select a project to view the
  project's Detail Page.

  ![Example: WatchTower Home Page](http://f.cl.ly/items/1C0W1W0V2L3s3k2o313f/home_page.png)

- A Project Detail Page that displays a detailed report of the time spent on
  the project, each directory within the project, and each file. The default
  display includes all files worked on during the current month, but the page
  includes a date picker for easy selection.

  ![Example: Project Detail Page](http://f.cl.ly/items/3T263A350w261b0b2U1x/project_page.png)

# Supported Editors

- TextMate
- Xcode
- ViM (gVim and MacVim are also supported)

# Supported Operating Systems

- Mac OS X

# Getting Started

1. Install the WatchTower gem:

    ```bash
    $ gem install watch_tower --pre
    ```
2. Followed by:

    ```bash
    $ watchtower install
    $ watchtower load_bootloader
    ```

3. __Review the self-explanatory configuration file__ located at
__~/.watch_tower/config.yml__ and make any changes necessary.

# Update

Run 

```bash
$ watchtower install_bootloader
$ watchtower reload_bootloader
```

to update the path to the WatchTower binary in the boot loader.

# Usage

The installation process creates a launcher on login that starts
__WatchTower__. You can view your WatchTower Home Page via the web interface
by going to http://localhost:9282, or from the command line:

```bash
$ watchtower open
```

# Commands

For more information on available commands, you can take a look at the
[WatchTower Command Line wiki
page](https://github.com/TechnoGate/watch_tower/wiki/WatchTower-Command-Line).

# Contributing

Please feel free to fork and send pull requests, but please follow the
following guidelines:

- Prefix each commit message with the filename or the module followed by a
  colon and a space, for example 'README: fix a typo' or 'Server/Project: Fix
  a typo'.
- Include tests.
- Do not change the version, We will take care of that.

You can also take a look at the [TODO
list](https://github.com/TechnoGate/watch_tower/blob/master/TODO) for what's
in mind for the project

# Credits

This project is heavily inspired by
[timetap](https://github.com/elia/timetap) created by [Elia
Schito](https://github.com/elia).

It also uses a number of open source
projects including, but not limited to:

- [rb-appscript](http://appscript.sourceforge.net/)
- [activesupport](https://github.com/rails/rails)
- [activerecord](https://github.com/rails/rails)
- [sinatra](https://github.com/sinatra/sinatra)
- [sinatra-snap](http://github.com/bcarlso/snap)
- [haml](http://haml-lang.com)
- [grit](https://github.com/mojombo/grit)
- [coffee-script](http://github.com/josh/ruby-coffee-script)
- [uglifier](https://github.com/lautis/uglifier)
- [sass](http://sass-lang.com)
- [sprockets](http://getsprockets.org/)
- [guard](https://github.com/guard/guard)
- [guard-bundler](https://github.com/guard/guard-bundler)
- [guard-rspec](https://github.com/guard/guard-rspec)
- [guard-sprockets2](https://github.com/stevehodgkiss/guard-sprockets2)
- [yard](http://github.com/lsegal/yard)
- [rspec](http://github.com/rspec/rspec)
- [rspec-rails](http://github.com/rspec/rspec-rails)
- [capybara](https://github.com/jnicklas/capybara)
- [launchy](https://github.com/copiousfreetime/launchy)
- [mocha](https://github.com/floehopper/mocha)
- [factory_girl](https://github.com/thoughtbot/factory_girl)
- [timecop](https://github.com/jtrupiano/timecop)
- [pry](https://github.com/pry/pry)
- [systemu](https://github.com/ahoward/systemu)

# License

## This code is free to use under the terms of the MIT license.

Copyright (c) 2011 TechnoGate &lt;support@technogate.fr&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
