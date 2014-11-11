class AddImageTags < ActiveRecord::Migration
  def self.up
    create_table :image_tags do |t|
      t.string   “tag”
      t.integer  "user_id"
      t.integer  "image_id"
    end
    add_index "image_tags", ["image_id"], name: "index_image_tags_on_image_id"
    add_index "image_tags", ["user_id"], name: "index_image_tags_on_user_id"
  end

  def self.down
    drop_table : image_tags
  end
end
