
#oauth-0.4.4...
require 'oauth'

require 'Oauth_client'

class Oauthwapper

  #@comKey       = "xb2mkv5ya5qua73saznap299"
  #@sharedSceart = "4h4AjgJdxm"
  
  @persistentHash = {} 

  def initialize(persistentHash = {})
    @persistentHash = persistentHash
    @comKey       = "vpskc7vyw5zk527gkyuykhph"
    @sharedSceart = "ZRe7D5YZ5c"
    @application_name = "Flix Montage"
  end
  
  def initializeAuthorization(returnUrl)
    consumer = OAuth::Consumer.new( @comKey, @sharedSceart,
                                   :site              => "http://api-public.netflix.com",
                                   :request_token_url => "http://api-public.netflix.com/oauth/request_token",
                                   :access_token_url  => "http://api-public.netflix.com/oauth/access_token",
                                   :authorize_url     => "https://api-user.netflix.com/oauth/login")
                                   
    request_token = consumer.get_request_token(:oauth_callback => returnUrl)
    
    @persistentHash[:consumer]      = consumer
    @persistentHash[:request_token] = request_token
    
    url = request_token.authorize_url(:oauth_callback     => returnUrl,
                                       :oauth_consumer_key =>  @comKey,
                                       :application_name   => @application_name)                   
    return url
  end
  
  def setAccessTokenKeys(params)
    request_token = @persistentHash[:request_token]
    
    access_token = request_token.get_access_token( {:oauth_token    => params[:oauth_token],
                                                    :oauth_verifier => params[:oauth_verifier]})
    
    response = access_token.get "/users/#{access_token.params[:user_id]}"
    @persistentHash[:consumer] = nil
    @persistentHash[:request_token] = nil
    @persistentHash[:secret]  = access_token.secret
    @persistentHash[:token]   = access_token.token
    @persistentHash[:user_id] = access_token.params[:user_id]
  end 
  
  def createAccessToken
    consumer = OAuth::Consumer.new( @comKey, @sharedSceart,
                                   :site              => "http://api-public.netflix.com",
                                   :request_token_url => "http://api-public.netflix.com/oauth/request_token",
                                   :access_token_url  => "http://api-public.netflix.com/oauth/access_token",
                                   :authorize_url     => "https://api-user.netflix.com/oauth/login")
    return OAuth::AccessToken.new(consumer, 
                                  @persistentHash[:token], 
                                  @persistentHash[:secret])
  end
  
  def request(baseUrl, querySet = [], httpMethod = "GET", outputTofile = "", nonUserCall = false)
    if outputTofile != "" 
       Logger.new(STDOUT).info 'OauthClient file' 
       Logger.new(STDOUT).info baseUrl + ", " + querySet.to_s + ", "+ httpMethod + ", "+ outputTofile + ", "
      res = outputTofileMethod(baseUrl, querySet, httpMethod, outputTofile)
    elsif nonUserCall
      client = OauthClient.new 
      res = client.prepairReuqest(baseUrl,querySet, httpMethod)
    else
      url = baseUrl
      queryString = getParamsString(querySet)
      if queryString != ""
      #  url += "?v=2.0&expand=@box+art&" + queryString
         url += "?" + queryString
      #else
      #  url += "?v=2.0&expand=@box+art"
      end

      accessToken = createAccessToken
      count = 1 
      begin
      #Users.find(1, :lock => 'LOCK IN SHARE MODE'){
        u1 = Users.find(1)
      rescue
        Logger.new(STDOUT).error 'lock : '  + url
        sleep(0.25)
        count += 1
        if count <= 2
          retry
        end 
      end
          if (url.length > 4000)
          res = accessToken.post baseUrl, getParamsHash(querySet).merge({'method' => httpMethod})
          else
            case httpMethod
              when "GET"
               res = accessToken.get url
              when "POST"
              res = accessToken.post url
              when "PUT"
              res = accessToken.put baseUrl, getParamsHash(querySet)
              when "DELETE"
              res = accessToken.delete url
            end
          end 
    end
    return res
  end
  
  def timedRequest(repetedSet, *paramsSet)
    ret = []
    prototRequestquery = paramsSet[1]
    itor = 1
    repetedSet.each do |item|
      querySet = prototRequestquery.dclone()
      querySet << item[0]
      ret << self.request(paramsSet[0],querySet,paramsSet[2],paramsSet[3])
      if itor == 4
          itor = 0
          sleep(1)
      end
      itor += 1
    end
    return ret
  end
  
  def outputTofileMethod(baseUrl, querySet = [], httpMethod = "GET", outputTofile = "")
    client = OauthClient.new 
    res = client.prepairReuqest(baseUrl,querySet, 
                 @persistentHash[:secret], 
                 @persistentHash[:token], 
                 httpMethod,outputTofile)
    return res
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
  
  def hashTo_param(newHash)
    ret_h = ""
    if newHash != {}
      newHash.each{|key,value|
         ret_h << (key.to_s + "=" + value.to_s)
      }
    end
    return ret_h
  end
  
  def escape(value)
    return CGI.escape(value.to_s).gsub("%7E", '~').gsub("+", "%20")
  end
  
  def unescape(value)
    return CGI.unescape(value.to_s)
  end
  
end