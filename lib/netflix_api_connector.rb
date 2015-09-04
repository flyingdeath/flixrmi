
require 'netflix_api_connection_data'
require "netflixParser"
require 'Oauthwapper'
require 'rexml/document'
require 'sfile'


class NetflixApiConnector
  include REXML
  @persistentHash = {}
  @params = {}
  @retry_count = 0
  
  def initialize(session, params= {} )
     @params  = params
     @persistentHash = session[:persistentHash]
     @retry_count = 0
  end

  def  startAuth(returnUrl)
    client = Oauthwapper.new(@persistentHash)
    return  client.initializeAuthorization(returnUrl)
  end


  def  testAccessToken()
    client = Oauthwapper.new(@persistentHash)
    client.setAccessTokenKeys(@params)
  end


  def getNetflixData(method, options = {}, pushToHash = true) 
    #debugger
      n = 1
      i = 1
      response = nil
      
      begin
        user1 = Users.find(1)
      rescue ActiveRecord::StaleObjectError => e
        if i <= n
          i += 1
          sleep(rand(2))
           user1.reload
           retry
         end
       rescue Exception => e
         if i <= n
           i += 1
           sleep(rand(10))
           user1 = nil
           retry
        end
      end 
          response = self.makeNetFlixApiCall(method, options.dclone)

    begin
      parsedRequest =  parseResponseFull(response, pushToHash)
    rescue Exception => e
        if e.message == "retry Please"
          retry
        else
            raise e.message + "\n" +  e.backtrace.join("\n")
        end
    end
    return parsedRequest
  end
  
#  def self.retry_attempts
#    10
#  end
  
#  def rescue_action_with_stale_object_reraise(exception)
 #   request.reraise_stale_object_errors(exception)
#    rescue_action_without_stale_object_reraise(exception)
 # end
 # alias_method_chain :rescue_action, :stale_object_reraise
  
  def makeNetFlixApiCall(method, options = {}, n = 0)

    set       = getMethodSet(     method)
    params    = getParams(        set[:currentMethodSet],  set[:dataMap],   method)
    urlParams = checkParamsUrl(   params[:currentParams],  set[:myBaseURL], options)
    queryObj  = createRequestQuery(method, params[:usableURLParams], options)
    
  #  evenTimingRequestCheck()
    client = Oauthwapper.new(@persistentHash)
    
    
    if queryObj[:timedRequest]
      return client.timedRequest(queryObj[:repetedSet], urlParams[:myBaseURL], 
                                 queryObj[:querySet],   urlParams[:httpMethod], 
                                 urlParams[:outputTofile])
    else
      return client.request(urlParams[:myBaseURL],  queryObj[:querySet],
                            urlParams[:httpMethod], urlParams[:outputTofile], params[:currentParams][:nonUserCall])
    end
  end 
  
  def getMethodSet(method)
    dataMap = NetflixApiConnectionData.new
  
    currentMethodSet = dataMap.getMethodData(method)
    if !(currentMethodSet)
           raise "Method Name not found:" + method.to_s
    end
    
    if currentMethodSet[:url]
      myBaseURL = currentMethodSet[:url]
      if myBaseURL == "fill" 
        if options[:url]
          myBaseURL = options[:url]
        else
          raise "Required option missing: url"
        end 
      end 
    else
      if dataMap.getbaseurlsData(method)
        myBaseURL = dataMap.getbaseurlsData(method)
      else
        raise "Data Set incomplete: url, " + method.to_s
      end
    end
    return {:myBaseURL => myBaseURL, :currentMethodSet => currentMethodSet, :dataMap =>  dataMap}
  end
  
  
  def getParams(currentMethodSet, dataMap, method)
    currentParams = {}
    usableURLParams = []

    if  currentMethodSet[:param]
      currentParams   = currentMethodSet[:param]
    else
      currentParams   = currentMethodSet
    end
    if currentParams[:paramSet]
      usableURLParams = currentParams[:paramSet]
    elsif dataMap.getParamsData(method)
      usableURLParams = dataMap.getParamsData(method)
    end
    return {:currentParams => currentParams, :usableURLParams => usableURLParams }
  end
  
  def checkParamsUrl(currentParams,  myBaseURL, options)
  
    httpMethod = "GET"
    outputTofile = ""
    
    currentParams.each{|key,value|
      case key
      when :paramSet, :param, :url, :nonUserCall
      when :writeToFile
        if (options[key])
          outputTofile = options[key]
        else
            raise "Required option missing: " + key.to_s
        end
      when :verb
        httpMethod = currentParams[:verb]
      when :userAuth
        if options[:secret] and options[:token] 
         if !currentParams[:user_id] and options[:user_id]
            myBaseURL = appendId(value, options[key], myBaseURL)
         end 
        elsif  @persistentHash[:secret] and  
               @persistentHash[:token] and  
               @persistentHash[:user_id]
           if !currentParams[:user_id]
             myBaseURL = appendId(value,  @persistentHash[key], myBaseURL)
           end 
        else
            raise "Required option missing: oauth_token_secret or oauth_token or user_id auth Not set."
        end 
      else
        if options[key]
          myBaseURL = appendId(value, options[key],myBaseURL)
        elsif currentParams[:userAuth] and key == :user_id and @persistentHash[key]
            myBaseURL = appendId(value,  @persistentHash[key], myBaseURL)
        elsif currentParams[:userAuth] and key == :user_id
            raise "Required option missing: " + key.to_s + " (session not set)."
        else
            raise "Required option missing: " + key.to_s
        end 
      end 
    }
    return {:httpMethod => httpMethod, :myBaseURL => myBaseURL, :outputTofile => outputTofile}
  end 
  
  
  def createRequestQuery(method, usableURLParams, options)
    requestquery = []
    timedRequest = false
    dontAppend = false
    client = Oauthwapper.new()
    
    repetedSet = []
    usableURLParams.each{|item|
      curKey = item.keys[0]
      case curKey
      when :term
        if !(options[curKey])
            raise "Required url option missing: " + curKey.to_s
        end
        options[curKey] = client.escape(options[curKey])
      when :title_ref
        if !(options[curKey])
            raise "Required url option missing: " + curKey.to_s
        end
        options[curKey] = client.escape(options[curKey])
      when :title_refs
        if !(options[curKey])
            raise "Required url option missing: " + curKey.to_s
        end
        timedRequest = true
         temp = sliptN(options[curKey],",",500)
        # temp = sliptUntilLength(options[curKey],",",4000)
        itor = 0
        temp.each {|tItem| 
          if !(repetedSet[itor])
            repetedSet[itor] = []
          end
          repetedSet[itor] << {:title_refs =>tItem } #client.escape(tItem) 
          itor += 1
        }
        dontAppend = true
      when :etag
         if !(options[curKey])
           if method != :get_etag 
             if !(@persistentHash[:etag])
               if method.to_s.index("instant") 
                 getNetflixData(:get_etag_instant, {:max_results => "1"})
               else
                 getNetflixData(:get_etag_disc, {:max_results => "1"})
               end
            end 
            options[curKey] = @persistentHash[:etag] 
           end 
         end
      end 
      if options[curKey] and options[curKey] != "" and !(dontAppend)
        newItem = item 
        newItem[curKey] = options[curKey] 
        requestquery << newItem
      elsif item[curKey] != ""
        requestquery << item
      end
      dontAppend = false
    }
    return {:querySet => requestquery, :repetedSet => repetedSet, :timedRequest => timedRequest }
  end
  
  
    
  def evenTimingRequestCheck()
  
    if !(@persistentHash[:request_time])
      @persistentHash[:request_time] = Time.now
      @persistentHash[:request_count] = 0
    end 
    
    if (Time.now - @persistentHash[:request_time]) <= 1
      @persistentHash[:request_count] += 1
        Logger.new(STDOUT).info 'request_count = '+ @persistentHash[:request_count].to_s
      if @persistentHash[:request_count] >= 4
        Logger.new(STDOUT).info 'sleep ' 
        sleep(1)         
        @persistentHash[:request_time] = Time.now
        @persistentHash[:request_count] = 1
      end
    else
        Logger.new(STDOUT).info 'reset request_count = '+ @persistentHash[:request_count].to_s
       @persistentHash[:request_time] = Time.now
       @persistentHash[:request_count] = 1
    end 
  end

  def sliptN(strData,char,n)
    temp = strData
    ret = []
    while temp != "" do
      set  =   temp.split(char,n+1)
      temp =   set.last
      if set.count >= n +1
        ret  << (set - [temp]).join(char)
      else
        ret  << (set).join(char)
        temp = ""
      end
    end 
    return ret
  end 
  
  def sliptUntilLength(strData,char,length)
    temp = strData
    ret = []
    t = "" 
    while temp != "" do
      set  =   temp.split(char)
      temp = ""
      t    = "" 
      set.each{|v|
        if t.length <= length
          t <<  v + char 
        else
          temp <<  v + char 
        end 
      }
      ret << t.chop
    end 
    return ret
  end 
  
   

  def appendId(replaceStr, replacement,str)
    ret = ""
    if str.index(replaceStr)
      ret = str.sub(replaceStr, replacement.to_s)
    else
      ret = str + "/"+replacement.to_s
    end
    return ret
  end
  
  
  def parseResponseFull(response, pushToHash = false)
    if response.class != Array
       ret = parseResponse(response, pushToHash)
    else 
      ret = []
      response.each {|item|
        newhash = parseResponse(item,pushToHash)
        ret << newhash
      }
    end 
    return ret
  end
  

  def parseResponse(response, pushToHash = false)
    if !(response)
      return errorred_call({:message=> "Net::HTTP: Connection error."})
    elsif response.class == String
      if File.exist?(response)
        return successful_call({:filename => response})
      end
    else
      status = response.code.to_i
      if status >= 200 and status < 400
        return successful_call({:response => response, :pushToHash => pushToHash})
      else
        return failed_call({:response => response, :status => status.to_s, :pushToHash => pushToHash})
      end
    end 
  end


  def parsefailureMessage(status, response, pushToHash)
    statusSet = getStatusSet()
    curSet = statusSet[status[:code]]
    ret = nil
    if curSet
      if curSet[:acceptable]
        if curSet[:etag]
          if  curSet[:etag].index(status[:message])
            ret = etagRetry_call({:response => response, 
                                   :pushToHash => pushToHash})
          elsif curSet[:retry]
            ret = retry_call({:response => response, 
                               :pushToHash => pushToHash,
                               :timeout => curSet[:timeout]})
          else
            ret = successful_call({:response => response, 
                                    :pushToHash => pushToHash})
          end
        elsif curSet[:retry]
          ret = retry_call({:response => response, 
                             :pushToHash => pushToHash,
                               :timeout => curSet[:timeout]})
        else
          ret = successful_call({:response => response, 
                                  :pushToHash => pushToHash})
        end                         
      elsif curSet[:subcode]
        if status[:subcode]
          if curSet[:subcode][status[:subcode]]
            if curSet[:subcode][status[:subcode]][:retry]
              ret = retry_call({:response => response, 
                                :pushToHash => pushToHash,
                                :timeout => curSet[:subcode][status[:subcode]][:timeout]})
            elsif curSet[:subcode][status[:subcode]][:acceptable]
              ret = successful_call({:response => response, 
                                      :pushToHash => pushToHash})
            end
          end
        elsif curSet[:retry].class.to_s ==  "Array"
          if curSet[:retry].index(status[:message])
             ret = retry_call({:response => response, 
                               :pushToHash => pushToHash,
                               :timeout => curSet[:timeout]})
          end 
        end 
      elsif curSet[:retry].class.to_s ==  "Array"
        if curSet[:retry].index(status[:message])
           ret = retry_call({:response => response, 
                             :pushToHash => pushToHash,
                             :timeout => curSet[:timeout]})
        end 
      end 
    end 
    if !(ret)
      ret = errorred_call({:status => status})
    end
    return ret
  end


  def errorred_call(args)
    destroyAuthSet()
    if args[:message]
      raise args[:message]
    elsif args[:status]
      raise "Netflix API error: \n"+
             "Status Code:" + args[:status][:code].to_s    + "\n" +
             "Sub Code:"    + args[:status][:subcode].to_s + "\n" +
             "Message:"     + args[:status][:message].to_s
    else
      raise "Program Error."
    end
  end


  def retry_call(args)
    if args[:timeout]
      sleep(args[:timeout].to_i)
    end 
    
    @retry_count += 1
    if @retry_count < 10
      @persistentHash[:etag] = nil
    #  debugger
      raise "retry Please"
    else
      successful_call(args)
    end
  end

  def etagRetry_call(args)
    @persistentHash[:etag] = nil
    retry_call(args)
  end


  def failed_call(args)
    if args[:response]
      r = args[:response].body
      s = getMessage(r, args[:status])
      return parsefailureMessage(s, args[:response], args[:pushToHash])
    end
  end

  def successful_call(args)
    if args[:filename]
      return args[:filename]
    else
      r = args[:response].body
      if isXMLResponse(r) or r == "" 
        r = perpEmptyResponse(r)
        #parseEtag(r)
        @persistentHash[:etag] = nil
        if r == ""
          return r
        else
          if args[:pushToHash]
            return getXMLHash(r)
          else
            return r
          end
        end

      else
        tokSet1 = QueryStrToHash(r)
        if tokSet1.count > 1
          return tokSet1
        else
          return errorred_call(args)
        end
      end
    end
  end

  def isXMLResponse(r)
    return r.index('<?xml version="1.0" standalone="yes"?>') 
  end 

  def perpEmptyResponse(r)
   test = r.gsub('<?xml version="1.0" standalone="yes"?>', '')
   test = test.gsub(/(\r| |\t|\n)+/, '')
   if test == ""
     return ""
   else
     return r
   end 
   
  end 
  

  def parseEtag(r)
    if r.index('<etag>')
      extractEtag(r)
    end
  end 

  def getXMLHash(r)
    return  Hash.from_xml(r)
    
  end 

  def getMessage(r, responseStatus)
    xmldoc = Document.new(r)
    if xmldoc.root
      h = getXMLHash(r)
      status = h['status']
    if !status
    status = {}
    end 
      code    = (status['status_code'] || "")
      subcode = (status['sub_code'] || "")
      message = (status['message'] || "")
      return {:message => message.to_s, :code => code, :subcode => subcode}
    else
      return {:message => r, :status => responseStatus, :subcode => ""}
    end
  end 

  def getStatusSet()
    return { '400' => {:subcode => {'120' => { :acceptable => false },
                                    '130' => { :acceptable => true },
                                    '620' => { :acceptable => true },
                                    '650' => { :acceptable => true },
                                    '660' => { :acceptable => true },
                                    '690' => { :acceptable => true }}, 
                       :acceptable => false, 
                       :retry => ["Bad User"], :timeout => 5},
             '401' => {:acceptable => false },
             '403' => {:acceptable => false },
             '404' => {:subcode => {
                '610' => { :acceptable => true, :retry => ["Title is not in Queue"], :timeout => 0 }}, 
                      :acceptable => false },
             '412' => {:acceptable => true, :subcode => {
                '710' => {:acceptable => true,  :retry => ["Title is already in queue"], :timeout => 0 }},
                :etag => ["queue out of Date ETag mismatch"] },
             '422' => {:acceptable => true },
             '500' => {:acceptable => false,  :retry => ["Internal Error"], :timeout => 3  },
             '504' => {:acceptable => true, :retry => true  }}
  end 
  
#401  = Message:Access Token Validation Failed

#RuntimeError (Netflix API error: 
#Status Code:500
#Sub Code:
#Message:Internal Error

#RuntimeError (Netflix API error: 
#Status Code:403
#Sub Code:
#Message:Over queries per second limit


  def destroyAuthSet()
    if @persistentHash[:authing]
      @persistentHash[:user_id] = nil
      @persistentHash[:authing] = nil
    end 
  end
  
  def extractEtag(xmlData)
    parser    = CueEtagParser.new(0)
    MainNetFlixParser.new(xmlData,parser)
    setData = parser.getSetAttributes()
    @persistentHash[:etag] = setData.attributes['etag']
  end
  
  #def extractEtag(newhash)
  #  if newhash['queue']
  #    if newhash['queue']['etag']
  #        @persistentHash[:etag] = newhash['queue']['etag']
  #    end
  #  end 
  #end
  
  #def extractEtag(newXML ="")
  #  xmldoc = Document.new(newXML)
  #  newEtag =  ""
  #  xmldoc.elements.each("queue/etag"){|el|
  #   newEtag =el.text
  #  }
  #  return newEtag
  #end

  def QueryStrToHash(newQuery)
    retHash = {}

    tokSet = newQuery.split("&").each{|element|
      temp = element.split("=")
      retHash[temp[0]] = temp[1]
    }
    return retHash
  end



  def  checkUserSession()
    if  @persistentHash[:secret] and @persistentHash[:token] and @persistentHash[:user_id]
      return true
    else
      retrun false
    end
  end
  
  def debugNetflixData(method, options = {}, pushToHash = true)
    response = []
    for i in 9..9
      response << self.makeNetFlixApiCall(method, options.dclone,i)
    end
    newLine = "\n\n<br/><br/>"
    makerLine = newLine + "-------------------------------------------------------------------------------------" + newLine 
    ret = ""
    i = 0 
    response.each {|r|
      if r
        ret += i.to_s + " "+ r[0].code + newLine + r[0].body + makerLine
        i += 1
      end
    }
    return ret
  end
  
end

####### error calls

########### unconfrimed output

  #   @outputXML = makeNetFlixApiCall(:get_reviews,{ :title_refs => "http://api.netflix.com/catalog/titles/movies/60029028")

########### figured out after code changed these calls are untested. 

   #   @outputXML = makeNetFlixApiCall(:titles_states,{:title_refs => "http://api.netflix.com/catalog/titles/movies/60029028/title_states" })

   #   http://www.netflix.com/WiMovie/La_Femme_Nikita/60029028?strackid=7a6df26103b9226f_0_srl&strkid=1791650506_0_0&trkid=438381
   
   #   :title_id => "70043780"  :title_id =>"60029028"
   #   PP::pp(@XMLHash,$stderr, 50)
   #   raise "Test Output : Call OK!"
   
   #   @outputXML = makeNetFlixApiCall(:edit_instant_saved_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 1})
   #   @outputXML = makeNetFlixApiCall(:edit_disc_saved_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 2})
   #   @outputXML = makeNetFlixApiCall(:edit_instant_q, {:title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 2})
   #   @outputXML = makeNetFlixApiCall(:edit_disc_q, {:title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 1})

   #   @outputXML = makeNetFlixApiCall(:edit_instant_q, {:title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 2})
   #   finalResponse = makeNetFlixApiCall(:edit_instant_q, {:title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 2})
   #   finalResponse = makeNetFlixApiCall(:edit_disc_available_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 2 })
  
############ OK calls

   #   tmp_path =    File::join RAILS_ROOT, "tmp/cache/"
   #   index_file =  tmp_path + "index.xml"
   #   finalResponse = makeNetFlixApiCall(:get_full_index,{:writeToFile => index_file })
   #   finalResponse = makeNetFlixApiCall(:get_genres )
   #   finalResponse = makeNetFlixApiCall(:get_title,  {:title_id => "movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:search_people,  {:term => "bob"})
   #   finalResponse = makeNetFlixApiCall(:get_person,  {:person_id => "20033256"})
   #   finalResponse = makeNetFlixApiCall(:similars,  {:title_id => "movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:get_current_user)
   #   finalResponse = makeNetFlixApiCall(:get_feeds)
   #   finalResponse = makeNetFlixApiCall(:get_etag)
   #   finalResponse = makeNetFlixApiCall(:similars,{:title_id => "movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:autocomplete,{:term => "Heat"})
   #   finalResponse = makeNetFlixApiCall(:request_token)
   #   finalResponse = makeNetFlixApiCall(:access_token, {:oauth_token => params[:oauth_token],
   #                                                  :oauth_token_secret =>  session[:tokenSecret]})
   #   finalResponse = makeNetFlixApiCall(:get_queues)
   #   finalResponse = makeNetFlixApiCall(:get_instant_q)
   #   finalResponse = makeNetFlixApiCall(:get_disc_q)
   #   finalResponse = makeNetFlixApiCall(:get_instant_available_q)
   #   finalResponse = makeNetFlixApiCall(:get_disc_available_q)
   #   finalResponse = makeNetFlixApiCall(:get_instant_saved_q)
   #   finalResponse = makeNetFlixApiCall(:get_disc_saved_q)
   #   finalResponse = makeNetFlixApiCall(:edit_instant_q, {:title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:edit_disc_q, {:title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:delete_disc_available_q, {:title_id=>"60029028"})
   #   finalResponse = makeNetFlixApiCall(:delete_instant_available_q, {:title_id=>"60029028"})
   #   finalResponse = makeNetFlixApiCall(:edit_instant_available_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:edit_disc_available_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:edit_instant_saved_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:edit_disc_saved_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:get_at_home)
   #   finalResponse = makeNetFlixApiCall(:get_rental_history)
   #   finalResponse = makeNetFlixApiCall(:get_shipped)
   #   finalResponse = makeNetFlixApiCall(:get_returned)
   #   finalResponse = makeNetFlixApiCall(:get_watched)
   #   finalResponse = makeNetFlixApiCall(:get_recommendations)
   #   finalResponse = makeNetFlixApiCall(:edit_instant_available_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 1 })
   #   finalResponse = makeNetFlixApiCall(:edit_disc_available_q, { :title_ref=>"http://api.netflix.com/catalog/titles/movies/60029028", :position => 2 })
   #   finalResponse = makeNetFlixApiCall(:get_predicted_ratings, { :title_refs =>"http://api.netflix.com/catalog/titles/movies/869627"})
   #   finalResponse = makeNetFlixApiCall(:get_ratings, { :title_refs =>"http://api.netflix.com/catalog/titles/movies/869627"})
   #   finalResponse = makeNetFlixApiCall(:get_actual_ratings, { :title_refs =>"http://api.netflix.com/catalog/titles/movies/70043780"})
   #   finalResponse = makeNetFlixApiCall(:get_predicted_ratings,  { :title_refs=>"http://api.netflix.com/catalog/titles/movies/60029028"})
   #   finalResponse = makeNetFlixApiCall(:update_rating, {:rating => 5, :rating_id =>"60029028"})
   #   finalResponse = makeNetFlixApiCall(:create_rating, {:rating => 2, :title_ref   =>"http://api.netflix.com/catalog/titles/movies/869627" })

