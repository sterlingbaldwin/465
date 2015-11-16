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
          response = {
            'user_owned' => '',
            'shared' => '',
            'public' => ''
          }
          response['public'] = Image.all.map { |image|
            if !image[:private]
              # the image is public
              {
                "filename" => image.filename,
                "id" => image.id,
                'user' => User.find(image.user_id).name
              }
            end
          }.compact!

          response['user_owned'] = Image.all.map { |image|
            # the image belongs to the current user
            if image.user_id == current_user.id
              puts 'DEBUG 2:', image.inspect
              {
                "filename" => image.filename,
                "id" => image.id,
                'user' => User.find(image.user_id).name
              }
            end
          }.compact!

          response['shared'] = current_user.image_users.map { |user|
             {
               "filename" => user.image.filename,
               "id" => user.id,
               'user' => Image.find(user.user_id)['name']
             }
          }

        end

        render :json => response.to_json
      }
    end
  end


end
