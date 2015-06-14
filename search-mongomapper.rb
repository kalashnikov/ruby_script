#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
# http://mongomapper.com/documentation/plugins/querying.html
# https://github.com/mongomapper/mongomapper

require 'mongo_mapper'

MongoMapper.setup({'production' => {'uri' => ENV['MONGODB_URI']}}, 'production')

# Model for OBM Web
class Sticker
  include MongoMapper::Document
  set_collection_name "stickers"

  key :sticker_id,      Integer
  key :name,            String
  key :tag,             String
  
  key :detail,          String
  key :description,     String 
  key :thumbnail,       String
  key :detailImg,       String

  key :reserv1,         String
  key :reserv2,         String
  key :reserv3,         String

end

#Sticker.ensure_index [[:sticker_id, 1]], :unique => true

Sticker.find_each do |r|
    name        = r["name"]
    detail      = r["detail"]
    thumbnail   = r["thumbnail"]
    description = r["description"]
    puts '<div class="pin">' 
    puts "\t<a href=\"#{detail}\">" 
    puts "\t\t<img src=\"#{thumbnail}\" />" 
    puts "\t</a>" 
    puts "\t<p> <h3>#{name}</h3><br> #{description} </p>" 
    puts "</div>\n" 
end

=begin
r = Sticker.find_by_sticker_id(1976)
name        = r["name"]
detail      = r["detail"]
thumbnail   = r["thumbnail"]
description = r["description"]
puts '<div class="pin">' 
puts "\t<a href=\"#{detail}\">" 
puts "\t\t<img src=\"#{thumbnail}\" />" 
puts "\t</a>" 
puts "\t<p> <h3>#{name}</h3><br> #{description} </p>" 
puts "</div>\n"
=end
