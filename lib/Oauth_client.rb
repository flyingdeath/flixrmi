
class OauthClient
  require "hmac-md5"
  require "hmac-sha1"

  @@comKey       = "vpskc7vyw5zk527gkyuykhph"
  @@sharedSceart = "ZRe7D5YZ5c"

  #@@comKey       = "vpskc7vyw5zk527gkyuykhph"
  #@@sharedSceart = "ZRe7D5YZ5c"

  #Dim comKey As String       = "xb2mkv5ya5qua73saznap299"
  #Dim sharedSceart As String = "4h4AjgJdxm"
  

  def initialize
    
  end
  
  def getComKey()
    return @@comKey
  end 
  
  def makeTimedRequest(repetedSet, *paramsSet)
    ret = []
    prototRequestquery = paramsSet[1]
    itor = 1
    repetedSet.each do |item|
      requestquery = prototRequestquery.dclone()
      requestquery << item[0]
      ret << self.prepairReuqest(paramsSet[0],requestquery,paramsSet[2],paramsSet[3],paramsSet[4],paramsSet[5],paramsSet[6])
      if itor == 4
          itor = 1
          sleep(1)
      end
      itor += 1
    end
    return ret
  end

  def prepairReuqest(currentBaseURL,requestquery = [], token_secret ="",
                      myToken ="", httpMethod = "GET", outputTofile = "", n = 0)
                      
     originalRequestquery = requestquery.dclone()
     originalHttpMethod   = httpMethod.dclone()
     
     oauthparams = getOauthhash(@@comKey,myToken)
     requestquery.concat(oauthparams)
     
     requestquery  =  sortParamsArray(requestquery)
     newSig        =  getSig(getParamsString([httpMethod,currentBaseURL,requestquery],true),@@sharedSceart,token_secret)   
     requestquery  << {:oauth_signature => escape(newSig)}
     url           =  (currentBaseURL + "?" + getParamsString(requestquery))
     
     # if (url.length > 6000)
     #   ret = createPostGetRequest(n, currentBaseURL, originalRequestquery, token_secret, myToken, originalHttpMethod )
     # else
        ret = makeNetRequest(url,httpMethod,outputTofile)
     # end 
     return ret
   end 
   
   
   def basicRequest(url,rQuery,tSecret,token,o_method)
       oauthparams = getOauthhash(@@comKey,token)
       rQuery.concat(oauthparams)
       
       rQuery  =  sortParamsArray(rQuery)
       sig     =  getSig(getParamsString([o_method,url,rQuery],true),@@sharedSceart,tSecret)
       rQuery  << {:oauth_signature => escape(sig)}
       f_url   =  (url + "?" + getParamsString(rQuery))
       ret = makeNetRequest(f_url,o_method,"")
     return ret
   end
   
   
   def requestMethod_9(url,rQuery,tSecret,token,o_method)
       oauthparams = getOauthhash(@@comKey,token)
       post_oauthparams = getOauthhash(@@comKey,token)
       rQuery.concat(post_oauthparams)
       o_rQuery = rQuery.dclone()
       oauthparams.concat(rQuery)
       method = "POST"
       oauthparams  << {:method => o_method}
       oauthparams  =  sortParamsArray(oauthparams)
       rQuery       =  sortParamsArray(rQuery)
       sig          =  getSig(getParamsString([method,url,oauthparams],true),@@sharedSceart,tSecret)
       post_sig     =  getSig(getParamsString([o_method,url,rQuery],true),@@sharedSceart,tSecret)
       oauthparams  << {:oauth_signature => escape(sig)}
       rQuery       << {:oauth_signature => escape(post_sig)}
       safe    =  crossJoin(o_rQuery,oauthparams)
       f_url   =  (url)  
       ret = makeNetRequest(f_url, method, "", getParamsHash(oauthparams)) # 
     return ret
   end
   
   def createPostGetRequest(n, url,rQuery,tSecret,token,o_method)
       case n 
         when 0
          rQuery[0][rQuery[0].keys[0]] = CGI.unescape(rQuery[0][rQuery[0].keys[0]])
       end 
       case n
         when 0
           ret = basicRequest(url,rQuery,tSecret,token,o_method)
         when 9
           ret = requestMethod_9(url,rQuery,tSecret,token,o_method)
         else
          ret = basicRequest(url,rQuery,tSecret,token,o_method)
       end
     return ret
   end 
   
   def makeNetRequest(urlString ,httpMethod = "GET", outputTofile ="", postSet = {}, overRide = {})
     url = URI.parse(urlString)
     case httpMethod
        when "GET"
          req = Net::HTTP::Get.new(url.request_uri)
        when  "POST"
          if overRide == {}
            req = Net::HTTP::Post.new(url.request_uri)
          else
            req = Net::HTTP::Post.new(url.request_uri,overRide)
          end
           req.set_form_data(postSet, '&')
         # req.body = getParamsString(postSet)
        when  "DELETE"
          req = Net::HTTP::Delete.new(url.request_uri)
          req.set_form_data(postSet, '&')
       when "PUT"
          req = Net::HTTP::Put.new(url.request_uri)
          req.set_form_data(postSet, '&')
     end
     tryCount = 0
     if (outputTofile != "")
       File.open( outputTofile,'w'){|file|
         Logger.new(STDOUT).info "create file"
         Net::HTTP.start(url.host, url.port) {|http|
           Logger.new(STDOUT).info "start http"
           begin
             http.request(req){|response|
               response.read_body{|body|
                  file.write(body)
                }
              }      
            rescue StandardError => error
              Logger.new(STDOUT).info "Net::HTTP: Connection error. : \n" + error.message  + "\n" +  error.backtrace.join("\n") + "\n\n"
              
            end
          }
        }
        return outputTofile
     else
       begin
         newResponse = Net::HTTP.start(url.host, url.port) {|http|
            http.request(req)
          }
         return newResponse 
       rescue StandardError => error
         if error.methods.index("errno")
           if tryCount == 0 and error.errno == 10060
             sleep(1)
             tryCount += 1
             retry
           else
             raise "Net::HTTP: Connection error. : \n" + error.message + "\n" +  error.backtrace.join("\n") + "\n\n"
           end 
         else
           raise "Net::HTTP: Connection error. : \n" + error.message  + "\n" +  error.backtrace.join("\n") + "\n\n"
         end 
       end
     end
  end
    
  def getParamsString(paramsArray,escapeParamSets = false)
     ret_s = ""
    paramsArray.each{|element|
      if escapeParamSets
        ret_s << escape(string_value(element))
      else
        ret_s << string_value(element)
      end
      ret_s <<  "&"
     }
     ret_s = ret_s.chomp("&")
     return ret_s
  end

  def getParamsHash(paramsArray,escapeParamSets = false)
    ret_h = {}
    paramsArray.each{|element|
      element.each{|key,value|
        if escapeParamSets
          ret_h[key.to_s] = escape(value)
        else
          ret_h[key.to_s] = value
        end
      }
     }
     #ret_h.keys.sort
     return ret_h
  end

  def string_value(element)
      ret = ""
      if element.class == Hash
        ret = hashTo_param(element)
      elsif element.class == String
        ret = element
       else
        ret = getParamsString(element)
      end
      return ret
  end

  def getOauthhash(mycomKey,myToken = "")
    retArray  = [{:oauth_consumer_key =>     mycomKey},
                 {:oauth_nonce =>            getRandomNumber()},
                 {:oauth_signature_method => "HMAC-SHA1"},
                 {:oauth_timestamp =>        getNewdateStamp()},
                 {:oauth_version =>          "1.0"}]

    if myToken != ""
      retArray.insert(4,{:oauth_token =>     myToken})
    end

   return retArray
  end
  def hashTo_param(newHash)
     ret_h = ""
     if newHash != {}
       newHash.each{|key,value|
          ret_h << (key.to_s + "=" + value.to_s)
       }
     end
     return ret_h
  end


  def getSig(data, sSceart, token_secret='')
    secret= "#{escape(sSceart)}&#{escape(token_secret)}"
    Base64.encode64(HMAC::SHA1.digest(secret,data)).chomp.gsub(/\n/,'')
  end


  def escape(value)
    return CGI.escape(value.to_s).gsub("%7E", '~').gsub("+", "%20")
  end

  def getNewdateStamp()
    current_Date =  Time.new()+ (60 * 60 * 8)
    #current_Date_dls =  Time.new()+ (60 * 60 * 7)
    static_date =  Time.parse("January 1, 1970 00:00:00")
    #Time.new(year, month=nil, day=nil, hour=nil, min=nil, sec=nil, utc_offset=nil)
    #https://api.netflix.com/oauth/clock/time
    #<time>1321040206</time>
    return (current_Date - static_date).to_i.to_s
  end
  
  def getRandomNumber()
    return srand.to_s
  end

  def appendNonempty(list,key,flag)
      if flag != ""
        list << ({key => flag})
      end
      return list
  end

  def sortParamsArray(inputArray)
    return inputArray.sort{|a,b|
      a.keys[0].to_s <=> b.keys[0].to_s
    }
  end
  
   def crossJoin(setA, setB)
     ret = setB.dclone()
     ret.reject!{|a| 
        setA.index(a) 
     }
     return ret
   end

end
