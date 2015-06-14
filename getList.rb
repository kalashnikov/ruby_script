#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'nokogiri'
require 'open-uri'
require 'openssl'

#
# This ruby script generate Sticker thumbnail from LINE official site
#

# 
$OPCODE = ARGV[0]

#
$OPNAME = ["official","creator"]
$OPLIST = ["https://store.line.me/stickershop/list?page=", #{n}&listType=top",
           "https://store.line.me/stickershop/showcase/top_creators?page="]#{n}&listType=top"]

#https://store.line.me/stickershop/list?page=2&listType=top
#https://store.line.me/stickershop/showcase/top_creators?page=2&listType=top

cookie = open("https://store.line.me/stickershop/list?page=1&listType=top", :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).meta['set-cookie']#.split('; ',2)[0]
                                          
newck  = "store_locale=zh_TW; store_lang=zh-hant; " + cookie

$OPLIST.each do |opl|
    str = $OPNAME[$OPLIST.index(opl)]
    File.open("#{str}.html",'w') do |output|
=begin
        puts "<!DOCTYPE html>"
        puts "<html>"
        puts "<title> Grid Demo </title>"
        puts "<head>"

        # CSS
        puts '<link rel="stylesheet" type="text/css" href="css/forGrid.css">'

        # JS
        puts %q{
    <!-- jQuery is the GOD -->
    <!--<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>-->
    <!--<script type="text/javascript" src="js/jquery-ui-1.8.19.custom.min.js"></script>-->
    <script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>

    <!--Scroll Control-->
    <script type="text/javascript">
        var winW, winH;
        $(document).ready(function() {
            winW = $(window).width();
            winH = $(window).height();

            $(window).scroll(function(){
                $scroll = $(this).scrollTop();

                //這部份是在寫 Navi 的動畫，往下 scroll 時 會變矮。
                if(winW > 720){
                    if ($scroll >= 100) {
                        $('#logo').css('float','left');
                        $('#navi-menu').css('float','right');
                        $('#navi-menu').css('width','auto');
                        $('#navi-wrapper').css('padding-top','10px');
                        $('#navi-wrapper').css('padding-bottom','5px');
                        $('#color-bar').css('top','62px');
                        $('#color-bar').css('height','3px');
                        $('#navi-menu').css('margin-top','-5px');
                        $('#navi-menu ul li').css('margin-left','5px');
                        $('#navi-menu ul li').css('margin-right','5px');
                        $('#navi-menu ul li a').css('font-size','14px');
                    } else{
                        $('#logo').css('float','none');
                        $('#navi-menu').css('float','none');
                        $('#navi-menu').css('width','700px');
                        $('#navi-wrapper').css('padding-top','30px');
                        $('#navi-wrapper').css('padding-bottom','0px');
                        $('#color-bar').css('top','0px');
                        $('#color-bar').css('height','5px');
                        $('#navi-menu').css('margin-top','10px');
                        $('#navi-menu ul li').css('margin-left','15px');
                        $('#navi-menu ul li').css('margin-right','15px');
                        $('#navi-menu ul li a').css('font-size','16px');
                    };
                };
            });

            $('#navi-expand').on('click',function(){
                if($(this).hasClass('isclose')){
                    $(this).removeClass('isclose');
                    $('#color-bar').addClass('active');
                    $('#navi-menu').addClass('active');
                } else {
                    $(this).addClass('isclose');
                    $('#color-bar').removeClass('active');
                    $('#navi-menu').removeClass('active');
                }
            });
        });
    </script>	
    <!--Set Staic Navi START-->
    <script type="text/javascript">
        $(document).ready(function() {
            $thisPage = $('body').attr('rel')-1;
            $('.mainnav li a:eq('+$thisPage+')').addClass('focus');
        });
    </script>
    <!--Set Staic Navi END-->
             }
        
        puts "</head>"
        puts '<body rel="1" style="position:relative;">'
        
        # Navi
        puts %q{
    <nav id="navi">
    <div id="color-bar"></div>
    <div id="navi-wrapper">
        <a href="/"><img style="width:121px; height:41px;" src="https://sites.google.com/site/obmine001/_/rsrc/1396360318467/config/customLogo.gif?revision=7" alt="OBM  Logo" id="logo"/></a> 
        <div id="navi-expand" class="isclose"><img src="images/navi-expand-big.png"></div>
        <div id="navi-menu">
            <ul class="mainnav">
                <li><a id="home-btn" href="/">HOME</a></li>
                <li><a id="about-btn" href="https://sites.google.com/site/obmine001/line-xiao-ji-qiao/-jiao-xue-zhang-hao-bang-dinge-mail-jiao-xue">ABOUT</a></li>
                <li><a id="fb-btn" href="https://www.facebook.com/OBM.LINE" target="_blank">Facebook</a></li>
                <li><a id="blog-btn" href="http://obmine001.blogspot.tw/" target="_blank">BLOG</a></li>
                <li><a id="line-btn" href="http://goo.gl/HdXrJn" target="_blank">LINE</a></li>
            </ul>
        </div>
    </div>	
    </nav>

    <HR>
             }
        puts '<div id="wrapper" style="margin-top:150px;">'
        puts '<div id="columns">'
=end 

        (1..30).each do |n|

            link = "#{opl}#{n}&listType=top"
            #link = "https://store.line.me/stickershop/list?page=#{n}&listType=top"
            
            #puts "### #{link} ###"
            page = Nokogiri::HTML(open(link, "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                                             "Accept-Language" => "zh-TW,zh;q=0.8,en;q=0.6,en-US;q=0.4",
                                             "Cookie" => newck,
                                             "Connection" => "keep-alive",
                                             "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36"
                                             ))
            page.encoding = 'utf-8'

            
            page.css('li.mdMN02Li').each do |o|
                output.puts '<div class="pin">'
                
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

                output.puts "\t<a href=\"#{imglink}\">" 
                output.puts "\t\t<img src=\"#{imgsrc}\" />"
                output.puts "\t</a>" 
                output.puts "\t<p> <h3>#{imgtext}</h3><br> #{dtext} </p>" 

                output.puts '</div>'
            end
            output.puts
        end
=begin        
        puts "</div>" 
        puts "</div>" 
        puts "</html>"
=end
    end
end
