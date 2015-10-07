#!/usr/bin/env ruby
file_matches = `find . -name "*\\.txt$" `.split("\n")
puts file_matches
if file_matches.length > 0
	puts "Files with names that matches <#{ARGV[0]}>\n"
end
=begin
file_matches.each{ |x| puts "  #{x}" }
.each{ |x| puts `cat #{x} | grep -n #{ARGV[0]}`} 
=end