class ImageTagsController < ApplicationController
  before_action :set_image_tag, only: [:show, :edit, :update, :destroy]

  # GET /image_tags
  # GET /image_tags.json
  def index
    @image_tags = ImageTag.all
  end

  # GET /image_tags/1
  # GET /image_tags/1.json
  def show
  end

  # GET /image_tags/new
  def new
    @image_tag = ImageTag.new
  end

  # GET /image_tags/1/edit
  def edit
  end

  # POST /image_tags
  # POST /image_tags.json
  def create
    @image_tag = ImageTag.new(process_params)

    respond_to do |format|
      if @image_tag.save
        format.html { redirect_to @image_tag, notice: 'Image tag was successfully created.' }
        format.json { render :show, status: :created, location: @image_tag }
      else
        format.html { render :new }
        format.json { render json: @image_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /image_tags/1
  # PATCH/PUT /image_tags/1.json
  def update
    respond_to do |format|
      if @image_tag.update(image_tag_params)
        format.html { redirect_to @image_tag, notice: 'Image tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @image_tag }
      else
        format.html { render :edit }
        format.json { render json: @image_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_tags/1
  # DELETE /image_tags/1.json
  def destroy
    @image_tag.destroy
    respond_to do |format|
      format.html { redirect_to image_tags_url, notice: 'Image tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_tag
      @image_tag = ImageTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_tag_params
      params.require(:image_tag).permit(:image_id, :tag)
    end

    def process_params
      tag = {:image_id => params[:image_id],
                    :tag => params[:tag]}

      if current_user
        tag[:user_id] = current_user.id
      end      
      return tag
    end
end
