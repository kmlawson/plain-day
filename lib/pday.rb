#!/usr/bin/env ruby

require 'methadone'
require 'date'
require 'yaml'

include Methadone::Main

def isdate testdate
    begin 
        Date.parse(testdate)
        true
    rescue
        false
    end
end

# REVISIT THIS TO MAKE THE HEADER TEXT CUSTOMIZABLE
# Default to a Header 1 in Markdown:
def prepopulate headertext
    return "# "+headertext
end

def formatdate requesteddate, dateformat
    if requesteddate=='yesterday' || requesteddate=='y'
        formateddate=(Time.now-86400)
    elsif requesteddate=='yy' # Day before yesterday
        formateddate=(Time.now-172800)
    elsif requesteddate=='tomorrow' || requesteddate=='t'
        formateddate=(Time.now+86400)
    elsif requesteddate=='yyy' # Three days ago
        formateddate=(Time.now-259200)
    else
        if isdate(requesteddate)
            formateddate=Date.parse(requesteddate)
        else
            return nil
        end
    end
    return formateddate.strftime(dateformat)
end

main do

    #Set up default options
    default_options=Hash.new
    default_options['suffix-delimit'] = '-'
    default_options['format'] = 'md'
    default_options['editor'] = 'vim'
    default_options['date-format'] = "%Y.%m.%d"
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
        entrydate=Time.now.strftime(options['date-format'])
    else
        # Check date
        finaldate=formatdate(options['date'],options['date-format'])
        unless finaldate!=nil
            puts "DATE must be a valid date. For example '2013.1.15' or '01/15/2013' or 'Jan 1, 2013' or 'yesterday'"
            exit
        else
            entrydate=finaldate
        end
    end

    # Check to see if there is a suffix, and if so, add the suffix delimiter:
    if options[:suffix]
        suffix=options['suffix-delimit']+options['suffix']
    else
        suffix=''
    end


    # Build the command to create the file with the header and edit it:
    filepath=options['path']+entrydate+suffix+'.'+options['format']
    if File.file?(filepath)
        unless options[:force]
            puts "File already exists. Will open existing file."
        else
            puts "File already exists, replacing it."
            `echo '#{prepopulate(entrydate)}' > "#{filepath}"`
        end
    else
        puts "Creating new entry for: "+entrydate
        `echo '#{prepopulate(entrydate)}' > "#{filepath}"` # NEED TO ESCAPE FILEPATH FOR SPACES
    end
    puts "Editing entry: #{filepath}"
    exec("#{options['editor']} '#{filepath}'")
end

version     '0.3'
description 'Simple plain text diary management script.'

on("-t FORMAT","--format","Set format suffix")
on("-f","--force","If a file already exists with that name, replace it instead of editing existing")
on("-s SUFFIX","--suffix","Add suffix to file name (before format suffix)")
on("-e EDITOR","--editor","Set the editor, vim, emacs, nano, etc.")
on("-d DATE","--date","Supply an explicit date. Also accepts 'yesterday' or 'y'") 


go!
