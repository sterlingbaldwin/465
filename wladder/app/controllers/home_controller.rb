class HomeController < ApplicationController
  def index
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM http://baldwin.codes"
    respond_to do |format|
      format.html 
      format.json {
        words = []
        File.open("#{Rails.root}/app/assets/data/words5.txt", "r") do |f|
          f.each_line do |line|
            words.push line.chomp.downcase
          end
        end
        @words = {"start_word" => words.sample, "end_word" => words.sample }
        while @words['end_word'] == @words['start_word'] do
          @words['end_word'] = words.sample
        end
        render :json => @words.to_json 
	puts 'balls'
      }
    end
  end
end
