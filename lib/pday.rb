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

# REVISIT THIS TO MAKE THE HEADER TEXT CUSTOMIZABLE
# Default to a Header 1 in Markdown:
def prepopulate headertext
    return "# "+headertext+"\n\n"
end

def formatlog logtext
    return "* "+logtext
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

    # DEFAULT OPTIONS HANDLING
    default_options=Hash.new
    default_options['suffix-delimit'] = '-'
    default_options['format'] = 'md'
    default_options['editor'] = 'vim'
    default_options['date-format'] = "%Y.%m.%d"
    default_options['timestamp'] = true
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
    # END DEFAULT OPTIONS HANDLING

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

    # CHECK TO SEE IF THERE IS A SUFFIX, AND IF SO, ADD THE SUFFIX DELIMITER:
    if options[:suffix]
        suffix=options['suffix-delimit']+options['suffix']
    else
        suffix=''
    end


    # BUILD THE COMMAND TO CREATE THE FILE WITH THE HEADER AND EDIT IT:
    filepath=options['path']+entrydate+suffix+'.'+options['format']
    if File.file?(filepath)
        unless options[:force]
            if options[:verbose]
                puts "File already exists. Will use existing file."
            end
        else
            if options[:verbose]
                puts "File already exists, replacing it."
            end
            `echo '#{prepopulate(entrydate)}' > "#{filepath}"`
        end
    else
        if options[:verbose]
            puts "Creating new entry for: "+entrydate
        end
        `echo '#{prepopulate(entrydate)}' > "#{filepath}"` 
    end
    if !options[:log]
        if !options[:output]
            if options[:verbose]
                puts "Editing entry: #{filepath}"
            end
            exec("#{options['editor']} '#{filepath}'")
        else
            exec("cat #{filepath}")
        end
    else
        # THE LOG OPTION IS ON SO JUST APPEND A LINE
        if options['log']!=''
            if options[:verbose]
                puts "Adding log entry to: #{filepath}"
            end
            if options[:timestamp]
                options['log']=Time.new.strftime("%H:%M")+" "+options['log']
            end
            if options[:output]
                addoutput="; cat #{filepath}"
            else
                addoutput=""
            end
            exec("echo '#{formatlog(options['log'])}' >> #{filepath}#{addoutput}")
        end
    end
end

version     '0.5'
description 'Simple plain text diary management script.'

on("-t FORMAT","--format","Set format suffix")
on("-o","--output","Output the log file instead of opening it")
on("-f","--force","Replace any existing file instead of editing it")
on("-s SUFFIX","--suffix","Add suffix to file name (before format suffix)")
on("-e EDITOR","--editor","Set the editor, vim, emacs, nano, etc.")
on("-d DATE","--date","Supply an explicit date (also y, yy, yyy, t) ") 
on("-l LOG","--log","Instead of opening file, add a single log line")
on("-p","--timestamp","Add timestamp to single line log")
on("-v","--verbose","Show more information when executing")


go!
