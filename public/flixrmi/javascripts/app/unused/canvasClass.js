
function canvasClass(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
      this.initialize();
    }catch(err){
      debugger;
    }
  }
  
  canvasClass.prototype.constructor = canvasClass;

  /*------------------------------------------------------------------------------------------------*/

  canvasClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  canvasClass.prototype.destroy = function(){
    this.h.deleteDomElement(this.context);
    this.h.deleteDomElement(this.canvas);
    this.context = null;
    this.canvas = null;
  }
  
  canvasClass.prototype.initialize = function(){
  
    if(!this.id){
      this.id = YAHOO.util.Dom.generateId();
    }
    
    this.h.createAppendDomObject(this.h.createHookObj(),'canvas',
                                {id:this.id});
                                
    
    if(this.hide){
      YAHOO.util.Dom.setStyle(this.id,"position",'absolute');
      this.h.hide(this.id, 'v');
    }
    
    YAHOO.util.Dom.setStyle(this.id,"height",this.height);
    YAHOO.util.Dom.setStyle(this.id,"width",this.width);
  }
  
  canvasClass.prototype.getContext = function(){
    var canvas = document.getElementById(this.id)
    var ret = canvas.getContext('2d'); 
    this.h.deleteDomElement(canvas);
    canvas = null;
    return ret;
  }
  
  canvasClass.prototype.getImageData_src = function(path, paramSet){
    var img = this.h.createDomObject('img', {id:YAHOO.util.Dom.generateId()});
    YAHOO.util.Event.addListener(img, 'load', this.getImageData, 
                                {instanceObj: this, element:paramSet});
    img.src = path;
   }
  
  canvasClass.prototype.getImageData = function(eventObj, paramSet){
    paramSet.instanceObj.getImageData_p(eventObj, paramSet.element);
  }

  canvasClass.prototype.getImageData_p = function(eventObj, paramSet){
      var img = YAHOO.util.Event.getTarget(eventObj);
      var context = this.getContext();
      context.drawImage(img, 0, 0, this.width, this.height);
      try{
        var imageData = context.getImageData(0, 0, this.width, this.height);
      }catch(error){
        try{
          netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
          var imageData = context.getImageData(0, 0, this.width, this.height);
        }catch(error){
          debugger;
        }
        debugger;
      }
      var data = imageData.data;
      this.h.deleteDomElement(img);
      this.h.deleteDomElement(context);
      this.h.deleteDomElement(imageData);
      imageData = null;
      context = null;
      img = null;

      if(paramSet.callBack){
        paramSet.callBack(data, paramSet);
      }
  }
  