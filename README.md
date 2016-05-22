# bdays
Birthday calendar

This is a command-line program that helps you keep track of
upcoming birthdays.

## Prerequisites
The program uses SQLite3 and its command-line shell `sqlite3`,
so these need to be installed.

## Installation
I have "installed" `bdays.bash` by putting the following file
in my `bin` (that is, somewhere on my `$PATH`):

~~~~
#! /usr/bin/env bash
(cd ~/code/bdays ; bash bdays.bash "$@")
~~~~

Where `~/code/bdays` is the directory where the program is
installed.

## Use
You should have a plain text, tab-separated file with all
birthday dates in the first column and names in the second.
The dates should be in the `YYYY-MM-DD` format. The names
don't have to follow any particular convention. The default
name of the file is `bdays.tsv`.

Then, the following command line can be used to add all
birthday dates to the database:

~~~~
$ bdays create
~~~~

From now on, as long as you don't change the `.tsv` file
containing all birthdays, all you need to do is:

~~~~
$ bdays
~~~~

... and you will see a list of all birthdays that will take place
within the next 23 days.
