#!/usr/bin/env ruby
# This script launches new runs of the application in a segment you specify.
# You can also decide what to do when dataset you submit collide with existing
# datasets in the segment.
require 'config/boot'
require 'optparse'

# default options
OPTIONS = {
  :segment     => nil,
  :all         => false,
  :only        => nil,
  :except      => nil,
  :collision   => 'skip',
  :verb        => false
}

def main
  parse_args
  display_args if OPTIONS[:verb]
  
  segment = OPTIONS[:segment]
  rundir = RUNS_DIR + '/' + segment
  collision = OPTIONS[:collision]
  verb = OPTIONS[:verb]
  
  whitelist = OPTIONS[:only]
  blacklist = OPTIONS[:except]
  whitelist = nil if OPTIONS[:all]

  submission = build_provisions rundir, DATA_DIR, whitelist, blacklist
  
  submission.datasets.each do |d|
    dag = build_dag d
    dag.save("tmp/#{d.uniq}.dag")
    submission.provides :from => 'tmp', :to => d.sink do
      file "#{d.uniq}.dag"
    end
  end

  submission.fulfill

end




def parse_args
  ARGV.options do |o|
    script_name = File.basename($0)

    o.set_summary_indent('    ')
    o.banner =    "Usage: #{script_name} [OPTIONS]"
    o.define_head "Submits jobs to a segment for Condor processing"
    o.separator   ""

    o.on("-s","--segment=SEGMENT","Specify segment in which to run this data") { |OPTIONS[:segment]| }
    o.on('-a','--all','Include all datasets available') { |OPTIONS[:all]| }
    o.on('-o','--only=WHITELIST', Array, 'Include only the specified datasets') do |whitelist|
      OPTIONS[:only] = whitelist.map { |dataset| dataset.strip }
    end
    o.on('-b','--except=BLACKLIST', Array, 'Reject these datasets') do |blacklist|
      OPTIONS[:except] = blacklist.map { |dataset| dataset.strip }
    end
    o.on("-c", "--collision=[RESPONSE]", [:skip, :replace],
         "On dataset collision: skip, replace") { |OPTIONS[:collision]| }
    o.on('-v','--verbose','Be wordy') { |OPTIONS[:verb]| }

    o.separator ""
    o.on_tail("-h", "--help", "Show this help message.") { puts o; exit }
    o.parse!
    
    if OPTIONS[:segment].nil?
      puts "Missing argument: --segment=SEGMENT is required"
      puts o; exit
    end
  end
end
  
def display_args
  OPTIONS.each_pair do |k,v|
    puts "%15s:  %s" % [k,v.to_s]
  end
  puts "%15s:  %s" % ['arguments', ARGV]
end

if __FILE__ == $0
  main
end