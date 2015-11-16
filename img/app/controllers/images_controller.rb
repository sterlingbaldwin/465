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
        puts 'starting json response for image'
        puts ImageUser.inspect
        users = ImageUser.all.map { |e|
          if e.user_id == current_user.id || e.image_id == @image.id
            user = User.find e.user_id
            {
               'name' => user.name,
               'email' => user.email
            }
           end
        }.compact!.uniq
        puts 'users:',
        users.each { |e| puts e.inspect }

        puts 'image', @image.inspect

        tags = Tag.where(:image_id => @image.id).map { |e|
          {
            'str' => e.str,
            'tag_id' => e.id
          }
        }

        owner = 'false'
        puts @image.user_id, current_user.id
        puts @image.inspect, current_user.inspect
        if @image.user_id == current_user.id
          owner = 'true'
        end
        response = {
          'shared_users' => users,
          'tags' => tags,
          'owner' => owner
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
    @image.generate_filename  # a function you write to generate a random filename and put it in the images "filename" variable
    @image.user = current_user

    @uploaded_io = params[:image][:uploaded_file]

    File.open(Rails.root.join('public', 'images', @image.filename), 'wb') do |file|
        file.write(@uploaded_io.read)
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
      params.require(:image).permit(:filename, :private, :user_id)
    end
end
