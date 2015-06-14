#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'mongoid'

Mongoid.load!("config/mongoid.yml", :production)

# Model for OBM Web
class Sticker
  include Mongoid::Document
  store_in collection: "stickers", database: "obmWeb"

  field :id,              type: Integer
  field :name,            type: String
  field :tag,             type: String, default: []
  
  field :detail,          type: String, default: "" 
  field :description,     type: String, default: "" 
  field :thumbnail,       type: String, default: "" 
  field :detailImg,       type: String, default: "" 

  field :reserv1,         type: String, default: "" 
  field :reserv2,         type: String, default: "" 
  field :reserv3,         type: String, default: "" 

end

#Sticker.each do |r|
#Sticker.where(id: "Photek").exists?
Sticker.find_by({:id=> 1976}).each do |r|
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
