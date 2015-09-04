

class MainviewController < ApplicationController

  @@gd2_support = false
  
  begin
 #   require 'gd2'
 #   include GD2 
 #   @@gd2_support = true
  rescue
    
  end 


  def index
    configs :mainViewOptions, 
            :searchMenuVar,  
            :silders, 
            :panels, 
            :searchField, 
            :pagination, 
            :mainPageSettings,
            :scrollObj, 
            :treeViewNodes, 
            :ScaleSliders,
            :sessionDefaults,
            :viewTypesData,
            :menuOptions,
            :fliterPanelOptions,
            :wpfile
            
    setupServerSideSessionVariables() 
    getviewOptionsMenu()
    setupclassLists()
    setupSilders()
    getTreeviewNodes()
    @itemLimit = session[:itemLimit]
    @thumbsize = session[:thumbsize]
    
    u = session[:persistentHash][:user_id]
    
    Rails.cache.write('recommendations'+u,nil)
    Rails.cache.write('titlesAll_lengthRecommendations'+u,nil)
    
    [ 'listCue','listRecommendations', 'listCategory',  'listHistory', 'listNew'].each{|a|
      Rails.cache.write(a+ "ratings"+ u, nil)
    }
    
    ['All', "At Home", "Shipped", "Returned",  "Watched"].each{|a|
      Rails.cache.write(a + 'history'+u,nil)
      Rails.cache.write(a + 'titlesAll_history'+u,nil)
    }
    
    @wpfile[:containersList].each{|key,value|
      if @wpfile[:walpaperfolder][value]
        @wpfile[:filelist][value] = getwallpaperList(@wpfile[:walpaperfolder][value], 
                                                     @wpfile[:thumbfolder], 
                                                     @wpfile[:thumbWidth], 
                                                     @wpfile[:thumbHeight])
      end
    }
    
    
    showcolor = (session['color'] != 'false')
    @bodyBG = "background-image:url('/wallpapers/flixmontagelogo.JPG');"
    if showcolor and session['backgroundColor']
      @bodyBG = "background-color:"+ session['backgroundColor']+";"
    elsif session['backgroundImage']
      @bodyBG = "background-image:"+ session['backgroundImage']+";"
    end
  end 
  
  
  def clientVarsUpdate()
     clientVarsUpdate_core()
     render :nothing => true
  end  
  
  def viewTypeUpdate
    key = getPanelListKey(params[:currentPanel])
    sessionVar = getListSessionVariable(key, 'view')
    sessionVar[:viewType] = params[:viewType]
    render :nothing => true
  end 
  
  
  
    #-------------------------------------------------------------------------------------------------#
  
  private
  
    #-------------------------------------------------------------------------------------------------#  
    
  def getwallpaperList(pDir, t, w, h )
    mDir = 'public/' + pDir+'/'
    t = 'thumbs'
    list = getfileList(mDir)
    if @@gd2_support
      list.each{|i|
        convert(t, mDir,  w, h , i)
      }
    end 
    return list
  end
  
  def getfileList(w)
    path = Rails.root+ w
    d = Dir.new(path)
    list = d.reject{|a| !(a.index('.') and a != ".." and a != ".")}
    return list.sort.reverse
  end 

  
  def convert(thumbpath, imagepath, width, height, specs)

    path =   ( Rails.root + imagepath ).to_s   # default image library directory
    widthx = 500          # default width of generated image
    heightx = 500         # default height of generated image
    
    if width then widthx = width.to_i
    end

    if height then heightx = height.to_i
    end    
           
    filepath = path + specs   # Path to file
    
    format = filepath.split(".").last             # Format - extension
    
    filename = specs.last.split(".").first # just file name without extension

    picfile = filepath
    cachedpicfile = path + thumbpath +'/'+ specs
   
    if File.exists?(cachedpicfile) && (File.stat( cachedpicfile ).mtime.to_i > File.stat( picfile ).mtime.to_i)
      picsource = cachedpicfile
      cache = true
    elsif File.exists? picfile 
      picsource = picfile
    end
   

    if cache == true    # Read from Cache
      #@pic = File.new(picsource).read
    else                # Import an image
      i = Image.import(picsource)
     
      if i.size[0] > i.size[1]  # Horizontal proportion. width > height.
        if i.size[0] < widthx then width = i.size[0]     # preffer smaller image width
        else width = widthx
        end
       
        height = width * i.size[1] / i.size[0]
        
      else                      # Vertical proportions
        if i.size[1] < heightx then height = i.size[1]
        else height = heightx
        end
        
        width = i.size[0] /(i.size[1] / height) 
      end
     
      i.resize! width, height
      i.export(cachedpicfile) # export cache file
    end
    
  end  
    #-------------------------------------------------------------------------------------------------#  
  
    def setupServerSideSessionVariables()
      initalizeSessionDefaults(@sessionDefaults, session)
    end 
    
    def initalizeSessionDefaults(datalist, sessionVar)
      datalist.each {|key,defaultValue|
        sessionVar[key] = sessionVar[key] ||= defaultValue
      }
    end 
    
    #-------------------------------------------------------------------------------------------------#  
    
    def setupclassLists()
      @envelopedView = (session[:ViewEnvelop] == "true")
      @viewTypes     = {}
      @thumbViewList = {}
      @lookClassList = {}
      @dataClassList = {}
      @ShownDataClassList = {}

      @panels[:normalListPanels].each do |panelName| 
        @thumbViewList[panelName]      = createClassList(:thumbView, panelName)
        @lookClassList[panelName]      = createClassList(:lookContainer,panelName)
        @dataClassList[panelName]      = createClassList(:dataContainer,panelName)
        @ShownDataClassList[panelName] = createClassList(:ShownDataContainer,panelName)
        sessionVar = getListSessionVariable(getPanelListKey(panelName), 'view')
        @viewTypes[panelName] = sessionVar[:viewType]
      end 
      if session['EnvelopedOptions']
        @viewTypes['EnvelopedOptions'] = session['EnvelopedOptions'][:viewType]
      end
    end  
    #-------------------------------------------------------------------------------------------------#  
    
    
    def createClassList(classList, key)
      ret = ""
      key        = getPanelListKey(key)
      sessionVar = getListSessionVariable(key, 'view')
      data       = @viewTypesData[:data][sessionVar[:viewType].to_sym]
      sorted = data[classList].keys.collect{|a| a.to_s}.sort()
      
      sorted.each {|key|
        ret += data[classList][key.to_sym]
        ret += " "
      }
      return ret
    end
    
    #-------------------------------------------------------------------------------------------------#  
    
    
    #-------------------------------------------------------------------------------------------------#  
    
    def setupSilders()                                                               
      @silderSet   = @silders.to_json.html_safe   
      @slidersHash = @silders
    end  
  
    #-------------------------------------------------------------------------------------------------#
    #-------------------------------------------------------------------------------------------------#   
    
    
    def getviewOptionsMenu()
      listCategoryBaseUrl  = url_for(:controller => 'Category', :action => 'listCategory') 
      @search_start        = url_for(:controller => 'Category', :action => 'search_start')
      @autocomplete        = url_for(:controller => 'Category', :action => 'autocomplete')
      @clientVarsUpdate    = url_for(:controller => 'Mainview', :action => 'clientVarsUpdate')
      @listPagination      = url_for(:controller => 'Category', :action => 'listPagination')
      
      @viewOptionsMenu = getMenu(@mainViewOptions).to_json.html_safe
      @searchMenu      = @searchMenuVar.to_json.html_safe
    end 
   
    #-------------------------------------------------------------------------------------------------#
    #-------------------------------------------------------------------------------------------------#      
    
    def getGenresMap()
       main = Lgenre.find_by_name('Main_Menu')
       data = []
       data[0] = {:text => "Genres", 
                   :id => "genresMenuLabel", 
                   :submenu =>   { :id =>       "genresMenu",
                                   :itemdata => walktree(main, 0, {})}
                  }
  
       @genresMenu = data.to_json.html_safe
     end
    #-------------------------------------------------------------------------------------------------#   
  
     def walktree(root, level, nodeList)
       itor = 0
       data = []
       listCategoryBaseUrl = '/flixrmi/Category/listCategory/'
        listCategoryParamSet = {:instanceObj             => 'this.mv', 
                                :mainViewId              => 'categoryPanel_mainView',  
                                :loadingImageId          => 'loading', 
                                :loadingReadyClassName   => 'ready', 
                                :loadingloadingClassName => 'loading', 
                                :baseUrl                 => listCategoryBaseUrl}
       if root
         if root.children
           root.children.find(:all, :order => "name").each {|child|
             html_key = level.to_s + root.name + "_" + child.id.to_s
             data[itor] = yuiMenuItem(child.name, html_key, "this.mv.listCategory", 
                                        listCategoryParamSet.merge({:id => child.id, :name => child.name }),
                                        nil, (session[:genresid] == child.id.to_s ))
             if child.children.count > 0 and (!nodeList[root.name + "_" + child.name])
               nodeList[root.name + "_" + child.name] = level
               data[itor][:submenu] = {:id => "gMenu_" + html_key}
               data[itor][:submenu][:itemdata] = walktree(child, level + 1, nodeList)
             end

             itor += 1
          }
         end
       end 
       return data
     end
    #-------------------------------------------------------------------------------------------------#  
     
    def getMenu(menuData, preSufix = "")
      if menuData.class.to_s == "Array"
        data = []
        menuData.each {|item|
          data << getMenu(item, preSufix)
        }
        return data
      else
        cleanedParentLabel =  menuData[:label].gsub(" ", '')
        parentIdSrufix = preSufix + "_" + cleanedParentLabel
        if menuData[:children] 
           cData = []
           if menuData[:children][0].class.to_s == "String"
             menuData[:children].each {|item|
               cData << getMenuItem({:parent => menuData[:label], :label => item.to_s, 
                                     :parentSrufix => parentIdSrufix, :paramParentSrfix => cleanedParentLabel, 
                                     :fn => menuData[:fn], :param => menuData[:param]})
             }
           else
             menuData[:children].each {|item|
               cData << getMenu(item, parentIdSrufix)
             }
           end 
           return yuiMenuItem(menuData[:label], parentIdSrufix, nil, nil, cData)
        else
          return yuiMenuItem(menuData[:label], parentIdSrufix, 
                              menuData[:fn],  menuData[:param])
        end
      end 
    end
    
    #-------------------------------------------------------------------------------------------------#  
    def getMenuItem(itemData)
         itemId = itemData[:parentSrufix] + itemData[:label]
        temp = itemData[:param].clone
        temp[:item] = itemData[:paramParentSrfix] + itemData[:label]
        temp[:prefix] = itemData[:paramParentSrfix] 
        return yuiMenuItem(itemData[:label], itemId, itemData[:fn], temp, nil,
                            (session[temp[:SessionKey]] == itemId ))
    end
    
    def yuiMenuItem(label, idSrufix, functionName = nil, paramObject = nil, subMenu = nil, checked = nil)
      item           = {:text => label, :id => "MenuItem" + idSrufix }
      item[:onclick] = {:fn => functionName,      :obj => paramObject}   if functionName
      item[:submenu] = {:id => idSrufix + "Menu", :itemdata => subMenu, :zIndex => 10 }  if subMenu 
      item[:checked] = true if checked
     return item
    end 
  
    #-------------------------------------------------------------------------------------------------#  
    #-------------------------------------------------------------------------------------------------#  
    
    def getTreeviewNodes()
     unless admin?
       n = @treeViewNodes.index{|a| a if a[:label] == "Tags" }
       if n
         @treeViewNodes[n] = nil
         @treeViewNodes.compact!
       end 
     end 
     static = getTreeView(@treeViewNodes)
     genres = getGenresTreeView()
     
      top = [{:expanded => true, :labelElId => "topLabel", 
              :type => 'html', :html => "<span>Resources</span>",  
              :children => static.concat(genres)
             }]
      @tvNodes = top.to_json.html_safe
    end 
    
    
   
    #-------------------------------------------------------------------------------------------------#   
    def getGenresTreeView()
       main = Lgenre.find_by_name('Main_Menu')
       data = []
       data[0] = {:html => "<span>Genres</span>", :type => 'html',
                   :labelElId => "genresMenuLabel", :expanded => true, 
                   :children => walkTreeView(main, 0, {})
                  }
  
       @genresTree = data
     end
    #-------------------------------------------------------------------------------------------------#   
  
     def walkTreeView(root, level, nodeList)
       itor = 0
       data = []
       listCategoryBaseUrl = '/flixrmi/Category/listCategory/'
        listCategoryParamSet = {:instanceObj             => 'args.mv', 
                                :treeviewId              => 'treeview_placeHolder',
                                :mainViewId              => 'categoryPanel_mainView',  
                                :loadingImageId          => 'loading', 
                                :loadingReadyClassName   => 'ready', 
                                :loadingloadingClassName => 'loading', 
                                :baseUrl                 => listCategoryBaseUrl}
       if root
         if root.children
           root.children.find(:all, :order => "name").each {|child|
             html_key = level.to_s + root.name + "_" + child.id.to_s
             data[itor] = yuiTreeviewItem(child.name, html_key, "new mainViewClass().tvListCategory", 
                                          listCategoryParamSet.merge({:id => child.id, :name => child.name }),
                                          (session[:genresid] == child.id.to_s ))
                                          
             if child.children.count > 0 and (!nodeList[root.name + "_" + child.name])
               nodeList[root.name + "_" + child.name] = level
               data[itor][:children] = walkTreeView(child, level + 1, nodeList)
             end

             itor += 1
          }
         end
       end 
       return data
     end
    
    def getTreeView(menuData, preSufix = "")
      if menuData.class.to_s == "Array"
        data = []
        menuData.each {|item|
          data << getTreeView(item, preSufix)
        }
        return data
      else
        cleanedParentLabel =  menuData[:label].sub(" ", '')
        parentIdSrufix = preSufix + "_" + cleanedParentLabel
        if menuData[:children] 
           cData = []
           if menuData[:children][0].class.to_s == "String"
             menuData[:children].each {|item|
               cData << getTreeviewItem({:parent => menuData[:label], :label => item.to_s, 
                                     :parentSrufix => parentIdSrufix, :paramParentSrfix => cleanedParentLabel, 
                                     :fn => menuData[:fn], :param => menuData[:param]})
             }
           else
             menuData[:children].each {|item|
               cData << getTreeView(item, parentIdSrufix)
             }
           end 
           return yuiTreeviewItem(menuData[:label], parentIdSrufix, nil, nil, nil, cData, menuData[:url], menuData[:target])
        else
          return yuiTreeviewItem(menuData[:label], parentIdSrufix, 
                              menuData[:fn],  menuData[:param],nil,nil, menuData[:url], menuData[:target] )
        end
      end 
    end
    
    #-------------------------------------------------------------------------------------------------#  
    def getTreeviewItem(itemData)
         itemId = itemData[:parentSrufix] + itemData[:label]
        temp = itemData[:param].clone
        temp[:item] = itemData[:paramParentSrfix] + itemData[:label]
        temp[:prefix] = itemData[:paramParentSrfix] 
        return yuiTreeviewItem(itemData[:label], itemId, itemData[:fn], temp, 
                                (session[temp[:SessionKey]] == itemId ), nil, itemData[:url], itemData[:target] )
    end
     
    def yuiTreeviewItem(label, idSrufix, func = nil, paramObject = nil, checked = nil, children = nil, url = nil, target = nil)
      item  = {'type' => 'HTML'}
      idSur = idSrufix.gsub('(\&| )','')
      paramJson = paramObject.to_json.html_safe.gsub("\"",'\'')
      if !label
        label = ""
      end 
      if url 
        item[:html] = '<a class="tvLink" id="treeViewItem'+idSur + '"'
        item[:html]  += ' href="'+url + '"'
        if target
          item[:html]  += ' target="'+target + '"'
        end 
        item[:html]  +=  '>'+ label +  '</a>'
      else
        item[:html] = '<span id="treeViewItem'+idSur + '"'
        if func
          item[:html]  +=   ' param="'+ paramJson+'"'
        end 
        item[:html]  +=  '>'+ label +  '</span>'
      end
      item[:checked] = true if checked
      if children 
        item[:children] = children
      end
     return item
    end 
end
