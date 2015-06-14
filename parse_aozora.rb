
#
# Update date from Aozora website
# 2015.5.22 @ Kala Kuo
# 

require 'date'
require 'mongo'
include Mongo

# encoding: utf-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Setting for MongoDB
$db        = MongoClient.new("localhost",27017, :pool_size =>15).db("aozora")
#$db        = Mongo::Client.new([ '127.0.0.1:27017' ], :pool_size =>15, :database => "aozora")
$coll      = $db["books"]

# Update the file
# Ref: http://www.aozora.gr.jp/index_pages/person_all.html
%x[rm list_person_all_extended_utf8.*] if File.exist?("list_person_all_extended_utf8.zip") 
%x[wget http://www.aozora.gr.jp/index_pages/list_person_all_extended_utf8.zip]
%x[unzip list_person_all_extended_utf8.zip]

File.open("list_person_all_extended_utf8.csv").each do |l|

    ary = l.gsub("\"","").split(",")

    next if ary[0].include?("作品ID")

    inc       = 0

    did       = ary[0].to_i # Book ID
    title     = ary[1] # Book Title 
    title_    = ary[2] # Book Title(katagana)
    cata      = ary[8].gsub(/NDC /,"").split(' ') # Catagory array
    
    inc += 1  while !ary[11+inc].include?("-")
    #puts "#{ary[11+inc]}, #{ary[12+inc]}"

    open_at   = DateTime.strptime(ary[11+inc].chomp.to_s, '%Y-%m-%d').to_time   #=> #<Date: 2001-02-03 ...>
    update_at = DateTime.strptime(ary[12+inc].chomp.to_s, '%Y-%m-%d').to_time   #=> #<Date: 2001-02-03 ...>
    load_at   = Time.now.utc
    bookcard  = ary[13+inc]
    author_id = ary[14+inc].to_i 
    author    = "#{ary[15+inc]}#{ary[16+inc]}"
    author_en = "#{ary[21+inc]} #{ary[22+inc]}"
    booklink  = ary[-5]

    #puts "#{did}, #{title}, #{cata.to_s}, #{bookcard} | #{author_id}, #{author}, #{author_en} | #{booklink}"

    doc = { "_id" => did,
            "id" => did,
            "title" => title,
            "title_" => title_,
            "tag" => { },
            "cata" => cata,
            "cardlink" => bookcard,
            "booklink" => booklink,
            "author_id"  => author_id.to_i,
            "author"  => author,
            "author_en"  => author_en,
            "open_at"  => open_at,
            "update_at"  => update_at,
            "load_at"  => load_at
    }

    $coll.update({"_id" => did}, doc, {:upsert=>true})
    puts "=> Insert #{did}: #{title} by #{author} "
end
