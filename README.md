# Watch Tower [![Build Status](http://travis-ci.org/TechnoGate/watch_tower.png)](http://travis-ci.org/TechnoGate/watch_tower) ![Still Maintained](http://stillmaintained.com/TechnoGate/watch_tower.png)

<a href='http://www.pledgie.com/campaigns/16123'><img alt='Click here to lend your support to: Open Source Projects and make a donation at www.pledgie.com !' src='http://www.pledgie.com/campaigns/16123.png?skin_name=chrome' border='0' /></a>

WatchTower helps you track the time you spend on each project.

# Introduction

Are you tired of not-knowing how much each of your projects really costs? Watch Tower
comes to the rescue.

WatchTower runs in the background and it monitors your editors (see Supported
Editors) and records the time you spend on each file and thus on the project
in total, and using a web interface, it presents you with statistics on each
project

# Installation

The installation has been made as simple as possible, here's the steps required:

```bash
$ gem install watch_tower
$ watchtower intall
```

This creates a configuration file which you __should__ review before invoking
__WatchTower__, located at __~/.watch_tower/config.yml__ the configuration file
is self explanatory.

# Usage

The installation process should create a launcher on login which starts
__WatchTower__ you can open the web interface by going to
http://localhost:9282 or using the command

```bash
$ watchtower open
```