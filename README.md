# Overview

SIBA is a simple backup and restore utility. It implements daily backup rotation scheme. It is most suitable in sutuations when you need to have a history of backups and not just the last one. If run daily, SIBA retains full year history of backups by keeping only 23 files: 6 daily, 5 weekly and 12 monthly full backups.

## Main features

* **Ease of use.** Configure, backup and restore with a single command.
* **Secure.** All backups are encrypted on your computer before reaching backup destination.
* **Cross platform.** Utility can be run on any computer with Ruby 1.9 or later.
* **Easy to extend.** Developers can easily add new backup sources, archivers, encryptors and destinations.
* **Free and open source.** Use SIBA for any purpose without restrictions.

## Installation

        $ gem install siba

(assuming that Ruby 1.9 and RubyGems are installed)

## Usage

1. Create a configuration file

        $ siba generate mybak

2. Backup

        $ siba backup mybak

3. Restore

	$ siba restore mybak

4. Show available plugins

	$ siba list

5. Create a gem project for a new destination plugin (or for a source, archive, encryption plugin).

	$ siba scaffold destination my-cloud

6. Show other commands and options

        $ siba

## Scheduling backups

It is recommended to run `siba backup` command daily or hourly. Use your favourite scheduler to automate the process: Cron, Scheduled Tasks, iCal etc.
