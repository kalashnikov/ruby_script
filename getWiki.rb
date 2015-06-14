#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'wikipedia'

Wikipedia.Configure {
    domain 'ja.wikipedia.org'
    path   'w/api.php'
}

if ARGV.length==0
    puts "Input keyword"
    exit
end

page = Wikipedia.find(ARGV[0])
p page
page.content.split("\n").each do |l|
    next if l =~ /^{{/ # Note for wiki page
    next if l =~ /^\[\[\S+:.*\]\]$/  # File 
    next if l.chomp.length==0
    abs = l
    abs = abs.gsub!(/\[\[/,"") if abs.include?("[[")
    abs = abs.gsub!(/\]\]/,"") if abs.include?("]]")
    puts abs
end

#p page.categories

#page.links

#page.extlinks

#p page.images
#p page.image_urls

