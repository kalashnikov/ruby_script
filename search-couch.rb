#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'couchrest_model'

# Setting for CouchDB
$COUCH = CouchRest.new ENV["COUCHDB_URL"]
$COUCH.default_database = ENV["COUCHDB_DEFAULT_DB"]
$COUCHDB = $COUCH.default_database

# Model for OBM Web
class Sticker < CouchRest::Model::Base
  use_database $COUCHDB

  property :id,             Integer
  property :name,            String
  property :tag,           [String], :default => []
  
  property :detail,          String, :default => "" 
  property :description,     String, :default => "" 
  property :thumbnail,       String, :default => "" 
  property :detailImg,       String, :default => "" 

  property :reserv1,         String, :default => "" 
  property :reserv2,         String, :default => "" 
  property :reserv3,         String, :default => "" 

  timestamps!

  design do
    view :by_id
    view :by_name_and_description
  end
end

# Get data from CouchDB
def getContents(type, filter="", limit=50)
    
    tmp = []
    counter = 0
    filterd = filter.downcase

    view = Sticker.by_name_and_description
    view.each do |r|
        next if type==0 and r.id.to_f-1000000>0
        next if type==1 and r.id.to_f-1000000<0
        next if filter!="" and !r.name.downcase.include?(filter) and !r.description.downcase.include?(filter)
        tmp.push( '<div class="pin">' )
        tmp.push( "\t<a href=\"#{r.detail}\">" )
        tmp.push( "\t\t<img src=\"#{r.thumbnail}\" />" )
        tmp.push( "\t</a>" )
        tmp.push( "\t<p> <h3>#{r.name}</h3><br> #{r.description} </p>" )
        tmp.push( "</div>\n" )
        counter+=1
        break if counter==limit and filter==""
    end
    tmp.join(" ")
end
