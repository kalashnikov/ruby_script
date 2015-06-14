#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'net/http'
require 'net/https'

http = Net::HTTP.new('store.line.me', 443)
http.use_ssl = true
path = '/stickershop/list?listType=top'
#path = '/setLanguage?language=zh_TW&url=%2Fstickershop%2Flist%3page=FlistType%3Dtop'

# GET request -> so the host can set his cookies
resp, data = http.get(path, nil)
cookie = resp.response['set-cookie']

# POST request -> logging in
#data = 'serwis=wp.pl&url=profil.html&tryLogin=1&countTest=1&logowaniessl=1&login_username=blah&login_password=blah'
data = 'page=3&listType=top'
headers = {
  'Cookie' => cookie,
  'Referer' => 'https://store.line.me/stickershop/list',
  'Content-Type' => 'application/x-www-form-urlencoded'
}

resp, data = http.post(path, data, headers)

# Output on the screen -> we should get either a 302 redirect (after a successful login) or an error page
puts 'Code = ' + resp.code
puts 'Message = ' + resp.message
resp.each {|key, val| puts key + ' = ' + val}
puts data


