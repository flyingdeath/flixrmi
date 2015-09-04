module CategoryHelper

 def checkImages(l)
   # _epx and _ste
   #http://cdn-3.nflximg.com/us/boxshots/ghd/

   g = l.gsub('/boxshots/large/','/boxshots/ghd/')
   m = File::join Rails.root, "public/flixrmi/images/missing.jpg"
   ret = l

   mem_buf = File.open(m,"rb") {|io| io.read}
   url = URI.parse(g)
   res = Net::HTTP.new(url.host).head(url.request_uri)
   if 7718 != res.header['content-length'].to_i
      ret = g
   end
    
   return ret
 end 
 
end
