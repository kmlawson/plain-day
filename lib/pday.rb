#!/usr/bin/env ruby

require 'methadone'
require 'date'
require 'yaml'

include Methadone::Main
include Methadone::CLILogging

def isdate testdate
    begin 
        Date.parse(testdate)
        true
    rescue
        false
    end
end

# Default to a Header 1 in Markdown:
def prepopulate headertext
    return "# "+headertext
end


main do
    default_options=Hash.new
    default_options['suffix-delimit'] = ' - '
    default_options['format'] = 'md'
    default_options['editor'] = 'vim'
    # Load the .dayconfig file and merge in options there:
    CONFIG_FILE = File.join(ENV['HOME'],'.dayconfig') 
    if File.exists? CONFIG_FILE
      config_options = YAML.load_file(CONFIG_FILE)
      default_options.merge!(config_options)
    else
      # No config file found, prompt user to create one
      puts "Could not find your .dayconfig file. You need one that at least contains your default path to the diary."
    end
    default_options.merge!(options)
    options.merge!(default_options)
    # Check if the diary directory is found:
    unless options['path']
        puts "Could not find path to your diary. Did you configure the .dayconfig file?"
        exit
    end
    # Use today's date unless there is one supplied
    unless options[:date]
        entrydate=Time.now.strftime("%Y.%m.%d")
    else
        entrydate=options['date']
    end
    # Check to see if there is a suffix, and if so, add the suffix delimiter:
    if options[:suffix]
        suffix=options['suffix-delimit']+options['suffix']
    else
        suffix=''
    end
    # Build the command:
    filepath=options['path']+entrydate+suffix+'.'+options['format']
    puts "Creating new entry for: "+entrydate
    `echo '#{prepopulate(entrydate)}' > #{filepath}`
    puts "Editing entry..."
    `#{options['editor']} #{filepath}`
end

version     '0.1'
description 'Simple plain text diary management script.'

opts.on("-d DATE","--date","Supply an explicit date. Also accepts 'yesterday' or 'y'") do |date|
    if date=='yesterday' || date=='y'
        date=(Time.now-86400).strftime("%Y.%m.%d")
    end

    unless isdate(date)
        puts "DATE must be a valid date. For example \
        '2013.1.15' or '01/15/2013' or 'Jan 1, 2013' or \
        'yesterday'"
    end
    options[:date]=true
    options['date']=Date.parse(date).strftime("%Y.%m.%d")
end

on("-f FORMAT","--format","Set format suffix")
on("-s SUFFIX","--suffix","Add suffix")
on("-e EDITOR","--editor","Set the editor, vim, emacs, nano, etc.")

go!
