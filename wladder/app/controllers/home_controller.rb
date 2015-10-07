class HomeController < ApplicationController
  def index
  end

  def words
    puts "ENTERING WORDS METHOD"
    words = []
    File.open("#{Rails.root}/assets/data/words5.txt", "r") do |l|
	words.push l.downcase
    end
    puts "AFTER WORDS POP"
    @words = {"start_word" => words.sample, "end_word" => words.sample }
    while @words['end_word'] == @words['start_word'] do
    	@words['end_word'] = words.sample
    end
    puts "responding to client with #{@words}"
    respond_to do |format|
      format.html
      format.json { render :json => @words.to_json }
    end
  end
end
