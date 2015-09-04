  function slidersClass(options){
    this.elements = options.elements;
    this.mv = options.mv;
    this.initialize(this.elements);
    if(options.containerSurfix){
      new helperClass().hideCollection( options.containerSurfix, this.elements, "v");
    }
  }
  
  slidersClass.prototype.constructor = slidersClass;

  /*------------------------------------------------------------------------------------------------*/

  slidersClass.prototype.initialize = function(elements){
    for(var el in elements){
      this.initializeElement(el,elements[el]);
    }
  }


  slidersClass.prototype.initializeElement = function(name,element){
    switch(element.type){
      case 'daul':
        var slider = YAHOO.widget.Slider.getHorizDualSlider(name + "_bg",
                                                            name + "_min_thumb", 
                                                            name + "_max_thumb",
                                                            element.dRange, 
                                                            element.dTickSize);
        slider.maxSlider.animate = false;
        slider.minSlider.animate = false;
        break;
      case 'horiz': 
        var slider = YAHOO.widget.Slider.getHorizSlider(name + "_bg",
                                           name + "_thumb", 
                                           element.dRange[0], 
                                           element.dRange[1], 
                                           element.dTickSize)
        break;
      case 'Vert':
        var slider = YAHOO.widget.Slider.getVertSlider(name + "_bg",
                                           name + "_thumb", 
                                           element.dRange[0], 
                                           element.dRange[1], 
                                           element.dTickSize)
        break;
    }
    
    if(element.initValue){
      slider.setValue(element.initValue, true, true, true);
    }
    
    slider.initSet = element;
    slider.initName = name;
    element.name = name;
    element.slider = slider;
    
    
    if(slider.initSet.callback){
      slider.initSet.callback.fn              = eval((slider.initSet.callback.fn));
      slider.initSet.callback.obj.instanceObj = eval((slider.initSet.callback.obj.instanceObj));
      YAHOO.util.Event.addListener(name + "_goBtn", "click", 
                                    slider.initSet.callback.fn, 
                                    slider.initSet.callback.obj);
    }
    
    var paramSet = {instanceObj:this,'element':element};
    YAHOO.util.Event.addListener(name + "_close", "click", 
                                  this.closePanel, 
                                  paramSet);
                                  
   // element.closeButton = new YAHOO.widget.Button(name + "_yui_close", 
   //                               { onclick: { fn: this.closePanel, 
   //                                            obj: paramSet } });
            
    if(element.type == 'daul'){
      // Subscribe to the slider's change event to report the status.
      slider.subscribe('change', this.report, paramSet);
      //slider.subscribe('change', this.debuggSlider, paramSet);
      this.report_p(slider, element,'initializing');
    }else{
      slider.subscribe('change', slider.initSet.callback.fn, slider.initSet.callback.obj);
    }
    
  }
  
  slidersClass.prototype.debuggSlider = function(sliderObj, paramSet){
    paramSet.instanceObj.debuggSlider_p(sliderObj,paramSet.element);
  
  }
  
  slidersClass.prototype.debuggSlider_p = function(sliderObj, paramSet){
     // this.d.output("("+ String(element.offSetHeight) + "," + String(element.scrollHeight) + ")")
  }
      
  /*------------------------------------------------------------------------------------------------*/

  slidersClass.prototype.resetSliderValue = function(name){
    try{
      var element = this.elements[name];
      element.scriptChange = true;
      element.slider.setMinValue(0, true, false, true);
      element.slider.setMaxValue(element.dRange, true, false, true);
    }catch(err){
      debugger;
    }
  }
  
  slidersClass.prototype.getSliderValuePrimtive = function(name){
    try{
      var element = this.elements[name]
      var ret = [element.slider.maxVal,
                 element.slider.minVal];
    return ret;
    
    }catch(err){
      debugger;
    }
  }
  
  slidersClass.prototype.getSliderValue = function(name, values){
    var slider = this.elements[name].slider;
    var t = slider.initSet.dTickSize;
    var currentValues = this.getSliderOutput(slider,[slider.minVal/t, slider.maxVal/t]);
    return currentValues.intValues;
  }
  
  slidersClass.prototype.setSliderValue = function(name, values){
    try{
      var element = this.elements[name];
      element.scriptChange = true;
      var numValues = [0,0];

      numValues[0] = this.getNumericValue(element,values[0]);
      numValues[1] = this.getNumericValue(element,values[1]);

      if(numValues[0]){
        element.slider.setMinValue(numValues[0], true, false, true);
      }

      if( numValues[1]){
        element.slider.setMaxValue(numValues[1], true, false, true);
      }
    
    }catch(err){
      debugger;
    }
  }
  
  
  slidersClass.prototype.getNumericValue = function(element, value){
    if(value){
      if(element.outputOffSet){
        return  Math.ceil((value - element.outputOffSet) * element.dTickSize);
      }else{
        return this.getLabelNumericValue(element.ouputLabels, value) * element.dTickSize;
      }
    }else{
      return value;
    }
  }
  
  slidersClass.prototype.getLabelNumericValue = function(labels, value){
    var index = labels.indexOf(value);
    if(index !== -1){
      return index;
    }else{
      return 0;
    }
  }
  
  slidersClass.prototype.report = function(sliderObj, paramSet){
    paramSet.instanceObj.report_p(sliderObj,paramSet.element);
  }
  
  slidersClass.prototype.closePanel = function(eventObj, paramSet){
    paramSet.instanceObj.closePanel_p(eventObj,paramSet.element);
  }
  
  slidersClass.prototype.closePanel_p = function(eventObj, element){
    new helperClass().hide(element.name+'_sliderContainer','v');
  }
        
  slidersClass.prototype.report_p = function(slider, element, initFlag){
      var t = slider.initSet.dTickSize;
      var currentValues = this.getSliderOutput(slider,[slider.minVal/t, slider.maxVal/t]);
      
      var reportSpan    = YAHOO.util.Dom.get(slider.initName + "_rangeOutput");
      reportSpan.innerHTML = currentValues.output;
      new helperClass().deleteDomElement(reportSpan);
      reportSpan = null;
      
     if(slider.initSet.callback){
     slider.initSet.callback.obj.currentValues = currentValues;
     //  slider.initSet.callback.fn(currentValues, slider.initSet.callback.obj);
       if(!initFlag && !element.scriptChange){
         this.timedUpdate(slider);
       }
       element.scriptChange = false;
     }
  }
  
  slidersClass.prototype.timedUpdate = function(element){
    if(this.viewportUpdateTimer){
      clearTimeout(this.viewportUpdateTimer);
    }
    this.viewportUpdateTimer = setTimeout(this.timedUpdate_c(element),1000); 
  }
  
  /*------------------------------------------------------------------------------------------------*/
  /* view Class */
  
  slidersClass.prototype.timedUpdate_c = function(slider){
    var islider = slider;
    var instanceObj = this;
    return function(){
        islider.initSet.callback.fn(null, islider.initSet.callback.obj);
    }
  }
  
  
  /*------------------------------------------------------------------------------------------------*/
  
  slidersClass.prototype.getSliderOutput = function(slider, newRange) {
    var newOutputSet;
    if(slider.initSet.outputOffSet){
       newOutputSet = this.getOffSets(slider.initSet.outputOffSet, newRange);
    }else if(slider.initSet.ouputLabels){
       newOutputSet = this.getLabels(slider.initSet.ouputLabels, newRange);
    }
    return {output: newOutputSet[0] + ' - ' +  newOutputSet[1], 
            values:newRange, 
            intValues:newOutputSet};
  };
  
  slidersClass.prototype.getLabels = function(LabelSet, values){
    return this.genOuput(this.getLabel,LabelSet, values);
  }
  
  slidersClass.prototype.getOffSets = function(OffSet, values){
    return this.genOuput(this.getOffSet,OffSet, values);
  }
    
  /*------------------------------------------------------------------------------------------------*/
  
  slidersClass.prototype.genOuput = function(func, param, values){
    var ret = [];
    for(var x = 0;x <values.length;x++){
      ret[x] = func(param, values[x])
    }
    return ret;
  }
  
  slidersClass.prototype.getLabel = function(LabelSet, v){
    return LabelSet[Math.ceil(v)];
  };

  
  slidersClass.prototype.getOffSet = function(OffSet, v){
    return Math.ceil(OffSet + v);
  };
  
       
    
  /*------------------------------------------------------------------------------------------------*/    
