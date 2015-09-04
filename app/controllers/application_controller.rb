# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require "YAMLConverter"
require "Authorization.rb"
require "TitleControl.rb"
require "lastfm12"
#require 'unprof'
# require ‘oink’



class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  include Authorization
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_session
  #-------------------------------------------------------------------------------------------------# 
   helper_method :admin?
   
  
 #-------------------------------------------------------------------------------------------------#   

   def listPagination()
     listAction =  getPanelListKey(params['listAction'])
     sessionVar = getListSessionVariable(listAction)
     
     changeListPostion(listAction, false,
                       sessionVar[:inc],
                       params[:page].to_i)
     @renderNothing = false
     case listAction
       when 'listSearch'
         redirect_to :controller => "search", :action => 'search_pagination'
       when 'listCategory'
         redirect_to :controller => "Category", :action => 'listCategory_pagination'
       when 'listHistory'
         redirect_to :controller => "history", :action => 'history_pagination'
       when 'listSimlars'
         redirect_to :controller => "Title", :action => 'getSimlars_pagination'
       when 'listRecommendations'
         redirect_to :controller => "Title", :action => 'getRecommendations_pagination'
       when 'listNew'
         redirect_to :controller => "Title", :action => 'getNew_pagination'
       else
         render :nothing  => true
     end
   end     
   
   def ListVarsUpdate()
     clientVarsUpdate_core()
     listControl()
   end 
   
   def listControl()
     convert = {'recommendationsPanel' => 'listRecommendations',
                'categoryPanel'        => 'listCategory',
                'historyPanel'         => 'listHistory',
                'newfilmsPanel'        => 'listNew'}
     
     listAction = convert[params[:listAction]]
     
     if listAction
       s = getListSessionVariable(listAction, 'sort')
       f = getListSessionVariable(listAction)
       if params[:dialogSubmit]
         setFilterParams(f)
         setInitSortOrder(s)
       else
         setFilters(f)
         setSortOrder(s)
       end 
       if params[:limit] 
         f[:inc] =  params[:limit].to_i
       end
     end
     
     case listAction
       when 'listCategory'
         redirect_to :controller => "Category", :action => 'listCategory'
       when 'listHistory'
         redirect_to :controller => "history", :action => 'listHistory'
       when 'listRecommendations'
         redirect_to :controller => "Title", :action => 'getRecommendations'
       when 'listNew'
         redirect_to :controller => "Title", :action => 'getNew'
       else
         render :nothing  => true
     end
   end     
   
   def listGetControlOptions()
     
     listKey =  getPanelListKey(params[:panelName])
     
     
      
     if listKey
       h1 = getListSessionVariable(listKey).clone
       h2 = getListSessionVariable(listKey, 'sort')
       h3 = getListSessionVariable(listKey, 'view')
       h1[:Sort] = h2[:Sort]
       h1[:viewType] = h3[:viewType]
     else
       h1 = {}
     end 
     
     h1[:ViewEnvelop]   = session[:ViewEnvelop]
     h1[:FilterEnvelop] = session[:FilterEnvelop]
     h1[:SortEnvelop]   = session[:SortEnvelop]
     h1[:limit]         = h1[:inc]
     
     render :json => h1
   end     
     
   
 protected
  
  def admin?
    u = Users.find_by_user_id(session[:persistentHash][:user_id])
    return (u.nickname == "TimeEffect")
  end
  
  def authorize
    unless admin?
      false
      render :nothing  => true
    end
  end    
   
   
 #-------------------------------------------------------------------------------------------------#   
  private
 #-------------------------------------------------------------------------------------------------#   
  
  def setFilterParams(flt)
    setFilterParamsSet(flt, params, :filterSet, ['year', 'rating', 'availability'], 
                          [ 'rating', :FliterRatingType, :ratingType],
                          ['formatType', :FormatType, 'format'], '_filter' )
  end 
  
  def setFilterParamsSet(flt, p, fltkey, fkeys, rKeys,formatKey, paramSurfix )
    fkeys.each{|key|
      flt[fltkey][key] = p[key + paramSurfix]
    }
    flt[fltkey][rKeys[0]][rKeys[1]] = p[rKeys[2]]
    flt[fltkey][formatKey[0]] = {}
    flt[fltkey][formatKey[0]][formatKey[1]] = p[formatKey[2]]
    flt[:filterSet] = cleanFilterSet(flt[:filterSet])
  end
  
  
  include TitleControl
  
  def configs(*names)
    path = File.dirname(__FILE__) +  "/../../lib/config_files/" 
    names.each{|file|
     temp =  YAMLConverter.new("#{path}#{file}.yml")
     if temp.fileSet
       eval("@#{file} = temp.fileSet.clone")
     end 
    }
  end
 #-------------------------------------------------------------------------------------------------#   
     
   def writeStringToFlie(path, name, openType, content)
      if name
        File.open(path + name, openType){|f|
          f.write(content)
        }
      end
   end 

end
