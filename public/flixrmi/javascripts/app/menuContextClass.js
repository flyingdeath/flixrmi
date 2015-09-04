
  function menuContextClass(options){
    try{
      this.h = new helperClass();
      this.m = new menuClass();
      this.initializeOptions(options);
    }catch(err){
      debugger;
    }
  }
  
  menuContextClass.prototype.constructor = menuContextClass;

  /*------------------------------------------------------------------------------------------------*/

  menuContextClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  menuContextClass.prototype.getListControlOptions = function(focused){
  
    var connectionSet = {baseUrl: this.optionSet.controlOptionsBaseUrl, 
                         instanceObj:this,
                         handleFailure:this.controlOptionsReturn, 
                         handleSuccess:this.controlOptionsReturn,
                         params: {panelName:focused}};
    new connectionClass({elements:{one:connectionSet}});
  }
  
  
  menuContextClass.prototype.controlOptionsReturn = function(eventObj, responseObj){;
    eventObj.instanceObj.controlOptionsReturn_p(eventObj,responseObj);
  }
  
  menuContextClass.prototype.controlOptionsReturn_p = function(element, responseObj){
    var RatingType, FormatType, options = this.optionSet;
    var panelControlOptions;
    if(responseObj.responseText){
       panelControlOptions = eval("("+responseObj.responseText+")");
    }
    try{
    
      if(panelControlOptions){
      
        this.envelopOptions(panelControlOptions, options.Envelops)
        
        this.setMenu(panelControlOptions, options.viewMenu, options.viewTypes);
        
        this.setMenu(panelControlOptions, options.limitMenu, options.limit);
        
        if(panelControlOptions['Sort']){
          sort = panelControlOptions['Sort']
          
          RatingType = panelControlOptions['filterSet']['rating']['FliterRatingType'];
          
          if(panelControlOptions['filterSet']['formatType']){;
            FormatType = panelControlOptions['filterSet']['formatType']['FormatType'];
          }
          
          if(!FormatType){
              FormatType = 'All';
          }
          this.m.setIndexedCheckMenuItem(options.sortValues[sort][0], 
                                         options.sortSet[options.sortValues[sort][0]][sort]);
                                         
          this.m.clearChecksMenu(options.sortValues[sort][1]);
          
          this.m.setIndexedCheckMenuItem(options.formatMenu, 
                                         options.filterSet[options.formatMenu][FormatType]);
                                         
          this.m.setIndexedCheckMenuItem(options.ratingMenu, 
                                         options.filterSet[options.ratingMenu][RatingType]);
                                         
                                         
          this.fliterSliderSet(panelControlOptions, options.sliders, this.slidersObj);
          
          this.fliterSliderSet(panelControlOptions, options.filterSliders, this.filterSlidersObj);
          
         var map = {Rating_Type : RatingType,
                    Format      : FormatType,
                    Sort        : sort,
                    Limit       : panelControlOptions['limit']};
          
          
          this.setSelectBoxes(map, options.selects, options.selectsurfix);
          
          
        }
      }
    }catch(er){
      debugger;
    }
  }
  
  menuContextClass.prototype.setSelectBoxes = function(map, selectList, surfix){
    for(var i in selectList){
      this.h.setSelectValue(i+surfix, selectList[i].indexOf(map[i]));
    }
  }
  
  menuContextClass.prototype.setMenu = function(options, menus, index){
    for(var i in menus){
      this.m.setIndexedCheckMenuItem(i, index[options[menus[i]]]);
    }
  }
  
  menuContextClass.prototype.envelopOptions = function(options, envelops){
    for(var e in envelops){
      this.m.setCheckItemById(e,eval(options[envelops[e]]));
    }
  }
  
  menuContextClass.prototype.fliterSliderSet = function(options, sliders, slidersObj){
    for(silderKey in sliders){
      if(options['filterSet'][sliders[silderKey]]){
        slidersObj.setSliderValue(silderKey, [options['filterSet'][sliders[silderKey]]['AtLeast'],
                                                   options['filterSet'][sliders[silderKey]]['AtMost']]);
      }else{ 
        slidersObj.resetSliderValue(silderKey);
      } 
    }
  }
  
  
  