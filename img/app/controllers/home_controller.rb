class HomeController < ApplicationController

  def index
    @new_image = Image.new
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM http://baldwin.codes"
    respond_to do |format|
      format.html
      format.json {
        response = {
          'logged_in' => 'false',
          'user_owned' => '',
          'shared' => '',
          'public' => ''
        }
        puts 'is the user signed in?', user_signed_in?
        if !user_signed_in?
          # user is not signed in
          puts 'not logged in'
          response['public'] = Image.all.map { |image|
            if !image[:private]
              # the image is public
              {
                "filename" => image.filename,
                "id" => image.id,
                "user" => User.find(image.user_id).name
              }
            end
          }.compact!
        else
          # the user is signed in
          response['logged_in'] = 'true'
          response['user_public'] = Image.where(:private => false, :user_id => current_user[:id]).map { |e|
            {
              "filename" => e.filename,
              "id" => e.id,
              "user" => User.find(e.user_id).name
            }
          }
          response['public'] = Image.all.map { |image|
            if !image[:private] && image[:user_id] != current_user[:id]
              # the image is public and owned by someone else
              {
                "filename" => image.filename,
                "id" => image.id,
                "user" => User.find(image.user_id).name
              }
            end
          }.compact!
          response['user_owned'] = Image.all.map { |image|
            # the image belongs to the current user
            if image.user_id == current_user.id && image.private
              {
                "filename" => image.filename,
                "id" => image.id,
                "user" => User.find(image.user_id).name
              }
            end
          }.compact!

          response['shared'] = current_user.image_users.map { |image|
             {
               "filename" => image.image.filename,
               "id" => image.id,
               "user" => User.find(Image.find(image.image_id).user_id).name
             }
          }
        end
        #puts 'sending response', response.to_json
        render :json => response.to_json
      }
    end
  end


end
