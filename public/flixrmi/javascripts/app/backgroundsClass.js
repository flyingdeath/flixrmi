function backgroundsClass(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
     // this.initialize();  
     this.initialize(this.contianerId, this.colorControlClass);
     this.initialize(this.contianerId, this.imageControlClass);
     this.initializeSelectHook(this.selectId);
     this.changebackgroundSet_p({id:this.selectId});
    }catch(err){
      debugger;
    }
  }
  
  backgroundsClass.prototype.constructor = backgroundsClass;

  /*------------------------------------------------------------------------------------------------*/

  backgroundsClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  backgroundsClass.prototype.updateObjects = function(panels){
    this.panelsObj = panels;
  }
  
  backgroundsClass.prototype.initialize = function(contianerId, itemClassName){
    var contianer = document.getElementById(contianerId);
    this.initializing = true;
    if(contianer){
      var list = YAHOO.util.Dom.getElementsByClassName(itemClassName,'',contianer);
      for(var i = 0;i<list.length;i++){
        this.initializeListener(list[i].id,itemClassName);
      }
    }
    this.h.deleteDomElement(contianer);
    contianer = null;
    this.h.deleteDomArray(list);
    list = null;
    this.initializing = false;
  }
  

  
  backgroundsClass.prototype.initializeListener = function(id, className){
    var ParamSet = {instanceObj:this, element:{'id':id, 'className':className }};
    this.h.addlistenersSet({refList:[id], eventList:{click:{func: this.changebackground, param:ParamSet}}});
  }
  
  backgroundsClass.prototype.initializeSelectHook = function(id){
    var ParamSet = {instanceObj:this, element:{'id':id}};
    this.h.addlistenersSet({refList:[id], eventList:{change:{func: this.changebackgroundSet, param:ParamSet}}});
  }
  
  backgroundsClass.prototype.changebackgroundSet = function(eventObj, paramSet){
    paramSet.instanceObj.changebackgroundSet_p(paramSet.element);
  }
  
  backgroundsClass.prototype.changebackgroundSet_p = function(element){
    var selectedId = this.h.getSelectValue(element.id);
    var list = this.h.getSelectOptionsValues(element.id);
    for(var i in list){
      YAHOO.util.Dom.setStyle(list[i], "display",'none');
    }
    YAHOO.util.Dom.setStyle(selectedId, "display",'inline-block');
  }
  
  backgroundsClass.prototype.changebackground = function(eventObj, paramSet){
    paramSet.instanceObj.changebackground_p(paramSet.element);
  }
  
  backgroundsClass.prototype.changebackground_p = function(element){
    var finalvalue = "";
    var color = false;
    var params;
    if(element.className == this.colorControlClass){
      color = true;
      finalvalue =  this.h.removePrefix(element.id)
      YAHOO.util.Dom.setStyle(document.body, "background-image","none")
      YAHOO.util.Dom.setStyle(document.body, "background-color",finalvalue);
      params = {backgroundColor:finalvalue, 'color':color};
    }else{
      var domObj = document.getElementById(element.id);
      var img = domObj.getElementsByTagName('img')[0];
      var thumbfile = img.src;
      var fileName = thumbfile.replace('/'+ this.thumbDirName,'');
      this.h.deleteDomElement(domObj);
      domObj = null;
      this.h.deleteDomElement(img);
      img = null;
      finalvalue = 'url(' +fileName+')';
      YAHOO.util.Dom.setStyle(document.body, "background-image",finalvalue)
      YAHOO.util.Dom.setStyle(document.body, "background-color","none")
      params = {backgroundImage:finalvalue, 'color':color};
    }
    this.mv.updateSessionVarList_p({baseUrl:this.url},params)
    
  }
