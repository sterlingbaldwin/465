class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
    respond_to do |format|
      format.html
      format.json {
        puts params
        puts 'starting json response for image'
        puts @image.inspect
        # return all users allowed access
        allowed_users = @image.image_users.map { |e|
          e.user
        }
        if !allowed_users
          allowed_users = Array.new
        end
        # allowed_users = ImageUser.where(:image_id => @image.id).map { |e|
        #   puts 'adding user to shared list', e.inspect, current_user.inspect
        #   user = User.find e.user_id
        #   {
        #      'name' => user.name,
        #      'email' => user.email
        #   }
        # }.compact!
        unallowed_users = User.all - allowed_users
        if user_signed_in?
          unallowed_users.delete_if do |x|
            x[:id] == current_user[:id]
          end
        end

        puts 'image', @image.inspect
        # return all tags on the image
        tags = Tag.where(:image_id => @image.id).map { |e|
          {
            'str' => e.str,
            'tag_id' => e.id
          }
        }

        owner = 'false'
        puts current_user.inspect

        # return if the user owns the image
        if user_signed_in? && @image.user_id == current_user.id
          owner = 'true'
        end
        puts 'Allowed users', allowed_users.inspect
        response = {
          'shared_users' => allowed_users,
          'tags' => tags,
          'owner' => owner,
          'unallowed_users' => unallowed_users
        }

        puts response
        render :json => response.to_json
      }
    end
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  def create
    @image = Image.new(image_params)
    @image.filename = ""; 8.times{@image.filename  << (65 + rand(25)).chr}
    @image.user = current_user
    puts 'User is uploading an Image'
    uploaded_io = params[:image][:uploaded_file]
    puts uploaded_io.inspect
    File.open(Rails.root.join('public', 'images', @image.filename), 'wb') do |file|
        file.write(uploaded_io.read)
    end

    if @image.save
      redirect_to @image, notice: 'Image was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      #params.require(:image).permit(:filename, :private, :user_id)
    end
end
