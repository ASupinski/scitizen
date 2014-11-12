class ImageAnnotationsController < ApplicationController
  before_action :set_image_annotation, only: [:show, :edit, :update, :destroy]

  # GET /image_annotations
  # GET /image_annotations.json
  def index
    @image_annotations = ImageAnnotation.all
  end

  # GET /image_annotations/1
  # GET /image_annotations/1.json
  def show
  end

  # GET /image_annotations/new
  def new
    @image_annotation = ImageAnnotation.new
  end

  # GET /image_annotations/1/edit
  def edit
  end

  # POST /image_annotations
  # POST /image_annotations.json
  def create
    params = process_params
    @image_annotation = ImageAnnotation.new(params)

    respond_to do |format|
      if @image_annotation.save
        itparams = {}
        itparams['image_id'] = params[:image_id]
        itparams['user_id'] = @image_annotation['user_id']
        itparams['tag'] = @image_annotation['text']
        itparams['id'] = nil
        @image_tag = ImageTag.new(itparams)
        @image_tag.save
        format.html { redirect_to @image_annotation, notice: 'Image annotation was successfully created.' }
        format.json { render :show, status: :created, location: @image_annotation }
      else
        format.html { render :new }
        format.json { render json: @image_annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /image_annotations/1
  # PATCH/PUT /image_annotations/1.json
  def update
    respond_to do |format|
      if @image_annotation.update(image_annotation_params)
        format.html { redirect_to @image_annotation, notice: 'Image annotation was successfully updated.' }
        format.json { render :show, status: :ok, location: @image_annotation }
      else
        format.html { render :edit }
        format.json { render json: @image_annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /image_annotations/1
  # DELETE /image_annotations/1.json
  def destroy
    @image_annotation.destroy
    respond_to do |format|
      format.html { redirect_to image_annotations_url, notice: 'Image annotation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def testit
    images = []
    annotations = Image.find(params['image_id']).image_annotations
    annotations.each do |anno|
      images << {src: anno.src,
                 text: anno.text,
                 shapes: JSON.parse(anno.shapes)}
    end
    puts annotations.to_json
    puts images.to_json
    render json: images
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image_annotation
      @image_annotation = ImageAnnotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_annotation_params
      params.require(:image_annotation).permit(:src, :shapes, :user_id)
    end

    def process_params
      shapes = params[:shapes].to_json

      annotation = {:src => params[:src],
                    :shapes => shapes,
                    :text => params[:text]}

      annotation[:image_id] = Image.where(:url => params[:src]).first.id

      if current_user
        annotation[:user_id] = current_user.id
      end      
      return annotation
    end
end
