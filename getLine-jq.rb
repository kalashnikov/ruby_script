#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'openssl'

#
# This ruby script get Thumbnail from Top10 pages  
#

cookie = open("https://store.line.me/stickershop/list?page=1&listType=top", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).meta['set-cookie']#.split('; ',2)[0]
                                          
newck  = "store_locale=zh_TW; store_lang=zh-hant; " + cookie

File.open('demo.html','w') do |output|
    puts "<!DOCTYPE html>"
    puts '<!--[if lte IE 8]>     <html class="lt-ie9"> <![endif]-->'
    puts '<!--[if gt IE 8]><!--> <html class=""> <!--<![endif]-->'
    puts "<html>"
    puts "<title> Grid Demo </title>"
    puts "<head>"
    puts '<meta charset="utf-8" />'
    puts '<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />'

    puts '<link rel="stylesheet" type="text/css" href="css/forGridJq.css">'
    puts '<script src="js/jquery-1.7.1.min.js"></script>'
    puts '<script src="js/masonry.pkgd.min.js"></script>'
    puts '<script src="js/imagesloaded.pkgd.min.js"></script>'
    puts '<script src="js/jquery.infinitescroll.min.js"></script>'

    puts "<script>
            var $container = $('#container');
            $container.imagesLoaded(function(){
              $container.masonry({
                itemSelector : '.item',
                columnWidth : 240
              });
            });
          </script>"

    puts "  <style>
            .item{
                display: inline-block;
                border: 1px dotted #4F4F4F;
                padding: 10px;
                margin: 5px 5px 5px 0;
                overflow:hidden;
                width:25%;
            }
            </style>"

    puts "</head>"
    puts "</body>"
    
    #puts '<div id="wrapper">'
#    puts "<div id=\"container\"  class=\"js-masonry\"
#  data-masonry-options='{ \"columnWidth\": 200, \"itemSelector\": \".item\" }'>"

    puts "<div id=\"container\" style=\"width:960px; overflow:hidden; margin:0 auto;\">"

    (1..10).each do |n|

        link = "https://store.line.me/stickershop/list?page=#{n}&listType=top"
        #puts "### #{link} ###"
        page = Nokogiri::HTML(open(link, "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                                         "Accept-Language" => "zh-TW,zh;q=0.8,en;q=0.6,en-US;q=0.4",
                                         "Cookie" => newck,
                                         "Connection" => "keep-alive",
                                         "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36"
                                         ))
        page.encoding = 'utf-8'

        
        page.css('li.mdMN02Li').each do |o|
            puts '<div class="item">'
            
            imglink = "https://store.line.me" + o.css('a')[0]['href']     # Get detail webpage link
            imgsrc  = o.css('div.mdMN02Img img')[0]['src']                # Get Image Src Link
            imgtext = o.css('div.mdMN02Desc')[0].text                     # Get Text

            dpage = Nokogiri::HTML(open(imglink, "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                                       "Accept-Language" => "zh-TW,zh;q=0.8,en;q=0.6,en-US;q=0.4",
                                       "Cookie" => newck,
                                       "Connection" => "keep-alive",
                                       "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36"
                                      ))
            dpage.encoding = 'utf-8'

            dtext = dpage.css('p.mdMN07Desc')[0].text

            puts "\t<a href=\"#{imglink}\">" 
            puts "\t\t<img src=\"#{imgsrc}\" />"
            puts "\t</a>" 
            puts "\t<p> <h3>#{imgtext}</h3><br> : #{dtext} </p>" 

            puts '</div>'
        end
        puts
    end
    
    puts "</div>" 
    #puts "</div>" 
    puts "</body>"
    puts "</html>"
end

