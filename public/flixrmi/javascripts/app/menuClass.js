  function menuClass(options){

    if(options){
      var menuOptions;
      
      if(options.useDefaluts){
      
        menuOptions = {autosubmenudisplay: true, 
                          constraintoviewport:true, 
                          lazyload: false,
                          submenuhidedelay  :5000, 
                          scrollincrement :5, 
                          zIndex :10, 
                          hidedelay:5000, 
                          showdelay:0};
                          
         if(options.menuOptions){
           menuOptions = new helperClass().concatJson(menuOptions,options.menuOptions);
         }
         
      }else{
        menuOptions = options.menuOptions;
      }
         
      this.mv = options.mv;
      this.oMenuBar = new YAHOO.widget.MenuBar(options.menuId,menuOptions);
      this.initialize(options.elements);
      this.oMenuBar.render(options.placeHolderId);
    }
  }
  /*------------------------------------------------------------------------------------------------*/   

  menuClass.prototype.constructor = menuClass;

  menuClass.prototype.initialize = function(elements){

    for(var el in elements){
      this.initializeElement(elements[el]);
    }
  }

  menuClass.prototype.initializeElement = function(element){
     this.oMenuBar.addItems(this.initializefunctions(element));
  }
  
  /*------------------------------------------------------------------------------------------------*/   
  menuClass.prototype.initializefunctions = function(data){
    for(var i = 0;i<data.length;i++){
        if(data[i].onclick ){
            try{
              data[i].onclick.fn = eval((data[i].onclick.fn));
              data[i].onclick.obj.instanceObj = eval((data[i].onclick.obj.instanceObj));
             }catch(ee){
               debugger;
            }
        }
        if(data[i].submenu){
          data[i].submenu.itemdata = this.initializefunctions(data[i].submenu.itemdata);
        }
    }
    return data
  }
  /*------------------------------------------------------------------------------------------------*/  
  
  menuClass.prototype.setIndexedCheckMenuItem = function(menuId, index){
    var menu = YAHOO.widget.MenuManager.getMenu(menuId);
    var item;
    if(menu){
      item = menu.getItem(index);
      this.setCheckMenuItem(item);
    }
    //new helperClass().deleteDomElement(item);
    item = null;
    //new helperClass().deleteDomElement(menu);
    menu = null;
  }
  
  menuClass.prototype.setCheckMenuItem = function(item){
    if(item){
      this.clearChecksMenu_core(item.parent);
      item.cfg.setProperty("checked", true); 
    }
  }
  
  menuClass.prototype.clearChecksMenu = function(menuId){
    var menu = YAHOO.widget.MenuManager.getMenu(menuId);
    this.clearChecksMenu_core(menu);
   // new helperClass().deleteDomElement(menu);
    menu = null;
  }
  
  menuClass.prototype.clearChecksMenu_core = function(menu){
    if(menu){
      var list = menu.getItems();
      for(var i = 0;i<list.length;i++){
        list[i].cfg.setProperty("checked", false); 
      }
    }
   // new helperClass().deleteDomArray(list);
    menu = null;
  }
  
  menuClass.prototype.setCheckItemById = function(id, value){
    var menuItem = YAHOO.widget.MenuManager.getMenuItem(id);
    this.setCheckItem(menuItem,value);
 //   new helperClass().deleteDomElement(menuItem);
    menuItem = null;
  }
  
  menuClass.prototype.setCheckItem = function(item, value){
    if(item){
      item.cfg.setProperty("checked",value); 
    }
  }
  
  
  menuClass.prototype.getCheckItem = function(item){
    if(item){
      return item.cfg.getProperty("checked"); 
    }else{
      return false;
    }
  }
  
  
  

  /*------------------------------------------------------------------------------------------------*/  
 

  menuClass.prototype.injectHTML = function(paramSet){
    var fieldRef  = document.getElementById(paramSet.id);
    if(fieldRef){
      new helperClass().removeChildren(paramSet.id);
      var container =  new helperClass().createDomObject('span',{id:paramSet.containerId});
      container.innerHTML = paramSet.innerHTML;
      fieldRef.appendChild(container);
      new helperClass().deleteDomElement(container);
      container = null;
    }
    new helperClass().deleteDomElement(fieldRef);
    fieldRef = null;
  }

  /*------------------------------------------------------------------------------------------------*/
  