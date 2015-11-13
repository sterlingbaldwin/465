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
              image.filename
            end
          }.compact!

        else
          # the user is signed in
          response = Array.new
          response.push Image.all.map { |image|
            if !image[:private]
              # the image is public
              { "filename" => image.filename, "id" => image.id }
            end
          }.compact!

          response.push Image.all.map { |image|
            if image.user == current_user
              { "filename" => image.filename, "id" => image.id }
            end
          }.compact!

          response.push current_user.image_users.map { |user|
            user.image
            { "filename" => user.image.filename, "id" => user.id}
          }

        end

        render :json => response.to_json
      }
    end
  end


end
