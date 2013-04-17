# Plain-Day

This simple script is, in this first version, just a short cut for creating plain text diary entries in a designated folder. 

## Installation

From the command line:

```
gem install pday
```

I am not sure why but I think this script requires you have Ruby 1.9.3 or later.

## Configuration

Create a yaml file in your home folder called `.dayconfig`

It must contain at least one configuration variable:

```
---
path: '[/FULL/PATH/TO/YOUR/DIARY/DIRECTORY/]'
```

This path will determine where new diary entries are created. You can also set the defaul `format`, `suffix`, and `editor` in this configuration file.

Other options are available if you show the help: `pday --help`

## Usage

The way I use this is just a simple short cut command:

```
pday
```

*What does this do?* This is not a complicated script but just a simple short cut that I use because I like to compose my log in markdown plain text with Vim. When I issue the command, it creates a new markdown (by default) plain text file in my diary directory and gives it a basic header to get started, with today's date as the name of the file. 

For example, if today is April 10, 2013, then the file created by pday by default would be:

`2013.04.10.md` 

In the directory you designate in `.dayconfig` and the the first line of this diary entry will be initialized to `# 2013.04.10` to get you started.

I can use the `-d` option to create a diary entry for an earlier day. It understands a few contextual date options like `-d y` for yesterday, `-d t` for tomorrow, and `-d yy` for the day before yesterday. I can optionally add a suffix to distinguish between my work log and my daily personal log. I can also change the format from the default markdown to say text, with `-t txt`

Combining these, consider the following command:

`pday -d y -t txt -s work `

This will open a blank diary entry for yesterday's date, with `-work.txt` as its suffix and format.

### Simple Log Feature

By default pday will create a log file for today or the date supplied, including a simple header in that file, and will open the file in the editor (either vim, the default or, whatever `-e/--editor` supplied).

If, instead, you simply wish to add a single line to your log, add the `-l/--log` option followed by the text you wish to append to your log. If the log file does not already exist it will be added. For example:  

`pday -l 'This is my log update'`

If you add the `-p/--timestamp` option to this, the log line will have a timestamp prefix.
