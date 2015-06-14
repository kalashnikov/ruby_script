#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'mongo'
include Mongo

# Setting for MongoDB
db = MongoClient.new("localhost", 27017).db("obmWeb")
auth = db.authenticate('obm', 'back54321')
coll = db["stickers"]

p coll.find("id" => 1976).to_a

tmp = []
coll.find.each do |r|
    #next if type==0 and r["id"]-1000000>0
    #next if type==1 and r["id"]-1000000<0
    #next if filter!="" and !r["name"].downcase.include?(filter) and !r["description"].downcase.include?(filter)
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
# Get data from CouchDB
def getContents(type, filter="", limit=50)
    
    tmp = []
    counter = 0
    filterd = filter.downcase

    coll.find("id" => 1976).to_a
    coll.find.each do |r|
        next if type==0 and r.id.to_f-1000000>0
        next if type==1 and r.id.to_f-1000000<0
        next if filter!="" and !r.name.downcase.include?(filter) and !r.description.downcase.include?(filter)
        
    name        = r["name"]
    detail      = r["detail"]
    thumbnail   = r["thumbnail"]
    description = r["description"]
    description= r["description"]
    tmp.push( '<div class="pin">' )
    tmp.push( "\t<a href=\"#{detail]}\">" )
    tmp.push( "\t\t<img src=\"#{thumbnail]}\" />" )
    tmp.push( "\t</a>" )
    tmp.push( "\t<p> <h3>#{name]}</h3><br> #{description]} </p>" )
    tmp.push( "</div>\n" )

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
=end
