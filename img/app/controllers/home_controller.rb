class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html {

      }
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
        puts 'sending response', response.to_json
        render :json => response.to_json
      }
    end
  end


end
