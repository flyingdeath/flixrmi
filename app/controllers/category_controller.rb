
require 'ruby-prof'

class CategoryController < ApplicationController

  @@sessionKey = 'listCategory'
   
#-------------------------------------------------------------------------------------------------#   
  #  before_filter :setSessionVars
#-------------------------------------------------------------------------------------------------#   
  
    def listCategory()
    #  t = Time.now().to_formatted_s(:number)
    #  tmp_path   = File::join Rails.root, "tmp/graph_"+t+".dat"

      # Profile the code
    #  result = RubyProf.profile do

       #   session['listCategory'][:inc] ||= 25
          sessionVar = getListSessionVariable(@@sessionKey)

          changeListPostion(@@sessionKey, true, sessionVar[:inc])
          listCategory_core()
    #  end

      # Print a graph profile to text
    #  printer = RubyProf::CallTreePrinter.new(result)
    #  File.open( tmp_path,'w'){|file|
    #    printer.print(file, :min_percent=>0)
    #  }

      renderTitles(session[:categoryViewType], (session[:genresid] == nil))
    end 
    
    def listCategory_pagination()
   #   t = Time.now().to_formatted_s(:number)
   #   tmp_path   = File::join Rails.root, "tmp/graph_"+t+".dat"

      # Profile the code
    #  result = RubyProf.profile do
         @renderNothing   = (session[:genresid] == nil)
         @paginationVars  =  session[:paginationVars]
         listCategory_core(true)
    #  end

      # Print a graph profile to text
    #  printer = RubyProf::CallTreePrinter.new(result)
    #  File.open( tmp_path,'w'){|file|
    #    printer.print(file, :min_percent=>0)
    #  }
         renderTitles(session[:categoryViewType], @renderNothing, "Loop")
    end
    
#-------------------------------------------------------------------------------------------------#   
 
    private 
    
#-------------------------------------------------------------------------------------------------#   
    
    def setSessionVars()
      setFilters(getListSessionVariable(@@sessionKey))
    end
   
#-------------------------------------------------------------------------------------------------#   
   
    def listCategory_core(requestpage = false)
      
      setParamSessionVar(:id, :genresid)
      setParamSessionVar(:categoryViewType)

      if session[:genresid] 
        @genre    = Lgenre.find(session[:genresid])
        sessionVar = getListSessionVariable(@@sessionKey)
        sortSessionVar = getListSessionVariable(@@sessionKey,'sort')
        page     = sessionVar[:index]
        per_page = sessionVar[:inc]
        fliters   = getSqlFilters(sessionVar)
        rFlt =fliters.merge(getRatingFilterType(sessionVar[:filterSet]['rating']))
        sortOrder = getSortOrder(sortSessionVar)
        types     = getQueryTypes(rFlt, sortOrder)
        @titles   = queryDB(fliters, sortOrder, types[:queryCombos], types[:paginate], page, per_page)
        
        if types[:paginate]
          titlesAll = queryDB(fliters, sortOrder, types[:queryCombos], false, page, per_page)
          titlesAll_length =  titlesAll.length
          titlesAll = nil
        end 
        @ratings = getTitleRatings_cached(@titles, session, types[:paginate], requestpage, 'listCategory')
     
        
        
        @titles   = getTitlesfilterByRating(@titles, @ratings, sessionVar[:filterSet]['rating'])
        
        @titles   = getTitlesOrderByRating(@titles, @ratings, sortSessionVar)
    
        
        if !types[:paginate]
          titlesAll_length = @titles.length
        end 
    
        @titlesData = ActiveDummySet.new
        @titlesData.details = ActiveDummy.new
        @titlesData.details.attributes = {:start_index => page, 
                                           :results_per_page => per_page, 
                                           :number_of_results => titlesAll_length} 

        @titles   = paginateTitles(@titles, page, per_page, !types[:paginate])
        
        @states  = getTitleStates(@titles,session)
        
        @listType = "categoryPanel"
        
      end 
    end
#-------------------------------------------------------------------------------------------------#   
   
   def queryDB(filter, sort, queryCombos, paginate, page, per_page)
     sortOrder = sort[sort.keys[0]]
     filter['titletype'] = "ltitles.titleType in ('movie','series')"
     case queryCombos
       when 'normal'
        if paginate
         ret = @genre.ltitles.find(:all, :conditions => joinSqlHash(filter), :order => sortOrder,
                                       :offset =>  (page),  :limit =>  per_page)
        else
         ret = @genre.ltitles.find(:all, :conditions => joinSqlHash(filter), :order => sortOrder)
        end
       when 'availability', 'availability,normal'
         ret = getTitlesThroughFconnectors(@genre, sortOrder, filter, paginate, page, per_page )
       when 'format','format,normal'
         ret = getTitlesThroughFormats(@genre, sortOrder, filter, paginate, page, per_page )
       when 'availability,format', 'availability,format,normal'
         titleIds = mapAtt(getTitlesThroughFormats(@genre, sortOrder, filter, false, page, per_page),"ltitles_id")
         s_filter = joinSqlHash(nilOutHashValues(filter,['formatType','normal']))
         if paginate
           ret = Ltitle.getTitlesThroughFconnectors_paginate(titleIds, sortOrder, s_filter, 
                                                              page, per_page )
         else
           ret = Ltitle.getTitlesThroughFconnectors(titleIds, sortOrder, s_filter)
         end 
       else
     end
     
     return ret
   end
#-------------------------------------------------------------------------------------------------#   
   
   def getTitlesThroughFormats(genre,strSort, filter, paginate, page, per_page)
     f = joinSqlHash(nilOutHashValues(filter,['availability','formatType']))
     titleIds = mapAtt(genre.ltitles.find(:all, :conditions => f, :select=>'ltitles.id'))
     if !titleIds.empty?
       f_filter = joinSqlHash(nilOutHashValues(filter,['year','availability','titletype']))
       formatIds = mapAtt(Lformat.find(:all,  :conditions => f_filter))
       if !formatIds.empty?
         if paginate
           titles   = Ltitle.getTitlesThroughFormats_paginate(titleIds, formatIds, strSort,  page,per_page )
         else
           titles   = Ltitle.getTitlesThroughFormats(titleIds, formatIds, strSort)
         end 
       else
         titles = []
       end 
    else
      titles = []
    end 
     return titles
   end 
#-------------------------------------------------------------------------------------------------#   
   
   def getTitlesThroughFconnectors(genre, strSort, filter, paginate,page, per_page)
     f = joinSqlHash(nilOutHashValues(filter,['availability']))
     titleIds = mapAtt(genre.ltitles.find(:all, :conditions => f, :select=>'ltitles.id' ))
     f = joinSqlHash(nilOutHashValues(filter,['normal']))
     if !titleIds.empty?
       if paginate
         titles = Ltitle.getTitlesThroughFconnectors_paginate(titleIds, strSort, f, 
                                                            page, per_page)
       else
         titles = Ltitle.getTitlesThroughFconnectors(titleIds, strSort, f)
       end
     else
       titles = []
     end
     return titles
   end 
  
  end
