  function scrollClass(options){
    try{
      this.h = new helperClass();
      this.initializeOptions(options);
      this.initialize(this.elements);  
      this.dataSet = {};
      //this.d = new debugClass({createNode:1});
      
      
    }catch(err){
      debugger;
    }
  }
  
  scrollClass.prototype.constructor = scrollClass;

  /*------------------------------------------------------------------------------------------------*/

  scrollClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  scrollClass.prototype.initialize = function(elements){
    for(var el in elements){
      this.initializeElement(el,elements[el]);
    }
  }
  
  scrollClass.prototype.initializeElement = function(name,element){
    element.name = name;
    var prefix = this.h.getPrefix(element.name)
    
    element.pageScrollId      = prefix + this.pageSliderSurfix;
    element.pageScrollThumbId = prefix + this.pageSliderThumbSurfix;
   
    element.tt = new YAHOO.widget.Tooltip(element.pageScrollId + "ToolTip",
                                 {text:"Page:[0]",
                                  container:element.pageScrollId,
                                  preventoverlap:true,
                                  hidedelay: this.hidedelay,  
                                  context: [element.pageScrollId]});
    this.createSlider(element);
  // setInterval(this.checkScroll_C(element), this.interval);
   var paramSet = {instanceObj:this, 'element': element};
   YAHOO.util.Event.addListener(element.name, 'mousemove', this.checkScroll, paramSet);
   YAHOO.util.Event.addListener(element.name, 'mouseup', this.checkScroll, paramSet);
   YAHOO.util.Event.addListener(element.name, 'mousewheel', this.checkScroll, paramSet);
   YAHOO.util.Event.addListener(element.name, 'DOMMouseScroll', this.checkScroll, paramSet);
   
  }
  
  
  scrollClass.prototype.restorePageIcon = function(name){
      var prefix = this.h.getPrefix(name)
      var panel = document.getElementById(name);
      var pageIcon = document.getElementById(prefix + this.pageContainerPrefix);
      pageIcon.className =  this.pageClass;
      panel.appendChild(pageIcon);
      panel = null;
      pageContainer = null;
      pageIcon = null;
  }
  
  scrollClass.prototype.maximizePageIcon = function(name){
      var prefix = this.h.getPrefix(name)
      var panel = document.getElementById(name);
      var pageContainer = document.getElementById(this.pageContainer);
      var pageIcon = document.getElementById(prefix + this.pageContainerPrefix);
      pageIcon.className =  this.pageMaxClass;
      pageContainer.appendChild(pageIcon);
      panel = null;
      pageContainer = null;
      pageIcon = null;
  }
  
  scrollClass.prototype.createSlider = function(element){
    //this.pageSliderDims[1] = this.h.getDims(element.name).height;
    this.pageSliderDims[1] = 500;
   // YAHOO.util.Dom.setStyle(element.pageScrollId,'height','500px');
    element.pageScroll = this.creatVertSlider({id:element.pageScrollId, 
                                               thumbId: element.pageScrollThumbId, 
                                               dims: this.pageSliderDims});
    var paramSet = {instanceObj:this, 'element': element};
    element.pageScroll.subscribe("change", this.elementScrolled_virtual, paramSet);
  }
  
  scrollClass.prototype.creatVertSlider = function(options){
    return YAHOO.widget.Slider.getVertSlider(options.id, 
                                             options.thumbId, 
                                             options.dims[0], 
                                             options.dims[1])
  }
  
  scrollClass.prototype.updateSliders = function(){
    var h;
    for(name in this.elements){
      //this.createSlider(this.elements[name]);
      this.pageSliderDims[1] = this.h.getDims(name).height;
  //    this.elements[name].pageScroll.thumb.initSlider(0,0,this.pageSliderDims[0],
  //                                                        this.pageSliderDims[1]);
      this.elements[name].pageScroll.thumb.initDown = this.pageSliderDims[1];
      this.elements[name].pageScroll.initThumb(this.elements[name].pageScroll.thumb);
      this.elements[name].pageScroll.initSlider("vert");
    }
  }
  
  
  
  
  /*------------------------------------------------------------------------------------------------*/
  
  scrollClass.prototype.checkScroll_C = function(element){
    var iInstanceObj = this;
    return function(){
      iInstanceObj.checkElementsScroll_p();
    }
  }
  
  scrollClass.prototype.checkElementsScroll_p = function(){
     for(var el in this.elements){
       this.checkScroll_p(this.elements[el]);
    }
  }
  
  scrollClass.prototype.checkScroll = function(eventObj, paramSet){
    paramSet.instanceObj.checkScroll_p(paramSet.element);
  }
  
  scrollClass.prototype.checkScroll_P = function(id){
    this.checkScroll_p(this.elements[id]);
  }
  
  scrollClass.prototype.elementContentCheck_P = function(id){
    var prefix = this.h.getPrefix(id);
    var name = prefix + this.containerSurfix;
    this.elementContentCheck(this.elements[name]);
  }
  
/*------------------------------------------------------------------------------------------------*/
    
  scrollClass.prototype.elementContentCheck = function(element){
    if(element){
      var mainView = document.getElementById(this.h.getPrefix(element.name) + "_mainView");
      var domRef = document.getElementById(element.name);
      var childLength = 0;
      if(mainView){
        childLength = mainView.children.length;
      }
      mainView = null;

      if(domRef.scrollHeight == domRef.offsetHeight && 
         childLength !== 0 && 
         !element.loading  && 
         !element.finished ){
       // this.autoPage++;
        var r = this.getResults(element.name);
        this.autoPage = r.cp;
        
        element.paramSet.pageScrollFlag = false;
      if(r.t > 1){
      this.autoScroll(element, this.autoPage);
      }
        //this.d.output(element.loading);
      }
      domRef= null;
    }
  }
  
  
/*------------------------------------------------------------------------------------------------*/
    
  
  scrollClass.prototype.checkScroll_p = function(element){
    try{
      var r = this.checkScroll_core(element, element.name);
      
     if(r){
       this.scrollEvent(element);
     }
   
      
      if(!(r)){
        this.elementContentCheck(element);
      }
      
    }catch(error){
      debugger;
    }
  }
  
  scrollClass.prototype.checkScroll_core = function(element, id){
    var s = this.readScrollValues(id);
    var fireScrollEvent = false;
    if(s){
    
      if(!element[id]){
        element[id] = {};
      }
      
      if(element[id].oldTop !== undefined){
        if(element[id].oldTop !== s.top){
          fireScrollEvent = true;
        }
      }
      element[id].oldTop = s.top;
      
      if(element[id].oldLeft !== undefined){
        if(element[id].oldLeft !== s.left){
          fireScrollEvent = true;
        }
      }
      
      element[id].oldLeft = s.left;
      
    }
    return fireScrollEvent;
  }
  
  
/*------------------------------------------------------------------------------------------------*/
  
  scrollClass.prototype.readScrollValues = function(id){
    var domRef = document.getElementById(id);
    if(domRef){
    
      var set = {top          : domRef.scrollTop,
                 height       : domRef.offsetHeight,
                 scrollHeight : domRef.scrollHeight,
                 left         : domRef.scrollLeft,
                 width        : domRef.offsetWidth,
                 scrollWidth  : domRef.scrollWidth};
      
      set.offsetScroll    = (set.height + set.top);
      set.hozOffsetScroll = (set.width + set.left);
      
      if(set.top){
        set.ratio = (set.offsetScroll/set.scrollHeight );
      }else{
        set.ratio = 0
      }
      
      if(set.left){
        set.hozratio = (set.hozOffsetScroll/set.scrollWidth);
      }else{
        set.hozratio = 0
      }
    }
    domRef     = null;
    
    return set;
    
  }
/*------------------------------------------------------------------------------------------------*/
  
  scrollClass.prototype.setScrollTop = function(id,v){
    var domRef = document.getElementById(id);
    if(domRef){
      domRef.scrollTop = v;
    }
    domRef     = null;
  }
  
/*------------------------------------------------------------------------------------------------*/
  
  scrollClass.prototype.elementScrolled_virtual = function(value, paramSet){
    paramSet.instanceObj.elementScrolled_virtual_p(this, value,paramSet.element);
  }
  
  scrollClass.prototype.elementScrolled_virtual_p = function(slider, value, el){
    var element = this.elements[el.name];
    
    var results   = this.getResults(element.name);
    var vs   = {ratio:(value/this.pageSliderDims[1]), value:value};
    vs.page = Math.floor(vs.ratio * results.t); 
    var msgp = "Page:["+vs.page+"]";
              
    element.tt.cfg.setProperty("text", msgp);
    element.tt.render();
    element.tt.forceContainerRedraw();
    element.tt.show();
    element.vData = vs;
    
    if(!element.loading){
      this.timedUpdate(element);
    }
                
  }
  
/*------------------------------------------------------------------------------------------------*/
  
  scrollClass.prototype.timedUpdate = function(element){
    if(this.viewportUpdateTimer){
      clearTimeout(this.viewportUpdateTimer);
    }
    this.viewportUpdateTimer = setTimeout(this.timedUpdate_c(element),this.delay); 
  }
  
  /*------------------------------------------------------------------------------------------------*/
  /* view Class */
  
  scrollClass.prototype.timedUpdate_c = function(element){
    var iElement = element;
    var instanceObj = this;
    return function(){
        instanceObj.virtualScrollEvent_p(iElement);
    }
  }
/*------------------------------------------------------------------------------------------------*/
  
  
  scrollClass.prototype.virtualScrollEvent_p = function(element){
  
    element.paramSet.pageScrollFlag = true;
  this.setElementFinished(element.paramSet.conatinerId, false);
    this.setScrollTop(element.name, 0);
    this.autoScroll(element, element.vData.page);
  }
  
  scrollClass.prototype.scrollEvent = function(element){
      
    var rData = this.readScrollValues(element.name);
    var vH = YAHOO.util.Dom.getViewportHeight();
    var go = Boolean((rData.scrollHeight - rData.offsetScroll) <= vH); //this.scrollOffset
    if(go && !element.loading && !element.finished){
      var r = this.getResults(element.name);
      this.autoPage = r.cp;
      element.paramSet.pageScrollFlag = false;
      if(r.t > 1){
      this.autoScroll(element, this.autoPage);
    }
    }
  }
  
  scrollClass.prototype.autoScroll = function(element, page){
    if(!isNaN(parseInt(page)) && !element.loading){
    //  var index    = this.data.getPageIndex(element.name, page);
   //   var domId    = this.data.getId(element.name, index);
     // if(domId){
      //  var pagebgId = this.h.removeSurfix(domId) + this.bgSurfix;
        element.paramSet.newPage = page;
    //    element.paramSet.domId = domId;
        element.paramSet.bgSurfix = this.bgSurfix;
    //    if(this.data.rFlag(element.name, page)){
    //      this.h.colorAnimation({obj:pagebgId, reg:true, seconds:3, 
    //                             eColorBG: 'rgb(34,34,34)', 
    //                             sColorBG: 'rgb(255,255,255)', 
    //                             fColorBG: 'rgba(34,34,34,0.85)'});
    //      YAHOO.util.AnimMgr.start();
          element.loading = true;
          element.fn(element);
    //    }
    //  }
    }
  }
  
  
/*------------------------------------------------------------------------------------------------*/

  scrollClass.prototype.setControlFlags = function(element,results){
    if(results){
      var resultsLegnth = 0;
      if(element.paramSet.conatinerId){
        this.setElementLoad(element.paramSet.conatinerId, false);
        if(results.details){
          if(results.details.number_of_results){
            resultsLegnth = 1;
            if((parseInt(results.details.start_index) + 
                parseInt(results.details.results_per_page)) >= 
                parseInt(results.details.number_of_results)){
                  this.setElementFinished(element.paramSet.conatinerId, true);
            }
          }
        }
        if(!resultsLegnth){
          resultsLegnth = results.titlesLength;
          if(resultsLegnth == 0){
            this.setElementFinished(element.paramSet.conatinerId, true);
          }
        }
        
      }else{
         var conatinerId = this.h.getPrefix(element.id) + this.containerSurfix;
         this.setElementFinished(conatinerId, false);
      }
      this.initializeVirtualScroll(element,results);
    }
  }
/*------------------------------------------------------------------------------------------------*/
   
  scrollClass.prototype.initializeVirtualScroll = function(element, results){
    var prefix = this.h.getPrefix(element.id);
    var name = prefix + this.containerSurfix;
    if(!element.paramSet.conatinerId){
        this.autoPage = 0;
    }
    this.dataSet[name] = {'results': results};
      
    this.elementContentCheck(this.elements[name]);
  }
/*------------------------------------------------------------------------------------------------*/
  
  
  scrollClass.prototype.setElementLoad = function(key, v){
    if(this.elements[key]){
      this.elements[key].loading = v;
    }
  }
/*------------------------------------------------------------------------------------------------*/
  
  scrollClass.prototype.setElementFinished = function(key, v){
    if(this.elements[key]){
      this.elements[key].finished = v;
      if(!v){
        this.resetScroll(key);
        this.setElementLoad(key, false);
      }
    }
  }
/*------------------------------------------------------------------------------------------------*/
    
  scrollClass.prototype.resetScroll = function(name){
    var domRef = document.getElementById(name);
    if(domRef){
      domRef.scrollTop = 0;
     }
     domRef = null;
    
  }
  
  scrollClass.prototype.getResults = function(contianerId){
    return this.h.getResults_p(this.dataSet[contianerId].results);
  }
  
  
  
  /*------------------------------------------------------------------------------------------------*/
  