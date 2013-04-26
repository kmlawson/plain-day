(*

This script is an example of how you can use apple script to run pday
I wasn't able to figure out how to make sure that the correct ruby version
was run without sourcing my bash profile, and calling the actual rvm ruby
installation directly, as well as calling pday from the original script
rather than from the command line. Would be grateful for tips on working
around this. To get this to work you will have to change the directory below
to point to the locations for each on your own machine. Notice this version
of the script is set up to work with my Pomodoro app.

*)


set mylog to "$pomodoroName"
do shell script "source ~/.bash_profile; /Users/fool/.rvm/rubies/ruby-1.9.3-p385/bin/ruby ~/shell/scripts/plain-day/lib/pday.rb -p -o -l '" & mylog & "'"