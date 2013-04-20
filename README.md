# Overview

SIBA is a simple backup and restore utility. It implements daily backup rotation scheme. It is most suitable in sutuations when you need to have a history of backups. When run daily, SIBA retains full year history of backups by keeping 23 files in total: for the last 6 days, 5 weeks and 12 months.

## SIBA is

* **Easy to use:** configure, backup and restore with a single command.
* **Feature-rich:** backup and restore files, MySQL, MongoDB databases to local directory, FTP or Amazon S3.
* **Secure:** all backups are encrypted before moving to destination.
* **Cross platform:** runs on any computer with Ruby 1.9 or later.
* **Easy to extend:** developers can easily add new backup sources, archivers, encryptions and destinations.

## Installation

        $ gem install siba

## GnuPG

Siba uses [GnuPG](http://www.gnupg.org) for encryption.
It needs `gpg` command-line utility to be present on your system.

Install `gpg` on Mac OS X:

        $ brew install gnupg

## Usage

1. Create a configuration file:

        $ siba generate mybak

2. Backup:

        $ siba backup mybak

3. Restore:

        $ siba restore mybak

4. Show available plugins:

        $ siba list

5. Show other commands and options:

        $ siba

6. Create a gem skeleton for a new destination plugin:

        $ siba scaffold destination my-cloud

Tip: to create other plugin types, replace `destination` with `source`, `archive` or `encryption`.

[Read more about SIBA plugin development](https://github.com/evgenyneu/siba/blob/master/scaffolds/project/README.md)


## Scheduling backups

It is recommended to run `siba backup` command daily or hourly. Use your favourite scheduler to automate the process: Cron, Scheduled Tasks, iCal etc.

## Supported plugins

### Source

* **files:** backup  local files and directories.
* **mongo-db:** backup and restore MongoDB ([homepage](https://github.com/evgenyneu/siba-source-mongo-db)).
* **mysql**: backup and restore MySQL database ([homepage](https://github.com/evgenyneu/siba-source-mysql)).

### Archive

* **tar:** archive with optional gzip or bzip2 compression.

### Encryption

* **gpg:** encrypt with AES256, Blowfish, Twofish, 3DES and other ciphers.

### Destination

* **dir:** backup to local directory.
* **aws-s3:** upload backup to Amazon S3 storage ([homepage](https://github.com/evgenyneu/siba-destination-aws-s3)).
* **ftp:** store backups on FTP server ([homepage](https://github.com/evgenyneu/siba-destination-ftp)).


---
<img src="http://webdevelopercv.com/images/works/siba.png" width="326" height="326">
