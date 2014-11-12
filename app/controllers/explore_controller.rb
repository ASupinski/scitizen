class ExploreController < ApplicationController
  before_filter :notify_new_achievements
  def index
    # Get what's new
    @new_images = Image.limit(10).order('id desc')

    # Get random
    @random_images = []
    (1..10).each do |i|
      @random_images << Image.offset(rand(Image.count)).first
    end

    @hot_images = Image.top10;

    @new_annotated_images = ImageAnnotation.limit(10).order('created_at DESC').map{|a| a.image}.uniq

    render layout: 'exploreindex'
  end

  def show
    @image = Image.find(params[:id])
  end

  def random
    @random_image =  Image.offset(rand(Image.count)).first
  end

  def gallery
    @images = Image.paginate(page: params[:page], per_page: 15).order('created_at DESC')
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def gallery_by_tag
    @images = Image.joins(:image_tags).where({image_tags.tag => params['tag']}).paginate(page: params[:page], per_page: 15).order('created_at DESC')
    respond_to do |format|
      format.html
      format.js
    end
	render "gallery"
  end

  def list_anno
    annos = []
    image_annotations = ImageAnnotation.where(:image_id => params['image_id']).all 
    image_annotations.each do |anno|
      annos << {src: anno.src,
                editable: false,
                text: anno.text,
                shapes: JSON.parse(anno.shapes)}
    end
    render json: annos
  end
end
