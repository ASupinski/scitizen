class UniqueIndexImage < ActiveRecord::Migration
  def self.up
    add_index :images, [:url], :unique => true
  end

  def self.down
    remove_index :images, [:url]
  end
end
