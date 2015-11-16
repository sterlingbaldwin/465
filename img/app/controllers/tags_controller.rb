class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :destroy]
  before_action :verify_request_type, only: [:update]

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    if request.method_symbol == :patch
      @tag = Tag.new
      @tag[:image_id] = params[:image_id]
      @tag[:str] = params[:str]
      @tag.save
      render json:{'tag_id' => @tag[:id]} 
    else
      respond_to do |format|
        @tag = Tag.find(params[:id])
        puts @tag.inspect
        puts Tag.find(@tag.id).inspect
        if Tag.update(@tag.id, 'str' => params[:text])
          format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
          format.json { render json: {'success' => 'true'} , status: :ok }
        else
          format.html { render :edit }
          format.json { render json: @tag.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:str, :image_id)
    end

    def verify_request_type
      unless allowed_methods.include?(request.method_symbol)
        head :method_not_allowed # 405
      end
    end

    def allowed_methods
      %i(get post patch options)
    end
end
