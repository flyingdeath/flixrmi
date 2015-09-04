
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#

  require 'rubygems'
  require 'libxml'
  include LibXML
  
  class MainNetFlixParser
    attr_accessor :parserOBj
    def initialize(xmlData, parser)
      if xmlData != ""
        @parserOBj = XML::SaxParser.string(xmlData)
        @parserOBj.callbacks = NetFlixXMLParser.new(parser)
        @parserOBj.parse
      end
    end
  end
  
  class IndexFlieNetFlixParser
    attr_accessor :parserOBj
    def initialize(fileName, parser)
      @parserOBj = XML::SaxParser.file(fileName)
      @parserOBj.callbacks = NetFlixXMLParser.new(parser)
      @parserOBj.parse
    end
  end

  class NetFlixXMLParser
  
    attr_accessor :currentCallBack

    include XML::SaxParser::Callbacks
    
    def initialize(parser)
      @currentCallBack = parser
    end 
    
    def on_start_element_ns(name, attributes, prefix, uri, namespaces) 
      @currentCallBack.tag_start(name, attributes)
    end

    def on_end_element_ns(name, prefix, uri)
      @currentCallBack.tag_end(name)
    end

    def on_characters(chars) 
      @currentCallBack.text(chars)
    end

    def on_cdata_block(cdata)
      if @currentCallBack.respond_to?('cdata')
        @currentCallBack.cdata(cdata)
      end 
    end
    
  end
    
  
#----------------------------------------------------------------------------------------------#
 
  class ActiveDummy 
    attr_accessor :attributes, :index
    def initialize()
      @attributes = {}
    end
      
    def self.createMethods(list)
      list.each{|key, value|
        if key
          define_method key.to_sym do
             return @attributes[key]
          end
        end
      }
    end 
    
  end

  
  class ActiveDummySet
    attr_accessor :details, :set
    def initialize()
    end  
  end 
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#

  class NetFlixParser
  
#----------------------------------------------------------------------------------------------#  
    attr_accessor :currentSet, :currentKey, :currentItem, :setAttributes, :setAttrFlag,
                  :forigenKeyName, :itemTagName, :itor

#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
    
    def initialize(x)
      @setAttrFlag   = false
      @itor          = 0
      @setAttributes = ActiveDummy.new 
      resetClassVars()
    end
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
    
    def itemTags(key)
      tagData = { :ratings        => ",ratings_item",
                  :similars       => ",similars_item",
                  :title          => ",catalog_title,",
                  :rental_history => ",rental_history_item",
                  :autocomplete   => ',autocomplete_item',
                  :at_home        => ',at_home_item',
                  :filmography    => ",filmography_item",
                  :queue          => ",queue_item",
                  :person         => ",person",
                  :synopsis       => ",synopsis",
                  :award          => ",award_nominee,award_winning",
                  :availability   => ",availability",
                  :language_audio => ",language_audio_format",
                  :screen_format  => ",screen_format",
                  :resource       => ",resource",
                  :status         => ",status",
                  :user           => ",user",
                  :recommendation => ',recommendation,',
                  :title_state    => ',title_state',
                  :review         => ',review'}
  
      return tagData[key]
    end 
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#

    def resetClassVars()
      @currentKey  = :none
      @currentItem = ActiveDummy.new
    end

    
    def getParsedSet()
      return @currentSet
    end
    
    def getParsedSingle()
      return @currentSet[0]
    end
    
    def getSetAttributes()
      return @setAttributes
    end
    
    def getParsedData()
      obj         = ActiveDummySet.new
      obj.set     = @currentSet
      obj.details = @setAttributes
      return obj
    end
    
    def getParsedHashSet()
      return {:set => @currentSet, :setData => @setAttributes }
    end
    
    def sortParsedSet()
      return @currentSet.sort {|a,b|
          a[1].index <=> b[1].index
        }
    end
    
    
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#

    def tag_end_normal(elementName)
      if @itemTagName
        if @itemTagName.index("," + elementName) 
          #ActiveDummy.createMethods(@currentItem.attributes)
          if @forigenKeyName
            if @currentItem.index
              @currentItem.index = @itor
              @itor += 1
            end 
            @currentSet[@currentItem.attributes[@forigenKeyName]] = @currentItem.clone()
          else
            @currentSet << @currentItem.dclone()
          end
          resetClassVars()
        end
      end
      @currentKey  = :none
    end
    
    
    def text_normal(text)
      begin
        if  @currentKey  != :none
          if @setAttrFlag
            @setAttributes.attributes[@currentKey] ||= ""
            @setAttributes.attributes[@currentKey] << text
          else
            @currentItem.attributes[@currentKey] ||= ""
            @currentItem.attributes[@currentKey] << text
          end
          # @currentKey     = :none
        end
      rescue StandardError => error
             raise Time.now.to_s(:db) + " \n" +
                    text.to_s + " \n" +
                    @currentKey.to_s + " \n" +
                    error.message + "\n" +
                    error.backtrace.join("\n") + "\n\n"
      end
    end
    
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
    
    def tag_start_text_hook_item(elementName,list)
      if list.index(elementName)
        @currentKey  = elementName
      end
    end 
    
    def tag_start_text_hook_item_s(elementName, list, key)
      if list.index(elementName)
        @currentKey  = key
      end
    end 
    
    def tag_start_text_hook_global(elementName,list)
      if list.index(elementName)
        @setAttrFlag = true
        @currentKey  = elementName
      end
      if @currentSet.empty? and @itemTagName.index("," + elementName)
        @setAttrFlag = false
      end 
    end 
#----------------------------------------------------------------------------------------------#
    
    def tag_start_att_values(elementName, attributes, data, tagName)
      if elementName == tagName
        data.each{|key,value|
          if attributes[value]
            @currentItem.attributes[key] = attributes[value]
          end 
        }
      end
    end
    def tag_start_att_values_a(elementName, attributes, data, tagName)
      if elementName == tagName
        data.each{|value|
          if attributes[value]
            @currentItem.attributes[value] = attributes[value]
          end 
        }
      end
    end
    
    def tag_start_att_taglist(elementName, attributes, data)
      if data.keys.index(elementName)
        data.each{|key,value|
          if attributes[value]
            @currentItem.attributes[value] = attributes[value]
          end 
        }
      end
    end
#----------------------------------------------------------------------------------------------#
    
    def tag_start_categories(elementName, attributes, category_data)
      begin
        if elementName == 'category'
          scheme =  category_data[attributes['scheme']]
          if @currentItem
            unless @currentItem.attributes[scheme]
             @currentItem.attributes[scheme] = []
            end
            @currentItem.attributes[scheme] << attributes['label']
          end
        end
      rescue StandardError => error
             raise Time.now.to_s(:db) + " \n" +
                    scheme.to_s + " \n" +
                    attributes['label'].to_s + " \n" +
                    error.message + "\n" +
                    error.backtrace.join("\n") + "\n\n"
      end
    end 
    
    def tag_start_links(elementName, attributes, data)
      if elementName == 'link'
        if data[attributes['rel']]
          @currentItem.attributes[data[attributes['rel']]] = attributes['href']
        end 
      end
    end
    
    def tag_start_link_title(elementName, attributes, schemeValue,data)
      if elementName == 'link'
        if schemeValue == attributes['rel']
          if data[attributes['title']]
            @currentItem.attributes[data[attributes['title']]] = attributes['title']
          end 
        end
      end 
    end
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
    def tag_start_user(elementName, attributes)
      list = [ 'user_id', 'first_name', 'last_name', 'nickname', 'can_instant_watch']
      tag_start_text_hook_item(elementName,list)
    end
    
    
    def tag_start_person(elementName, attributes)
      list = [ 'name', 'bio']
      tag_start_text_hook_item(elementName,list)
    end
    
    def tag_start_list_data(elementName, attributes)
      list = [ 'number_of_results', 'start_index', 'results_per_page', 'url_template']
      tag_start_text_hook_global(elementName,list)
    end 
    
    def tag_start_history(elementName, attributes)
      list = [ 'shipped_date','watched_date','returned_date', 'updated','viewed_time']
      tag_start_text_hook_global(elementName,list)
    end
    
    def tag_start_queue_etag(elementName, attributes)
      list = [ "etag"]
      tag_start_text_hook_global(elementName,list)
    end 
    
    def tag_start_status(elementName, attributes)
      list = ['message', 'status_code', 'sub_code']
      tag_start_text_hook_global(elementName,list)
    end 
    
    
    def tag_start_queue(elementName, attributes)
      list = [ 'position', 'updated']
      tag_start_text_hook_item(elementName,list)
    end
    
    def tag_start_synopsis(elementName, attributes)
      list = [ 'synopsis']
      tag_start_text_hook_item(elementName,list)
    end 
    
    def tag_start_title_data(elementName, attributes)
      list = [ 'runtime', 'release_year']
      tag_start_text_hook_item(elementName,list)
    end 
    
    def tag_start_id(elementName, attributes)
      list = ['id']
      key = 'ext_id'
      tag_start_text_hook_item_s(elementName, list, key)
    end 
    
    def tag_start_id_user(elementName, attributes)
      list = ['id']
      key = 'user_id'
      tag_start_text_hook_item_s(elementName, list, key)
    end 
    
    def tag_start_ids(elementName, attributes)
      list = ['id']
      tag_start_text_hook_item(elementName,list)
    end 
    
    def tag_start_rating(elementName, attributes)
      list = [ 'runtime', 'user_rating', 'average_rating', 'predicted_rating']
      tag_start_text_hook_item(elementName,list)
    end       
    
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
    
    def tag_start_title_normal(elementName, attributes)
      name_list = { "titleShort" => 'short',  'title' =>'regular'}
      tag_start_att_values(elementName, attributes, name_list, "title")
    end 
    
    
    def tag_start_BoxArt_normal(elementName, attributes)
      art_data =  {'BoxArtSmall'  => 'small',
                   'BoxArtMedium' => 'medium',
                   'BoxArtLarge'  => 'large'}
      tag_start_att_values(elementName, attributes, art_data, 'box_art')
    end 
    
    def tag_start_availability(elementName, attributes)
      avail_data = ['available_from','available_until']
      tag_start_att_values_a(elementName, attributes, avail_data, 'availability')
    end 
    
    def tag_start_awards(elementName, attributes)
      list = {'award_nominee' => 'year','award_winner' => 'year'}
      tag_start_att_taglist(elementName, attributes, list)
    end 
    
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
    
    def tag_start_category_awards(elementName, attributes)
      category_data = 
           {'http://api-public.netflix.com/categories/award_types/afi' =>                          'afi',
            'http://api-public.netflix.com/categories/award_types/academy_awards' =>               'academy_awards',
            'http://api-public.netflix.com/categories/award_types/sundance_film_festival' =>       'sundance_film_festival',
            'http://api-public.netflix.com/categories/award_types/independent_spirit_awards' =>    'independent_spirit_awards',
            'http://api-public.netflix.com/categories/award_types/razzie' =>                       'razzie',
            'http://api-public.netflix.com/categories/award_types/time' =>                         'time',
            'http://api-public.netflix.com/categories/award_types/baftas' =>                       'baftas',
            'http://api-public.netflix.com/categories/award_types/golden_globe_awards' =>          'golden_globe_awards'}
      tag_start_categories(elementName, attributes, category_data)
    end
    
    
    def tag_start_category_normal(elementName, attributes)
      category_data = 
          {'http://api-public.netflix.com/categories/mpaa_ratings' => 'mpaa_ratings',
           'http://api-public.netflix.com/categories/genres'       => 'genres'}
      tag_start_categories(elementName, attributes, category_data)
    end
    
    def tag_start_category_queue(elementName, attributes)
      category_data = 
          {'http://api-public.netflix.com/categories/queue_availability' => 'queue_availability',
           'http://api-public.netflix.com/categories/title_formats'      => 'title_formats'}
      tag_start_categories(elementName, attributes, category_data)
    end
    
    def tag_start_category_title_states(elementName, attributes)
      category_data = 
          {'http://api-public.netflix.com/categories/title_formats' => 'title_formats',
           'http://api-public.netflix.com/categories/title_states'  => 'title_states'}
      tag_start_categories(elementName, attributes, category_data)
    end
    
    def tag_start_category_user(elementName, attributes)
      category_data = 
          {'http://api-public.netflix.com/categories/title_formats'  => 'title_formats',
           'http://api-public.netflix.com/categories/maturity_level' => 'maturity_level'}
      tag_start_categories(elementName, attributes, category_data)
    end
    
    def tag_start_category_screen_formats(elementName, attributes)
      category_data = 
          {'http://api-public.netflix.com/categories/screen_formats' => 'screen_formats',
           'http://api-public.netflix.com/categories/title_formats'  => 'title_formats'}
      tag_start_categories(elementName, attributes, category_data)
    end
    
    def tag_start_category_languages_and_audio(elementName, attributes)
        category_data = 
            {'http://api-public.netflix.com/categories/audio'         => 'audio',
             'http://api-public.netflix.com/categories/languages'     => 'languages',
             'http://api-public.netflix.com/categories/title_formats' => 'title_formats'}
      tag_start_categories(elementName, attributes, category_data)
    end
    
    def tag_start_category_delivery_formats(elementName, attributes)
      category_data = 
          {'http://api-public.netflix.com/categories/title_formats' => 'title_formats'}
      tag_start_categories(elementName, attributes, category_data)
    end

#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#

    def tag_start_link_normal(elementName, attributes)
      api_links_data = {'http://schemas.netflix.com/catalog/title' => 'ext_id',
                        'alternate'                                => 'alternate_link'}
      titleName = 'http://schemas.netflix.com/catalog/title'
      tag_start_link_title(elementName, attributes, titleName,api_links_data)
      tag_start_links(elementName, attributes, api_links_data)
    end
    
    def tag_start_link_alternate(elementName, attributes)
      api_links_data = {'alternate'                                => 'alternate_link'}
      titleName = 'http://schemas.netflix.com/catalog/title'
      tag_start_links(elementName, attributes, api_links_data)
    end
    
    def tag_start_links_full(elementName, attributes)
       tag_start_link_normal(elementName, attributes)
       tag_start_api_links(elementName, attributes)
    end 
    
    def tag_start_api_links(elementName, attributes)
        api_links_data = 
        {'http://schemas.netflix.com/catalog/titles/synopsis'            => 'synopsis_link',
         'http://schemas.netflix.com/catalog/people.cast'                => 'cast_link',
         'http://schemas.netflix.com/catalog/people.directors'           => 'directors_link',
         'http://schemas.netflix.com/catalog/titles/screen_formats'      => 'screen_formats_link',
         'http://schemas.netflix.com/catalog/titles/languages_and_audio' => 'languages_and_audio_link',
         'http://schemas.netflix.com/catalog/titles.similars'            => 'similars_link',
         'http://schemas.netflix.com/catalog/titles/index'               => 'index_link',
         'http://schemas.netflix.com/catalog/titles/autocomplete'        => 'autocomplete_link',
         'http://schemas.netflix.com/catalog/titles.filmography'         => 'filmography'}
      tag_start_links(elementName, attributes, api_links_data)
    end
    
    def tag_start_user_links(elementName, attributes)
      api_links_data = 
        {'http://schemas.netflix.com/queues'           => 'queues_link',
         'http://schemas.netflix.com/rental_history'   => 'rental history_link',
         'http://schemas.netflix.com/recommendations'  => 'recommendations_link',
         'http://schemas.netflix.com/title_states'     => 'title states_link',
         'http://schemas.netflix.com/ratings'          => 'ratings_link',
         'http://schemas.netflix.com/reviews'          => 'reviews_link',
         'http://schemas.netflix.com/at_home'          => 'at home_link',
         'http://schemas.netflix.com/feeds'            => 'feeds'}
      tag_start_links(elementName, attributes, api_links_data)
    end
    
    def tag_start_CueResource_links(elementName, attributes)
      api_links_data = 
        {'http://schemas.netflix.com/queues.disc'      => 'queues_disc',
         'http://schemas.netflix.com/queues.instant'   => 'queues_instant'}
      tag_start_links(elementName, attributes, api_links_data)
    end
    
    def tag_start_user_feed_links(elementName, attributes)
      api_links_data = 
        {'http://schemas.netflix.com/feed.queues.disc'               => 'feed_queues_disc_link',
         'http://schemas.netflix.com/feed.queues.disc.recent'        => 'feed_queues_disc_recent_link',
         'http://schemas.netflix.com/feed.queues.instant'            => 'feed_queues_instant_link',
         'http://schemas.netflix.com/feed.queues.instant.recent'     => 'feed_queues_instant_recent_link',
         'http://schemas.netflix.com/feed.rental_history'            => 'feed_rental_history_link',
         'http://schemas.netflix.com/feed.rental_history.shipped'    => 'feed_rental_history_shipped_link',
         'http://schemas.netflix.com/feed.rental_history.watched'    => 'feed_rental_history_watched_link',
         'http://schemas.netflix.com/feed.rental_history.returned'   => 'feed_rental_history_returned_link',
         'http://schemas.netflix.com/feed.at_home'                   => 'feed_at_home_link',
         'http://schemas.netflix.com/feed.reviews'                   => 'feed_reviews_link',
         'http://schemas.netflix.com/feed.recommendations'           => 'feed_recommendations_link',
         'http://schemas.netflix.com/feed.ratings'                   => 'feed_ratings_link'}
      tag_start_links(elementName, attributes, api_links_data)
    end
    
#----------------------------------------------------------------------------------------------#

  end
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------#
  
  
