# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
require 'rest_client'
require 'json'

main_url = 'http://json.jpl.nasa.gov/data.json'
$image_types = ['ccam_images', 'fcam_images', 'rcam_images', 'ncam_images', 'mastcam_left_images', 'mastcam_right_images', 'mahli_images', 'mardi_images']

def get_images_for_sol(sol_url)
  image_urls = []
  ret = RestClient.get sol_url
  json_data = JSON.parse(ret)
  $image_types.each do |type|
    next unless json_data[type]

    image_groups = json_data[type]
    image_groups.each do |group|
      group['images'].each do |image|
        image_urls << image['url']
        next if Image.where(url: image['url']).exists?

        # skip images that are smaller than desired
        next if image['dimensions'].nil? or image['dimensions']['area'].nil?
        next if image['dimensions']['area'].any?{|dim| dim < 1000}

        begin
          Image.create(url: image['url'], sol: json_data['sol'].to_i, camera_type: image['instrument'], image_time: DateTime.strptime(image['time']['creation_timestamp_utc'], '%Y-%m-%dT%H:%M:%S')) 
        rescue => e
          puts "Failed to populate data for #{image['url']} because #{e.inspect} #{image['time']['creation_timestamp_utc']}"
        end
      end
    end
  end
  return image_urls
end

ret = RestClient.get main_url
json_data = JSON.parse(ret)
json_data.each do |_,data|
  mission_ret = RestClient.get data['image_manifest']
  mission_data = JSON.parse(mission_ret)
  sols_data = mission_data['sols']

  images = []
  sols_data.each do |sol_data|
    sol_image_urls = get_images_for_sol sol_data['url']
    images.concat(sol_image_urls)
  end
end
