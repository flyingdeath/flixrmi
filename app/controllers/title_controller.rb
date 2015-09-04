
require "netflixTitleControl.rb"
#-------------------------------------------------------------------------------------------------#  

class TitleController < ApplicationController 

include NetflixTitleControl
#-------------------------------------------------------------------------------------------------#  
   def getNew()
     sessionVar = getListSessionVariable('listNew')
     changeListPostion('listNew', true, sessionVar[:inc])
     getNew_p(sessionVar[:index],  sessionVar[:inc])
     renderTitles(session[:categoryViewType], false)
   end
#-------------------------------------------------------------------------------------------------#  
      
   def getNew_pagination()
     sessionVar = getListSessionVariable('listNew')
     getNew_p(sessionVar[:index], sessionVar[:inc], true)
     renderTitles(session[:categoryViewType], false, "Loop")
   end
#-------------------------------------------------------------------------------------------------#  
   
   def getNew_p(start = 0, max = 100, requestpage = false)
     newFliterValues= {:AtMost => 'Today', :AtLeast => 'Minus 1 Month'}
   
     newFliter = {'availability' => getAvailabilityConditions(newFliterValues)}
    
     sessionVar = getListSessionVariable('listNew')
     sortSessionVar = getListSessionVariable('listNew', 'sort')
    # setFilters(sessionVar)
     
     fliters   = getSqlFilters(sessionVar)
     fliters   = newFliter.merge(fliters)
     rFlt      = fliters.merge(getRatingFilterType(sessionVar[:filterSet]['rating']))
     sortOrder = getSortOrder(sortSessionVar)
     types     = getQueryTypes(rFlt, sortOrder)
     @titles   = queryDB(fliters, sortOrder, types[:queryCombos], types[:paginate], start, max)
   
     if types[:paginate]
      titlesAll = queryDB(fliters, sortOrder, types[:queryCombos], false, start, max)
      titlesAll_length =  titlesAll.length
      titlesAll = nil
     end 
     
     @ratings = getTitleRatings_cached(@titles, session, types[:paginate], requestpage, 'listNew')
     
     @titles    = getTitlesfilterByRating(@titles, @ratings, sessionVar[:filterSet]['rating'])
     
     @titles   = getTitlesOrderByRating(@titles, @ratings, sortSessionVar)
   
     @states   = getTitleStates(@titles,session)
     
     if !types[:paginate]
     titlesAll_length = @titles.length
     end 
     
     @titlesData = ActiveDummySet.new
     @titlesData.details = ActiveDummy.new
     @titlesData.details.attributes = {:start_index => start, 
                                        :results_per_page => max, 
                                        :number_of_results => titlesAll_length} 
     
     @titles   = paginateTitles(@titles, start, max,!types[:paginate])
     @paginationVars  = session[:paginationVars]
     @listType = "newfilmsPanel"
     
     
   end
   
   def getRecommendations()
      #t = Time.now().to_formatted_s(:number)
      #tmp_path   = File::join Rails.root, "tmp/graph_"+t+".dat"

      # Profile the code
      #result = RubyProf.profile do
        sessionVar = getListSessionVariable('listRecommendations')
        changeListPostion('listRecommendations', true, sessionVar[:inc])
        getRecommendations_p(sessionVar[:index],  sessionVar[:inc])
      #end

      # Print a graph profile to text
      #printer = RubyProf::CallTreePrinter.new(result)
      #File.open( tmp_path,'w'){|file|
      #  printer.print(file, :min_percent=>0)
      #}
     renderTitles(session[:categoryViewType], false)
   end
#-------------------------------------------------------------------------------------------------# 
   
   def getRecommendations_pagination()
      #t = Time.now().to_formatted_s(:number)
      #tmp_path   = File::join Rails.root, "tmp/graph_"+t+".dat"

      # Profile the code
      #result = RubyProf.profile do
     sessionVar = getListSessionVariable('listRecommendations')
        getRecommendations_p(sessionVar[:index],  sessionVar[:inc], true)
      #end

      # Print a graph profile to text
      #printer = RubyProf::CallTreePrinter.new(result)
      #File.open( tmp_path,'w'){|file|
      #  printer.print(file, :min_percent=>0)
      #}
     renderTitles(session[:categoryViewType], false, "Loop")
   end
#-------------------------------------------------------------------------------------------------# 
      
   def getRecommendations_p(start = 0, max = 100,requestpage = false)
     u = session[:persistentHash][:user_id]
     #Rails.cache.write('recommendations'+u,nil)
     titles = Rails.cache.read('recommendations'+u)
     titlesAll_length  = Rails.cache.read('titlesAll_lengthRecommendations'+u)
     
     if !titles
       titlesData = Title.find_recommendations(session)
       titles = Ltitle.mapAtt(titlesData.set, att="ext_id")
       titlesAll_length = titles.length
       titles = "'"+titles.join("','")+"'"
       Rails.cache.write('recommendations'+u,titles)
       Rails.cache.write('titlesAll_lengthRecommendations'+u,titlesAll_length)
     end
     
     sessionVar = getListSessionVariable('listRecommendations')
     sortSessionVar = getListSessionVariable('listRecommendations', 'sort')
     fliters   = getSqlFilters(sessionVar)
     

     rFlt      = fliters.merge(getRatingFilterType(sessionVar[:filterSet]['rating']))
     sortOrder = getSortOrder(sortSessionVar)
     types     = getQueryTypes(rFlt, sortOrder)

     fliters['titlesid'] = "ltitles.ext_id in ("+ titles+")"
     
     @titles   = queryDB(fliters, sortOrder, types[:queryCombos], types[:paginate], start, max)
     
     
     #@titles   = queryDBFilterTitles(titles, fliters, sortOrder, types[:queryCombos])
     
     
     @ratings = getTitleRatings_cached(@titles, session, types[:paginate], requestpage, 'listRecommendations')
     
     
     @titles   = getTitlesfilterByRating(@titles, @ratings, sessionVar[:filterSet]['rating'])
     @titles   = getTitlesOrderByRating(@titles, @ratings, sortSessionVar)

     if !types[:paginate]
       titlesAll_length = @titles.length
     end 
     
     @titles   = paginateTitles(@titles, start, max, !types[:paginate])
     @states   = getTitleStates(@titles,session) 
     @paginationVars  = session[:paginationVars]
    
     @titlesData = ActiveDummySet.new
     @titlesData.details = ActiveDummy.new
     @titlesData.details.attributes = {:start_index => start, 
                                       :results_per_page => max, 
                                       :number_of_results => titlesAll_length} 
     @listType = "recommendationsPanel"
   end
#-------------------------------------------------------------------------------------------------# 

#-------------------------------------------------------------------------------------------------# 
         
   def getSimlars
      @simlars = unfreezeArray(Rails.cache.read("simlars" + session[:persistentHash][:user_id]))
      if !@simlars
        @simlars = []
      end
      @indexSimlars = Rails.cache.read("indexSimlars"+ session[:persistentHash][:user_id])
      simlars_id = Rails.cache.read("simlars_id"+ session[:persistentHash][:user_id])
     # @simlars << simlars_id
      if !@indexSimlars
        @indexSimlars= 0
      end
      @simlars.insert(@indexSimlars+1, simlars_id) 
      @indexSimlars += 1
      Rails.cache.write("simlars"+ session[:persistentHash][:user_id],@simlars)
      Rails.cache.write("indexSimlars"+ session[:persistentHash][:user_id],@indexSimlars)
     # changeListPostion('listSimlars', true, 500)
      getSimlars_p
     # renderTitles(session[:categoryViewType])
   end 
#-------------------------------------------------------------------------------------------------# 
   
   def changeSimlarsIndex
     @simlars = Rails.cache.read("simlars"+ session[:persistentHash][:user_id])
     @indexSimlars = Rails.cache.read("indexSimlars"+ session[:persistentHash][:user_id])
     if params[:direction] == "simlars_forward"
       if @simlars.length > (@indexSimlars +1)
         @indexSimlars += 1
       end 
     else
       if @indexSimlars > 0 
         @indexSimlars -= 1
       end 
     end 
     Rails.cache.write("indexSimlars"+ session[:persistentHash][:user_id],@indexSimlars)
     #changeListPostion('listSimlars', true, 500)
     getSimlars_p
     #renderTitles(session[:categoryViewType])
   end
#-------------------------------------------------------------------------------------------------# 
   
   def getSimlars_pagination
     getSimlars_postion()
     @paginationVars  = session[:paginationVars]
     renderTitles(session[:categoryViewType], false, "Loop")
   end
#-------------------------------------------------------------------------------------------------# 
   
   def getSimlars_postion()
     getSimlars_p(session[:listIndex],  session[:listInc])
   end 
#-------------------------------------------------------------------------------------------------# 
   
   def getSimlars_p(start = 0, max = 100)
     id =  @simlars[@indexSimlars]
     @titlesData = Title.find_similars(session, id, start, max)
     @titles = Ltitle.find_by_netflix_set(@titlesData.set)
     @ratings = getTitleRatings(@titles,session)
     @states  = getTitleStates(@titles,session) 
     @status =  Rails.cache.read("cueStatus"+ session[:persistentHash][:user_id])
     @listType = "simlarsPanel"
     render :partial => 'listSimlars'
   end 
#-------------------------------------------------------------------------------------------------# 
   
   def showTitle
      @title              = Ltitle.find(params[:id])
      tvControl = {'series' => 'seasons', 
                   'seasons' => 'programs' }
      if  'seasons,series'.index(@title.titleType)
        @eps = Ltitle.find(:all, :conditions => "ext_id      like '%" + @title.ext_id + "%' and "+
                                                "titleType =     '"  + tvControl[@title.titleType] + "' ")
      else 
        @eps = []
      end 
      
      # titleType = 'series' or titleType = 'seasons' or titleType = 'programs')
      
      #SELECT * FROM netflixrmi.ltitles where (titleType = 'series' or titleType = 'seasons' or titleType = 'programs') and 
      # ext_id like '%http://api.netflix.com/catalog/titles/series/60002894%';
      
      #ext_idSet = @title.ext_id.split("/")
      #titleId = ext_idSet[ext_idSet.length - 1]
      
     threads = []
     threads << Thread.new(){ 
      @extended_title     = Title.find(session,@title.ext_id) 
     }
     sleep(0.25)
     threads << Thread.new(){ 
      @synopsis           = Title.find_synopsis(session,@title.ext_id)
     }
     sleep(0.25)
    threads << Thread.new(){
      @LanguagesAudio     = Title.find_languages_and_audio(session,@title.ext_id)
    }
     sleep(0.25)
     threads << Thread.new(){ 
      @awards             = Title.find_awards(session,@title.ext_id)
     }
     sleep(0.25)
     threads << Thread.new(){ 
      @rating             = Rating.find(@title.ext_id, session)
     }
     sleep(0.25)
     threads << Thread.new(){ 
      @state              = Cue.find_titles_states(session, @title.ext_id)
     }
     sleep(0.25)
     threads << Thread.new(){ 
      @titlesData         = Title.find_similars(session,@title.ext_id)
     }
     threads.each{|t| t.join}
      
      
      @titles             = Ltitle.find_by_netflix_set(@titlesData.set)
      @ratings            = getTitleRatings(@titles,session)
      @states             = getTitleStates(@titles,session) 
      
      @listType = @title.id.to_s + 'filmInfoPanel'
      
      render :partial => "titleInfo"
   end 
#-------------------------------------------------------------------------------------------------# 
   
   def extendedTitleData()
      @title = Ltitle.find(params[:id])
      tvControl = {'series' => 'seasons', 
                   'seasons' => 'programs' }
      if  'seasons,series'.index(@title.titleType)
        @eps = Ltitle.find(:all, :conditions => "ext_id      like '%" + @title.ext_id + "%' and "+
                                                "titleType =     '"  + tvControl[@title.titleType] + "' ")
      else 
        @eps = []
      end 
      @synopsis = Title.find_synopsis(session,@title.ext_id)
      render  :partial => "extendedTitleData"
   end 
   
#-------------------------------------------------------------------------------------------------# 
 
 
 def tagTitle
   id =   params[:id]
   list = unfreezeArray(Rails.cache.read("taglist"+ session[:persistentHash][:user_id]))
   i = list.index(id)
  
   if i 
     list = list.delete(i)
   else
     list << id
   end
   Rails.cache.write("taglist"+ session[:persistentHash][:user_id],list)
   
   render :nothing => true
   
 end 
 
 def getTagList
   list = unfreezeArray(Rails.cache.read("taglist"+ session[:persistentHash][:user_id]))
   
   @titles = Ltitle.find(:all,  :conditions => ['id in (?)', list ])
   @ratings = getTitleRatings(@titles,session)
   @states  = getTitleStates(@titles,session)
   
   #@paginationVars  = session[:paginationVars] 
   
   @titlesData = ActiveDummySet.new
   @titlesData.details = ActiveDummy.new
   @titlesData.details.attributes = {:start_index => 0, 
                                     :results_per_page => list.length, 
                                     :number_of_results => list.length} 
   @listType = 'tagsPanel'
     renderTitles(session[:categoryViewType], false)
 
 end 
 
 def imageChecker
  begin
      url = URI.parse(params[:path])
      res = Net::HTTP.new(url.host).head(url.request_uri)
    rescue
    sleep(0.25)
    retry
  end
  render :text => res.header['content-length']
 end
   
end
