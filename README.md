# Plain-Day

This simple script is, in this first version, just a short cut for creating plain text diary entries in a designated folder. 

## Installation

From the command line:

```
gem install pday
```
## Configuration

Create a yaml file in your home folder called `.dayconfig`

It must contain at least one configuration variable:

```
---
path: '[PATH TO YOUR DIARY DIRECTORY]'
```

This path will determine where new diary entries are created.

Other options are available if you show the help: `pday --help`

## Usage

The way I use this is just a simple short cut command:

```
pday
```

This creates a new markdown (by default) plain text file in my diary directory and gives it a basic header to get started, with today's date as the name of the file. I can use the `-d` option to create a diary entry for an earlier day. It understands a few contextual date options like `-d y` for yesterday, `-d t` for tomorrow, and `-d yy` for the day before yesterday. I can optionally add a suffix to distinguish between my work log and my daily personal log. I can also change the format from the default markdown to say text, with `-t txt`

Combining these, consider the following command:

`pday -d y -t txt -s work `

This will open a blank diary entry for yesterday's date, with `-work.txt` as its suffix and format.
