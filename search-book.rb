require 'google-search'

# encoding: utf-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

def find_item query
    #print "%35s " % query
    search = Google::Search::Web.new do |search|
        search.query = query
        #search.size = :large
        #search.each_response { print '.'; $stdout.flush }
    end
    flag = false 
    query.gsub!(/^.*jp/,"")
    search.each do |i|
        if i.uri =~ /cards.*files/
            #puts "#{i.title} | #{i.uri}"
            puts "#{query}, #{i.uri}"
            flag = true
            break
        end
    end
    puts "#{query}, " if !flag 
end

#str = "泉鏡花　　 草あやめ"
#find_item 'site:www.aozora.gr.jp "草野心平　 山頂の花"'
#find_item 'site:www.aozora.gr.jp "泉鏡花　　 草あやめ"'
#find_item "site:www.aozora.gr.jp \"#{str}\""
#find_item 'site:www.aozora.gr.jp "泉鏡花　　 草あやめ"'

cnt = 0
File.open(ARGV[0]).each_line do |l|
    next if l.include?("###")
    next if l.include?("【内容目次】")
    next if l.include?("sakuhinsha")
    title = l.chomp.strip
    if title!=""
        find_item "site:www.aozora.gr.jp \"#{title}\""
    end
    sleep(2)
    cnt += 1 
    sleep(5) if cnt%10==0
end
