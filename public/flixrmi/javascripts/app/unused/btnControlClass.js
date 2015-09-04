 function btnControlClass(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
     // this.initialize();  
    }catch(err){
      debugger;
    }
  }
  
  btnControlClass.prototype.constructor = btnControlClass;

  /*------------------------------------------------------------------------------------------------*/

  btnControlClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  btnControlClass.prototype.updateObjects = function(panels){
    this.panelsObj = panels;
  }
  
  btnControlClass.prototype.initialize = function(contianerId){
    var contianer = document.getElementById(contianerId);
    this.initializing = true;
    if(contianer){
      var list = YAHOO.util.Dom.getElementsByClassName(this.itemClassName,'',contianer);
      for(var i = 0;i<list.length;i++){
        this.initializeListener(this.h.removeSurfix(list[i].id),list[i].id);
      }
    }
    this.h.deleteDomElement(contianer);
    contianer = null;
    this.h.deleteDomArray(list);
    list = null;
    this.initializing = false;
  }
  
  btnControlClass.prototype.destroyList = function(contianerId){
    var contianer = document.getElementById(contianerId);
    if(contianer){
      var list = YAHOO.util.Dom.getElementsByClassName(this.itemClassName,'',contianer);
      for(var i = 0;i<list.length;i++){
          this.destroy(this.h.removeSurfix(list[i].id),list[i].id);
      }
    }
    this.h.deleteDomElement(contianer);
    contianer = null;
    this.h.deleteDomArray(list);
    list = null;
  }
  
  btnControlClass.prototype.destroy = function(id,fullId){
    try{
        this.h.removelistenersSet({refList:[id+'_ratingBtn_1',
                                   id+'_ratingBtn_2',
                                   id+'_ratingBtn_3',
                                   id+'_ratingBtn_4',
                                   id+'_ratingBtn_5'],
                                   eventList: {click: this.r.setNumericRating}});
        this.h.removelistenersSet({refList:[fullId],
                                   eventList:{dblclick:{func: this.titleObj.showTitleInfo}}});
        this.h.removelistenersSet({refList:[id + this.tagSurfix],
                                  eventList:{click:{func: this.titleObj.tagTitle}}});
        this.destroyBtnSet(id, this.queueBtns, this.cue);
        if(this.elements[id]){
          this.elements[id] = null;
          delete this.elements[id];
        }
    }catch(error){
      debugger;
    }
  }
  
  btnControlClass.prototype.destroyBtnSet = function(id, set, callbackobj){
    for(var key in set){
      this.destroyBtn(id ,key, set[key].funcName, callbackobj);
    }
  }
  
  btnControlClass.prototype.destroyBtn = function(id, btnName,func, callbackobj){
    try{
   if(this.elements[id]){
    if(this.elements[id][btnName]){
      YAHOO.util.Event.removeListener(id, 'click', callbackobj[func]);
    }
    }
    }catch(error){
      debugger;
    }
  }
  
  
  btnControlClass.prototype.initializeListener = function(id, fullId){
    try{
      var init = false;
      
      if(!this.elements[id]){
        init = true;
      }else if(this.elements[id].destroyed){
        this.elements[id].destroyed = false;
        init = true;
      }
       
      if(init){ 
        this.elements[id] = {'id':id, updateType: 'updateDom'};
        var paramSet = {instanceObj:this.cue, element:this.elements[id] };
        this.initializeBtnSet(id, this.cue, paramSet,this.queueBtns);
         
         var ratingparamSet = {instanceObj:this.r, element:this.elements[id] };
         
         this.h.addlistenersSet({refList:[id+'_ratingBtn_1',
                                          id+'_ratingBtn_2',
                                          id+'_ratingBtn_3',
                                          id+'_ratingBtn_4',
                                          id+'_ratingBtn_5'],
                                  eventList:{click:{func: this.r.setNumericRating,
                                                    param:ratingparamSet}}});
        this.initializeBtnSet(id, this.r, ratingparamSet, this.ratingBtns);
        
        var itemParamSet = {instanceObj:this.titleObj, element:this.elements[id] };
        
         this.h.addlistenersSet({refList:[fullId],
                                  eventList:{dblclick:{func: this.titleObj.showTitleInfo,
                                                    param:itemParamSet}}});
                                                    
         this.h.addlistenersSet({refList:[id + this.tagSurfix],
                                  eventList:{click:{func: this.titleObj.tagTitle,
                                                    param:itemParamSet}}});
      }
    }catch(error){
      debugger;
    }
  }
  
  btnControlClass.prototype.initializeBtnSet = function(id, callbackObj, paramSet, set){
    for(var key in set){
      this.initializeBtn(id,callbackObj,paramSet,set[key],key);
    }
  }
  
  btnControlClass.prototype.initializeBtn = function(id, callbackObj, paramSet, set, key){
    var domref = document.getElementById(id + set.idSurfix);
    if(domref){
      this.h.addlistenersSet({refList:[domref.id],
                               eventList:{click:{func: callbackObj[set.funcName],
                                                 param:paramSet}}});
    }
    this.h.deleteDomElement(domref);
    domref = null;
  }

                                               
                                               
                                               
