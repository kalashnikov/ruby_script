#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'mongo'
require 'csv'
require 'set'
include Mongo

#
# This script load sticker tags from CSV 
# And update in MongoDB
#

# Setting for MongoDB
$db = MongoClient.new("localhost", 27017).db("obmWeb")
$auth = $db.authenticate("obm", "back54321")
$coll = $db["stickers"]

# Setting for LINE Site
$OPNAME = ["official","creator"]
$OPLIST = ["https://store.line.me/stickershop/list?page=",
           "https://store.line.me/stickershop/showcase/top_creators?page="]

cookie = open("https://store.line.me/stickershop/list?page=1&listType=top", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).meta['set-cookie']
newck  = "store_locale=zh_TW; store_lang=zh-hant; " + cookie

if ARGV.length!=1
    puts "Please provide Tag file."
    exit
end

# Load tags from file
tagHash = {}
tagSet  = Set.new
CSV.foreach(ARGV[0]) do |r|
    next if r[0]=='ID'
    id, tag = r[0], r[1]
    tagHash[id.to_i]=tag.split('.')
    tag.split('.').each do |i|
        tagSet.add(i)
    end
end

# Check Database and Update 
needLoad = []
File.open('nonExist.csv','w') do |out|
    tagHash.each do |k,v|
        result = $coll.find_one("sticker_id" => k)
        if !result
            out.puts k
            needLoad.push(k)
        else
            result['tag'] = v
            $coll.update({"sticker_id" => k }, result)
        end
    end
end

# Write out tag for cache 
File.open('/var/opt/www/sinatra/public/tagList','w') do |out|
    tagSet.each do |i|
        out.puts i
    end
end

needLoad.each do |id|
    puts "Checking #{id} ... "
    link = "https://store.line.me/stickershop/detail?packageId=#{id}"
    dpage = Nokogiri::HTML(open(link, "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                                    "Accept-Language" => "zh-TW,zh;q=0.8,en;q=0.6,en-US;q=0.4",
                                    "Cookie" => newck,
                                    "Connection" => "keep-alive",
                                    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36"
                                   ))
    dpage.encoding = 'utf-8'

    check     = dpage.css('div.MdMN13Error')[0]
    if check  # Indicate ERROR page 
        puts "NOT FOUND: #{id}"
        next
    end

    dtext     = dpage.css('p.mdMN07Desc')[0].text
    imgtext   = dpage.css('h2.mdMN05Ttl')[0].text
    imgsrc    = dpage.css('div.mdMN05Img img')[0]['src']
    detailImg = dpage.css('div.mdMN07Img img')[0]['src']

    doc = { "id" => id,
            "sticker_id" => id,
            "name" => imgtext,
            "tag" => tagHash[id],
            "detail" => link,
            "description" => dtext,
            "thumbnail" => imgsrc,
            "detailImg" => detailImg 
    }
    $coll.insert(doc)
end

