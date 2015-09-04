class SearchController < ApplicationController


    def bulksearch()
      
      terms = params[:term].split("\n")
      titlesData = []
      titles = []
      @terms = {}
      threads = []
      i = 0
      count = 4
      terms.each{|term|
        if ((i+1) % (count )) == 0 and i != 0
          sleep(5)
          Logger.new(STDOUT).info 'sleep a ' + i.to_s + Time.now.to_s(:db)
        end
        sleep(0.25)
        threads << Thread.new(){
            titlesData << Title.find_by_name(session, term, false, 0, 1)
            if titlesData[i]
              if titlesData[i].set
                @terms[titlesData[i].set[0].attributes['ext_id']] = term
              end
            end
        }
        i += 1
      }
      threads.each{|t|
        t.join
      }
      
      titlesData.each{|title|
        titles = titles.concat(title.set)
      }
      @titles = Ltitle.find_by_netflix_set(titles)
      @ratings = getTitleRatings(@titles,session)
      @states  = getTitleStates(@titles,session)
      
      @titlesData = ActiveDummySet.new
      @titlesData.details = ActiveDummy.new
      @titlesData.details.attributes = {:start_index => 0, 
                                        :results_per_page => @titles.length, 
                                        :number_of_results => @titles.length} 
                                        
      @listType = "bulksearchPanel"
      renderTitles(session[:categoryViewType])
    
    end 
    

    def search_start()
      setParamSessionVar(:term)
      sessionVar = getListSessionVariable('listSearch')
      changeListPostion('listSearch', true, sessionVar[:inc])
      search_p(session[:term], false, 0)
      renderTitles(session[:categoryViewType])
    end
    
    def autocomplete()
      titles = Title.find_by_name(session, params[:query], true)
      render :text => titles.html_safe
    end 
    
    def search_pagination
      search_position()
      @paginationVars  = session[:paginationVars]
      renderTitles(session[:categoryViewType], false, "Loop")
    end
    
    private 
   
    def search_position()
      sessionVar = getListSessionVariable('listSearch')
      search_p(session[:term], false,sessionVar[:index],  sessionVar[:inc] )
    end 
    
    def search_p(term, auto = false, start = 0, max = 25)
    #------ Search -------------------------------------#  
      @titlesData = Title.find_by_name(session, term, auto, start, max)
      #@titles = @titlesData.set
      @titles = Ltitle.find_by_netflix_set(@titlesData.set)
      #@titles  = @titlesData.set
      @ratings = getTitleRatings(@titles,session)
      @states  = getTitleStates(@titles,session)
      @listType = "searchPanel"
    end  
    
    
end
