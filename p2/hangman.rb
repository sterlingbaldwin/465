#!/usr/bin/env ruby

#I am going for the extra credit here


def debug_print(output, debug)
	if debug
		puts "[*]  #{output}".red
	end
end

if ARGV[0] == "-d"
	`gem install colorize`
	require 'colorize'
	debug = true
	debug_print "Running in debug mode", debug
	print "[*] Hey ".cyan, "t".red, "y".magenta, "s".yellow, "o".green, "n [*]\n".blue
end


def trim_words(word_list, letter, debug=false)
	debug_print "#start of trim, #{word_list.length} words left", debug
	new_list = word_list.map { |x|
		if x.include? letter
			next
		else
			x
		end
	}.compact!
	if new_list.length == 0
		#im putting this here as a flag to mark that it found the letter
		return word_list, "flag"
	else
		new_list
	end
end

def print_hangman_user(letters_guessed, letter_list, num_guesses)
	letters_guessed.each_with_index do |x, i| 
		if i == letters_guessed.length - 1
			puts "#{x} (#{9-num_guesses} chances left)\n"
		else
			print "#{x} "
		end
	end
	letter_list.each do |x| 
		if x
			print "#{x} "
		else
			print "_ "
		end
	end
	puts ""
end

def victory?(letter_list)
	victory = true
	letter_list.each do |x|
		victory = false if !x
	end
	victory
end

def find_first_word_set(word_list, letter, debug, length)
	#first get a frequency count of the target letter
	freq_list = Array.new(length, 0)
	word_list.each do |x|
		x.each do |y|
			(0..length - 1).each do |i|
				if y[i] == letter
					freq_list[i] += 1
				end
			end
		end
	end
	if debug
		puts "[*]  printing the freq list"
		puts freq_list
	end
	highest_freq = 0
	freq_list.each do |x|
		highest_freq = x if x > highest_freq
	end
	highest_freq = freq_list.rindex highest_freq
	debug_print "highest freq at #{highest_freq}", debug

	return_list = Array.new

	word_list.each do |x|
		x.each do |y|
			if y[highest_freq] == letter
				if x.length == 1
					return y
				end
				multi_letter_match = false
				(0..length).each do |i|
					if i != highest_freq and y[i] == letter
						multi_letter_match = true
					end
				end
				if !multi_letter_match
					return_list.push y
				end
			end
		end
	end

	debug_print "#{return_list}", debug
	if return_list.length > 0
		return_list
	else
		nil
	end
end

def find_word_set(word_list, letter, debug, length)
	#first get a frequency count of the target letter
	freq_list = Array.new(length, 0)
	word_list.each do |x|
		(0..length - 1).each do |i|
			if x[i] == letter
				freq_list[i] += 1
			end
		end	
	end
	highest_freq = 0
	good_freq = false
	freq_list.each do |x|
		if x > highest_freq
			highest_freq = x
			good_freq = true
		end
	end
	if good_freq == false
		debug_print "wrong letter guessed", debug
		return nil
	end
	highest_freq = freq_list.rindex highest_freq
	debug_print "highest freq at #{highest_freq}", debug

	return_list = Array.new

	word_list.each do |x|
		if x[highest_freq] == letter
			multi_letter_match = false
			(0..length).each do |i|
				if i != highest_freq and x[i] == letter
					multi_letter_match = true
				end
			end
			if !multi_letter_match
				return_list.push x
			end
		end
	end

	debug_print "#{return_list}", debug
	if return_list.length > 0
		return_list
	else
		nil
	end
end



words = Array.new
num_guesses = 0
letters_guessed = Array.new

File.open("./words.txt", "r") do |file|
	file.each_line do |line|
		words.push(line)
	end
end

puts "Enter word length between 5-20:"
word_length = 0
while word_length == 0
	word_length = STDIN.gets.chomp
	debug_print "word_length = #{word_length}", debug	
	if !word_length.match /^[[:digit:]]*$/
		debug_print "A non number was entered for the length", debug
		puts "Only use numbers for the word length"
		word_length = 0
		next
	end
	word_length = word_length.to_i
	if word_length < 5
		word_length = 5
	elsif word_length > 20
		word_length = 20
	end
end

debug_print "Choosing words with length #{word_length}", debug

letter_list = Array.new word_length
words.map! { |x| x if x.length-1 == word_length }.compact!

debug_print "Starting word count #{words.length}", debug

found_word = false
num_guesses = 0
while num_guesses < 10 

	while true
		print "Enter your guess: "
		input = STDIN.gets.chomp
		if letters_guessed.include? input
			puts "You already guessed #{input}"
			next
		elsif input == 'print'
			letters_guessed.each do |x|
				puts "#{x} "
			end
			next

		elsif input.length > 1 or !input.match /^[[:alpha:]]$/ 
			puts "Only letters a-z are allowed"
			next
		else 
			letters_guessed.push input.downcase
			break
		end
	end
	print "\n"
	found_position = false
	if found_word == false
		words = trim_words words, input, debug
=begin
		if words == words_new
			found_word = true
			num_guesses -= 1
			debug_print "found our word! #{words[0]}", debug
		else
			words = words_new
			found_word = false
		end
=end
		if words[words.length - 1] == "flag"
			num_guesses -= 1
			found_word = true
			#remove the flag
			words.delete_at words.length - 1
			#we found the first letter that must be in the word
			debug_print "[*]  Hit the flag", debug
			first_time = true
			new_words = find_first_word_set words, input, debug, word_length
			if new_words == nil
				found_word = false
			else
				words = new_words
			end
		end
	end

	if found_word == true
		if first_time
			first_time = false
		else
			if words.length != 1
				words = trim_words words, input, debug
				debug_print "flag = #{words[words.length - 1]}", debug
				debug_print "#{words}",debug
				if words[words.length - 1] == "flag"
					words.delete_at words.length - 1
					new_words = find_first_word_set words, input, debug, word_length
					if new_words == nil
						print_hangman_user letters_guessed, letter_list, num_guesses
						num_guesses += 1
						next
					else
						words = new_words
					end
				end
			end
		end
		#add the letter to the letter list
		correct_letter = false
		letter_list = (0..word_length - 1).map do |x|
			#if the letter x is equal to the last letter that was guessed
			if words[0][x] == letters_guessed[letters_guessed.length - 1]
				correct_letter = true
				words[0][x]
			#else whatever was there before
			elsif letter_list[x]
				letter_list[x]
			end
		end
		num_guesses -= 1 if correct_letter
	end
	print_hangman_user letters_guessed, letter_list, num_guesses
	num_guesses += 1
	break if victory? letter_list
end 


if not victory? letter_list
	puts "YOU LOSE! The words was #{words[0]}"
end


