##!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'openssl'

# encoding: utf-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

#
# This ruby script get the essay list from 日本の名隨筆 
# URL: http://www.sakuhinsha.com/list/essay.html
#

# 
$OPCODE = ARGV[0]

link="http://www.sakuhinsha.com/list/essay.html"
home="http://www.sakuhinsha.com/list/"
page = Nokogiri::HTML(open(link, "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                           "Accept-Language" => "ja",
                           "Connection" => "keep-alive",
                           "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36"
                          ))
page.encoding = 'utf-8'

File.open("checkList.csv","w") do |f|
    page.css('td.col1').each do |o|
        #imglink = "https://store.line.me" + o.css('a')[0]['href']     # Get detail webpage link
        #imgsrc  = o.css('div.mdMN02Img img')[0]['src']                # Get Image Src Link
        #imgtext = o.css('div.mdMN02Desc')[0].text                     # Get Text

        booklink = home + o.css('a')[0]['href']
        booktext = o.text                     # Get Text

        puts "#########"
        puts "#{booktext} #{booklink}"

        dpage = Nokogiri::HTML(open(booklink, "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                                    "Accept-Language" => "ja",
                                    "Connection" => "keep-alive",
                                    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36"
                                   ))
        dpage.encoding = 'utf-8'

        dtext = dpage.css('p.text1')[1].text if dpage.css('p.text1')[1]
        if dpage.css('p.text1')[1]
            puts dtext
            f.puts "#{booktext},#{booklink},1"
        else
            f.puts "#{booktext},#{booklink},0"
        end

        puts "#########"
        sleep(1)
    end
end

