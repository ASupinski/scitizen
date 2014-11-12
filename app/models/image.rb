class Image < ActiveRecord::Base
	has_many :image_annotations
	def thumbnail_url
		thumb = url.gsub(".jpg", "-thm.jpg")
	end
	def user_annotations(user_id)
		image_annotations.where(user_id: user_id)
	end
  def annotations_count
    image_annotations.count
  end

	scope :top10, -> {
    	select("images.id, images.url, images.sol, images.image_time, count(images.id) AS anno_count").
    	joins(:image_annotations).
    	group("images.id").
    	order("anno_count DESC").
    	limit(10)
    }
end
