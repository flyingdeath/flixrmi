
  function linkControllerClass(options){
    try{
      this.h = new helperClass();
      this.elements = {};
      this.initializeOptions(options);
    }catch(err){
      debugger;
    }
  }
  
  linkControllerClass.prototype.constructor = linkControllerClass;

  /*------------------------------------------------------------------------------------------------*/

  linkControllerClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  linkControllerClass.prototype.initialize = function(elements){
    for(var el in elements){
      this.initializeElement(el,elements[el]);
    }
  }
  
  linkControllerClass.prototype.updateObjects = function(title){
    this.titleObj = title;
  }
  
  
  linkControllerClass.prototype.initialize = function(contianerId){
    var contianer = document.getElementById(contianerId);
    this.initializing = true;
    if(contianer){
      var list = YAHOO.util.Dom.getElementsByClassName(this.itemClassName,'',contianer);
      var listb = YAHOO.util.Dom.getElementsByClassName(this.searchClassName,'',contianer);
      var listc = YAHOO.util.Dom.getElementsByClassName(this.epsClassName,'',contianer);
      list = list.concat(listb);
      list = list.concat(listc);
      for(var i = 0;i<list.length;i++){
        this.initializeListener(this.h.removeSurfix(list[i].id),list[i].id);
      }
    }
    this.h.deleteDomElement(contianer);
    this.h.deleteDomArray(list);
    this.h.deleteDomArray(listb);
    this.h.deleteDomArray(listc);
    contianer = null;
    list = null;
    listb = null;
    listc = null;
    this.initializing = false;
  }
  
  linkControllerClass.prototype.destroyList = function(contianerId){
    var contianer = document.getElementById(contianerId);
    if(contianer){
      var list = YAHOO.util.Dom.getElementsByClassName(this.itemClassName,'',contianer);
      var listb = YAHOO.util.Dom.getElementsByClassName(this.searchClassName,'',contianer);
      var listc = YAHOO.util.Dom.getElementsByClassName(this.epsClassName,'',contianer);
      list = list.concat(listb);
      list = list.concat(listc);
      for(var i = 0;i<list.length;i++){
        this.initializeListener(this.h.removeSurfix(list[i].id),list[i].id);
      }
    }
    this.h.deleteDomElement(contianer);
    this.h.deleteDomArray(list);
    this.h.deleteDomArray(listb);
    this.h.deleteDomArray(listc);
    contianer = null;
    listb = null;
    listc = null;
    list = null;
  }
  
  linkControllerClass.prototype.destroy = function(id,fullId){
    try{
      YAHOO.util.Event.removeListener(fullId, 'click', this.titleObj.showPersonInfo);
      YAHOO.util.Event.removeListener(fullId, 'click', this.titleObj.showFullSearch);
      YAHOO.util.Event.removeListener(fullId, 'click', this.titleObj.showTitleInfo);
      if(this.elements[id]){
        this.elements[id] = null;
        delete this.elements[id];
      }
    }catch(error){
      debugger;
    }
  }
  
  linkControllerClass.prototype.initializeListener = function(id, fullId){
    try{
      var init = false;
      
      if(!this.elements[id]){
        init = true;
      }else if(this.elements[id].destroyed){
        this.elements[id].destroyed = false;
        init = true;
      }
       
//      if(init){ 
        this.elements[id] = {'id':id, updateType: 'updateDom', 'fullId':fullId};
        
        var itemParamSet = {instanceObj:this.titleObj, element:this.elements[id] };
        var classname = this.h.getClassName(fullId);
        switch(classname){
          case this.itemClassName:
            this.h.addlistenersSet({refList:[fullId],
                                  eventList:{click:{func: this.titleObj.showPersonInfo,
                                                    param:itemParamSet}}});
            break;
          case this.searchClassName:
            this.h.addlistenersSet({refList:[fullId],
                                  eventList:{click:{func: this.titleObj.showFullSearch,
                                                    param:itemParamSet}}});
            break;
          case this.epsClassName:
            this.h.addlistenersSet({refList:[fullId],
                                  eventList:{click:{func: this.titleObj.showTitleInfo,
                                                    param:itemParamSet}}});
            break;
            
            
            
        }
//      }
    }catch(error){
      debugger;
    }
  }