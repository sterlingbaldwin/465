class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.json {

        if !user_signed_in?
          # user is not signed in
          response = Image.all.map { |image|
            if !image[:private]
              # the image is public
              image[:filename]
            end
          }
        else
          # the user is signed in

        end

        render :json => response.to_json
      }
    end
  end


end
