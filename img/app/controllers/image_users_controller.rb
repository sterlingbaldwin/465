class ImageUsersController < ApplicationController
  before_action :set_image_user, only: [:show, :edit]

  # GET /image_users
  # GET /image_users.json
  def index
    @image_users = ImageUser.all
  end

  # GET /image_users/1
  # GET /image_users/1.json
  def show
  end

  # GET /image_users/new
  def new
    @image_user = ImageUser.new
  end

  # GET /image_users/1/edit
  def edit
  end

  # POST /image_users
  # POST /image_users.json
  def create
    @image_user = ImageUser.new(image_user_params)
    @image_user.user_id = params[:user_id]
    @image_user.image_id = params[:image_id]
    puts 'CREATING NEW IMAGEUSER', @image_user.inspect
    respond_to do |format|
      if @image_user.save
        format.json {
          puts @image_user.inspect
          head :no_content
        }
      else
        format.json { render json: @image_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /image_users/1
  # PATCH/PUT /image_users/1.json
  def update
    puts params
    @image_user = ImageUser.where(:user_id => params[:user_id], :image_id => params[:image_id]).map { |e|
      puts e.inspect
      e.destroy
    }
    respond_to do |format|
      format.json {
        puts params
        head :no_content }
    end
  end

  # DELETE /image_users/1
  # DELETE /image_users/1.json
  def destroy
    @image_user.destroy
    respond_to do |format|
      format.html { redirect_to image_users_url, notice: 'Image user was successfully destroyed.' }
      format.json {
        puts params
        head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_user
      @image_user = ImageUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_user_params
      params.require(:image_user).permit(:user_id, :image_id)
    end
end
