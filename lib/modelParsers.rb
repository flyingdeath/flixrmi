
   require 'logger'
   require "netflixParser"
   require "htmlentities"
  #----------------------------------------------------------------------------------------------#
  #----------------------------------------------------------------------------------------------#
  #----------------------------------------------------------------------------------------------#
  
    class UserfeedsParser < NetFlixParser
    
      def initialize(x)
        super  
        @currentSet     = []
        @itemTagName = itemTags(:resource) 
      end
      
      def tag_start(elementName, attributes)
        tag_start_user_feed_links(elementName, attributes)
      end
      
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
      
    end
  #----------------------------------------------------------------------------------------------#
    
    class UserParser < NetFlixParser
    
      def initialize(x)
        super  
        @currentSet     = []
        @itemTagName = itemTags(:user) 
      end
      
      def tag_start(elementName, attributes)
        tag_start_user(elementName, attributes)
        tag_start_category_user(elementName, attributes)
      end
      
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
      
    end
    
    class UserReviewsParser < NetFlixParser
    
      def initialize(x)
        super  
        @currentSet     = {}
        @forigenKeyName = 'ext_id'
        @itemTagName = itemTags(:review ) 
      end
      
      def tag_start(elementName, attributes)
        tag_start_list_data(elementName, attributes)
        tag_start_user(elementName, attributes)
        tag_start_category_user(elementName, attributes)
      end
      
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
      
    end
   
  #----------------------------------------------------------------------------------------------#
    class  StatusParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:status) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_status(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
  
    class  RatingStatusParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:status) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_status(elementName, attributes)
        tag_start_queue_etag(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
  #----------------------------------------------------------------------------------------------#
    
    class RatingListParser < NetFlixParser
  
      def initialize(itemTag)
        super
        @currentSet     = {}
        @forigenKeyName = 'ext_id'
        @itemTagName = itemTags(itemTag) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_list_data(elementName, attributes)
        tag_start_id_user(elementName, attributes)
        #tag_start_title_normal(elementName, attributes)
        tag_start_BoxArt_normal(elementName, attributes)
        tag_start_rating(elementName, attributes)
        tag_start_link_normal(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
    
    class TitleStatesParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet  = {}
        @forigenKeyName = 'ext_id'
        @itemTagName = itemTags(:title_state) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_link_normal(elementName, attributes)
        tag_start_category_title_states(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
    
  #----------------------------------------------------------------------------------------------#

    class CueResourceParser < NetFlixParser
    
      def initialize(x)
        super  
        @currentSet     = []
        @itemTagName = itemTags(:resource) 
      end
      
      def tag_start(elementName, attributes)
        tag_start_CueResource_links(elementName, attributes)
      end
      
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
      
    end
  #----------------------------------------------------------------------------------------------#
    
    class  CueStatusParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:status) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_status(elementName, attributes)
      end 
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
  #----------------------------------------------------------------------------------------------#

    class  CueEtagParser < NetFlixParser
  
      def initialize(itemTag)
        super
        @currentSet     = []
        @itemTagName = itemTags(:queue) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_queue_etag(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end   
  #----------------------------------------------------------------------------------------------#
    class  CueListParser < NetFlixParser
  
      def initialize(itemTag)
        super
        @currentSet     = []
        @itemTagName = itemTags(:queue) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_status(elementName, attributes)
        tag_start_queue_etag(elementName, attributes)
        tag_start_list_data(elementName, attributes)
        tag_start_ids(elementName, attributes)
        tag_start_title_normal(elementName, attributes)
        tag_start_queue(elementName, attributes)
        tag_start_link_normal(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
   
     
  #----------------------------------------------------------------------------------------------#
  
    class PersonListParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:person) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_list_data(elementName, attributes)
        tag_start_id(elementName, attributes)
        tag_start_person(elementName, attributes)
        tag_start_link_alternate(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
      
      def cdata(cdata)
        text_normal(cdata)
      end
  
  
    end
  
  #----------------------------------------------------------------------------------------------#
  
    class TitlesAutoListParser < NetFlixParser
  
      def initialize(itemTag)
        super
        @currentSet  = []
        @itemTagName = itemTags(:autocomplete)
      end
      
      def getParsedSetJson()
        i = 0 
        l = []
        dcoder = HTMLEntities.new

        @currentSet.each {|item|
          l << {:Title => dcoder.decode(item.attributes['titleShort'])}
        }
        return ({:ResultSet => {:Result => l}}).to_json.html_safe
      end
      
      def getStringSet()
        i = 0 
        ret = ""
        @@list.each {|item|
          i += 1
          ret << item +"\t"+ i.to_s.html_safe + "^"
        }
        return ret
      end
  
      def tag_start(elementName, attributes)
        tag_start_title_normal(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
    
        
    class TitleUserIndexListParser < NetFlixParser
    
      def initialize(itemTag)
        super
        @currentSet  = []
        @itemTagName = itemTags(itemTag) 
      end
    
      def tag_start(elementName, attributes)
        tag_start_list_data(elementName, attributes)
        tag_start_ids(elementName, attributes)
        tag_start_title_normal(elementName, attributes)
        tag_start_link_normal(elementName, attributes)
      end
    
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
    
      def text(text)
        text_normal(text)
      end
    
    end
    
    class TitleListParser < NetFlixParser
  
      def initialize(itemTag)
        super
        @currentSet  = []
        @itemTagName = itemTags(itemTag) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_list_data(elementName, attributes)
        tag_start_id(elementName, attributes)
        tag_start_title_normal(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
    
    
  
  #----------------------------------------------------------------------------------------------#
    
    class TitleParser < NetFlixParser
    
      def initialize(x)
        super  
        @currentSet     = []
        @itemTagName = itemTags(:title) 
      end
      
      def tag_start(elementName, attributes)
        tag_start_id(elementName, attributes)
        tag_start_title_normal(elementName, attributes)
        tag_start_rating(elementName, attributes)
        tag_start_BoxArt_normal(elementName, attributes)
        tag_start_category_normal(elementName, attributes)
        tag_start_title_data(elementName, attributes)
        tag_start_link_normal(elementName, attributes)
      end
      
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
      
    end
    
  #----------------------------------------------------------------------------------------------#
  
    class AvailabilityParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:availability) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_availability(elementName, attributes)
        tag_start_category_delivery_formats(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
    
  #----------------------------------------------------------------------------------------------#
  
    class AwardParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:award) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_category_awards(elementName, attributes)
        tag_start_awards(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
  
  
  #----------------------------------------------------------------------------------------------#
  
    class ScreenFormatParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:screen_format) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_category_screen_formats(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
  #----------------------------------------------------------------------------------------------#
  
    class LanguageAudioParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:language_audio) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_category_languages_and_audio(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
        text_normal(text)
      end
  
    end
    
    class SynopsisParser < NetFlixParser
  
      def initialize(x)
        super
        @currentSet     = []
        @itemTagName = itemTags(:synopsis) 
      end
  
      def tag_start(elementName, attributes)
        tag_start_synopsis(elementName, attributes)
      end
  
      def tag_end(elementName)
        tag_end_normal(elementName)
      end
  
      def text(text)
      end
      
      def cdata(cdata)
        text_normal(cdata)
      end
  
    end
    
    class IndexParser
    
      @@currentKey = ""
      @@currentTitleSet = {}
      @@currentTitle = {}
      @@genres = {}
      @@formats = {}
      @@max = 0
      @@progress = 0
      @@startTime = Time.now()
      @@intervalTime = Time.now()
      @@intervalProgress = 0
  
      def pushDataToHash(modelObj, property)
        retHash = {}
        dataSet = modelObj.find(:all)
        itor  = 0
        dataSet.each {|d| 
          if d.attributes[property]
             retHash[d.attributes[property]] = d
          end
        }
        return retHash
      end
  
      def pushIdsToHash(modelObj, property)
        retHash = {}
        dataSet = modelObj.find(:all)
        itor  = 0
        dataSet.each {|d| 
          if d.attributes[property]
             retHash[d.attributes[property]] = d.attributes['id']
          end
        }
        return retHash
      end
  
  
      def updateXmlSet(newXMlset,xmlKey,modelObj)
        newXMlset.each {|element|
          if element[xmlKey]
             findAndUpdate(modelObj,{:name => element[xmlKey]}, {:name => element[xmlKey]})
          end
        }
      end 
  
    #-------------------------------------------------------------------------------------------------#
    #-------------------------------------------------------------------------------------------------#  
       def getTitleType()
            ret = ""
            ext_id = @@currentTitle[:ext_id]
            
            if ext_id.index("http://api-public.netflix.com/catalog/titles/movies/") 
              ret = "movie"
            elsif ext_id.index("http://api-public.netflix.com/catalog/titles/discs/")
              ret = "discs"
            elsif ext_id.index("/seasons/") 
              ret = "seasons"
            elsif ext_id.index("http://api-public.netflix.com/catalog/titles/series/")
              ret = "series"
            elsif ext_id.index("http://api-public.netflix.com/catalog/titles/programs") 
              ret = "programs"
            end 
            
            return ret
          end
          
          
      def createTitle(currentTitle, currentTitleSet)
            
        currentTitle[:titleType] = getTitleType()
        title = Ltitle.new(currentTitle)
        currentTitleSet[:actors].each {|actor|
          findAndUpdate(Lactor, actor, {:ext_id => actor[:ext_id] }, true, title)
        }
        currentTitleSet[:directors].each {|director|
          findAndUpdate(Ldirector, director, {:ext_id => director[:ext_id]}, true, title)
        }
        currentTitleSet[:upcs].each {|upc|
          addNewRef(Lupc, upc, title)
        }
        currentTitleSet[:formats].each {|format|
          addRef(Lformat, @@formats, format, :name, title)
        }
        currentTitleSet[:genres].each {|genre|
          addRef(Lgenre, @@genres, genre,:name, title)
        }
        return title.save
      end
    
    #-------------------------------------------------------------------------------------------------#  
      def updateTitle(title, currentTitleSet, currentTitle)
        currentTitleSet[:actors].each {|actor|
          findAndUpdate(Lactor, actor, {:ext_id => actor[:ext_id] }, false)
        }
        currentTitleSet[:directors].each {|director|
          findAndUpdate(Ldirector, director, {:ext_id => director[:ext_id]}, false)
        }
        currentTitleSet[:upcs].each {|upc|
          findAndUpdate(Lupc, upc, {:number => upc[:number]}, false)
        }
        title.lgenres.clear
        updateFormatsOnly(title)
        currentTitleSet[:genres].each {|genre|
          addRef(Lgenre, @@genres, genre,:name, title)
        }
        return title.update_attributes(currentTitle)
      end
     
    #-------------------------------------------------------------------------------------------------# 
      def updateFormatsOnly(title)
        title.lformats.clear
        @@currentTitleSet[:formats].each {|format|
          addRef(Lformat, @@formats, format, :name, title)
          iFormat = Fconnector.find(:first, :conditions =>
                                     ["ltitles_id = ? AND lformats_id = ?", 
                                      title.id, @@formats[format[:name]].id ])
          format[:availability_int] = format[:availability].to_i
          begin
            if format[:availability]
              format[:availability]   = Time.parse("January 1, 1970 00:00:00") +
                                            format[:availability_int].to_i
            end
            iFormat.update_attribute(:availability, format[:availability])
            iFormat.update_attribute(:availability_int, format[:availability_int])
          rescue
          end
          
        }
      end 
  
    #-------------------------------------------------------------------------------------------------#    
     def findAndUpdateTitle(currentTitle, currentTitleSet)
       if currentTitle
         founditems = Ltitle.find(:all, :conditions =>  {:ext_id => currentTitle[:ext_id] } )
        # founditems  = @@titles[currentTitle[:ext_id]]
         if founditems.length > 0
           #calculateProgress()
           title = founditems[0]
           if title
             if title['updated'] != currentTitle[:updated]
               begin
                  updated  = (Time.parse("January 1, 1970 00:00:00") +  
                                  currentTitle[:updated].to_i).to_s 
               rescue
                 updated =  currentTitle[:updated]
               end 
               Logger.new(STDOUT).info 'Updating Title : "' + 
                                          currentTitle[:title] + '",'+
                                          ' (' + updated+ '), ' +  Time.now().to_s
               updateTitle(title, currentTitleSet, currentTitle)
             end
           end
         else
             Logger.new(STDOUT).info 'Creating new Title: "'+ 
                                          currentTitle[:title] +'", ' + 
                                          Time.now().to_s
             createTitle(currentTitle, currentTitleSet)
         end
       end 
     end 
  
    #-------------------------------------------------------------------------------------------------#    
      def findAndUpdate(modelObj, dataSet, conditions, updateNow = true, parnetObj = nil)
        founditems = modelObj.find(:all, :conditions => conditions)
        if founditems.length > 0 
           newObject = founditems[0]
           if updateNow
             isUpdated = newObject.update_attributes(dataSet) 
             appendRef(newObject, parnetObj)
           else
             isUpdated = false
           end 
           return [isUpdated, newObject, true]
        else
           ret = addNewRef(modelObj, dataSet, parnetObj) 
           ret << false
           return ret
        end
      end
    #-------------------------------------------------------------------------------------------------#
      
      def addNewRef(modelObj, dataSet, parnetObj = nil)
        newObject = modelObj.new(dataSet) 
          appendRef(newObject, parnetObj)
        return [newObject.save,newObject]
      end
      
      def addRef(modelObj, hashList, dataset,key, parnetObj)
        if hashList[dataset[key]] 
          appendRef(hashList[dataset[key]], parnetObj)
        else
          addNewRef(modelObj, dataset, parnetObj)
        end
      end
    
    #-------------------------------------------------------------------------------------------------#  
      def appendRef(newObject, parnetObj)
        if parnetObj
          case newObject.class.to_s
            when 'Lupc'
              if !(parnetObj.lupcs.exists?(:number => newObject.attributes['number']))
                parnetObj.lupcs << newObject
              end 
            when 'Lformat'
              parnetObj.lformats << newObject
            when 'Lgenre'
              parnetObj.lgenres << newObject
            when 'Ldirector'
              parnetObj.ldirectors << newObject
            when 'Lactor'
              parnetObj.lactors << newObject
            else
          end
        end
      end 
  
      
    #-------------------------------------------------------------------------------------------------#
    #-------------------------------------------------------------------------------------------------#    
      def initialize(max, genres = {},formats = {})
        @@max = max
        updateGlobalVars(genres,formats)
        resetClassVars()
      end 
      
      def updateGlobalVars(genres = {},formats = {})
        @@genres = genres
        @@formats = formats
      end 
      
      def resetClassVars()
        @@currentKey                  = :none
        @@currentAvailability         = ""
        @@currentTitleSet             = {}
        @@currentTitle                = {}
        @@currentTitleSet[:upcs]      = []
        @@currentTitleSet[:actors]    = []
        @@currentTitleSet[:directors] = []
        @@currentTitleSet[:genres]    = []
        @@currentTitleSet[:formats]   = []
      end
      
      def calculateProgress()
        @@progress += 1
        @@intervalProgress +=1
        rightNow = Time.now()
        if rightNow > (@@intervalTime + 60)
          current = ((@@progress.to_f/@@max)*100).round(3)
          secondsDif = rightNow - @@intervalTime
          osecondsDif = rightNow - @@startTime
          speed = (@@intervalProgress/secondsDif)
          ospeed = (@@progress/osecondsDif)
          eta   = (rightNow + ((@@max - @@progress) / ospeed))
          ieta  = (rightNow + ((@@max - @@intervalProgress) / speed))
          @@intervalTime = rightNow
          @@intervalProgress = 0
          Logger.new(STDOUT).info '#-------------------------------------------------------------------------------------------------#' 
          Logger.new(STDOUT).info 'Progress so far is: '        + (current).to_s + '% ('+@@progress.to_s+'/'+@@max.to_s+')'
          Logger.new(STDOUT).info 'It is now '                  + rightNow.to_s(:short) 
          Logger.new(STDOUT).info 'The interval speed/eta is: ' + speed.round(3).to_s  + " / " + ieta.to_s(:short)
          Logger.new(STDOUT).info 'The overall  speed/eta is: ' + ospeed.round(3).to_s + " / " + eta.to_s(:short)
          Logger.new(STDOUT).info '#-------------------------------------------------------------------------------------------------#' 
        end 
      end
      
    #-------------------------------------------------------------------------------------------------#
    #-------------------------------------------------------------------------------------------------#
    
      def tag_end(elementName)   
        if elementName == 'title_index_item'
          threads = []
          threads << Thread.new(){
            findAndUpdateTitle(@@currentTitle.clone,@@currentTitleSet.clone)
          }
          calculateProgress()
          threads.each{|t|
            t.join
          }
          resetClassVars()
        end
      end 
  
      def text(text)
        case @@currentKey 
          when :none
          when :upcs
            @@currentTitleSet[@@currentKey] << {:number => text}
          else
             @@currentTitle[@@currentKey] = text
        end 
        @@currentKey  =  :none
      end 
      
      def tag_start(elementName, attributes)
        dcoder = HTMLEntities.new

        case elementName
          when 'title'
            @@currentKey = :title
          when 'category'
            if attributes['status']
              if (attributes['status'] != 'deprecated')
                
              end
            else
              if attributes['scheme'] == 'http://api-public.netflix.com/categories/genres'
                currentKey = :genres
                currentdata = {:name => dcoder.decode(attributes['term']) }
              elsif attributes['scheme'] == 'http://api-public.netflix.com/categories/title_formats' 
                currentKey = :formats
                currentdata = {:name => dcoder.decode(attributes['term']),
                               :availability => @@currentAvailability}
              end 
              @@currentTitleSet[currentKey] << currentdata
            end 
          when 'link'
            if attributes['rel'] != "alternate"
              if attributes['rel'] == 'http://schemas.netflix.com/catalog/person.actor'
                currentKey = :actors
              else
                currentKey = :directors
              end 
              @@currentTitleSet[currentKey] << {:ext_id => attributes['href'], 
                                             :name   => attributes['title']}
            else
               @@currentTitle[:netflixLink] = attributes['href']
            end 
          when 'release_year'
            @@currentKey = :release_year
          when 'id'
            if !attributes["rel"]
              @@currentKey = :ext_id
            else
              @@currentKey = :upcs
            end 
          when 'availability'
            @@currentAvailability = attributes['available_from']
          when 'updated'
            @@currentKey = :updated
  
         end
       end
    end
    
    
  #----------------------------------------------------------------------------------------------#
  #----------------------------------------------------------------------------------------------#
  #----------------------------------------------------------------------------------------------#
  #----------------------------------------------------------------------------------------------#
  #----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
