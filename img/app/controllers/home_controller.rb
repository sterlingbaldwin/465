class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json {
        puts "&&&&&&&&&&&&&&&&&&&&&&&&"
        response = "THIS IS TOTALLY A RESPONSE"
        render :json => response.to_json
      }
    end
  end


end
