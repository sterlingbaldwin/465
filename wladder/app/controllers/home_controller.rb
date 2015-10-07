class HomeController < ApplicationController
  def index
  end

  def words
    require "#{Rails.root}/app/assets/data/words5.rb"
    @words = {"start_word" => words.sample, "end_word" => words.sample }
    puts @words
=begin
    respond_to do |format|
      format.html
      format.json { render :json => @words.to_json }
    end
=end
  end

end
