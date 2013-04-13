# Plain-Day

This simple script is, in this first version, just a short cut for creating plain text diary entries in a designated folder. 

## Installation

From the command line:

```
gem install pday
```
## Configuration

Create a yaml file in your home folder called .dayconfig

It must contain at least one configuration variable:

```
---
path: '[PATH TO YOUR DIARY DIRECTORY]'
```

This path will determine where new diary entries are created.

Other options are available if you show the help: pday --help
