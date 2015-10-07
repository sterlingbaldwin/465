#!/usr/bin/env ruby
require 'colorize'

def debug_print(output, debug)
	if debug
		puts "[*]  #{output}".red
	end
end

if ARGV[0] == "-d"
	debug = true
	debug_print "Running in debug mode", debug
	print "[*] Hey ".cyan
	print "t".red
	print "y".magenta
	print "s".yellow
	print "o".green
	print "n [*]\n".blue
end

def trim_words(word_list, letter, debug)
	debug_print "#start of trim, #{word_list.length} words left", debug
	new_list = word_list.map { |x|
		if x.include? letter
			next
		else
			x
		end
	}.compact!
	if new_list.length == 0
		#return a new one element array, with the content of wordlist at rand(word_list.length - 1)
		
		#find all 
		#
		Array.new 1, word_list[rand(word_list.length - 1)]
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
	if victory
		puts "YOU WIN!"
		victory
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
	if !found_word
		words = trim_words words, input, debug
		if words.length == 1
			found_word = true
			num_guesses -= 1
			debug_print "found our word! #{words[0]}", debug
		end
	end
	if found_word
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
		if debug
			letter_list.each do |x|
				print "#{x} "
			end
		end
		num_guesses -= 1 if correct_letter
	end

	if debug 
		words.each { |x| puts "#{x}" } 
	end
	print_hangman_user letters_guessed, letter_list, num_guesses
	num_guesses += 1
	break if victory? letter_list
end 



