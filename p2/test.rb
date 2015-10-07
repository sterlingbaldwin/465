thing = [1,2,3,4,5]
thing.each_with_index do |x, i|
	puts "thing[#{i}] = #{x}"
end
puts "#{thing.length}"