function delegateListClass(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
      this.initialize(this.options.panelIds);

    }catch(err){
      debugger;
    }
  }
  
  delegateListClass.prototype.constructor = delegateListClass;

  /*------------------------------------------------------------------------------------------------*/

  delegateListClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  delegateListClass.prototype.updateObjects = function(panels){
    this.panelsObj = panels;
  }
  
  delegateListClass.prototype.initialize = function(panelIds){
    for(var name in panelIds){
      var panelId = name + this.options.subContainerSufix;
      this.initializeOne(name);
    }
  }
  /*------------------------------------------------------------------------------------------------*/

  delegateListClass.prototype.initializeOne = function(panelId){  
      var paramSet = {instanceObj: this}
      YAHOO.util.Event.addListener(panelId, "click",     this.delegateClick, paramSet);
      YAHOO.util.Event.addListener(panelId, "dblclick",  this.delegateDblclick, paramSet);
      YAHOO.util.Event.addListener(panelId, "mouseover", this.delegateMouseover, paramSet);
      YAHOO.util.Event.addListener(panelId, "mouseout",  this.delegateMouseout, paramSet);
      YAHOO.util.Event.addListener(panelId, "mousemove", this.delegateMousemove, paramSet);
  }
  
  delegateListClass.prototype.delegateClick = function(eventObj, paramSet){
    paramSet.instanceObj.delegateClick_p(eventObj);
  }
  
  delegateListClass.prototype.delegateClick_p = function(eventObj){
      var node = YAHOO.util.Event.getTarget(eventObj);
      var eventHit = false;
      var className = node.className;
      var id = node.parentNode.id.replace("_"+node.className,'');
      var element = {'id':id, updateType: 'updateDom'};
      this.scrollObj.stopAutoScroll();
      switch("_" + node.className){
        case this.btnSet.queueBtns.play.idSurfix:
          this.iSet.cue.play_p(eventObj, element );
          eventHit = true;
          break;
        case this.btnSet.queueBtns.saveDiscQueue.idSurfix:
          this.iSet.cue.saveDisc_p(eventObj, element );
          eventHit = true;
          break;
        case this.btnSet.queueBtns.addDiscQueue.idSurfix:
          this.iSet.cue.addDisc_p(eventObj, element );
          eventHit = true;
          break;
        case this.btnSet.queueBtns.undoDeleteTitle.idSurfix:
          id = node.parentNode.id.replace(this.btnSet.queueBtns.undoDeleteTitle.alt,'');
          element = {'id':id, updateType: 'updateDom'};
          this.iSet.cue.deleteItemTitle_p(eventObj, element );
          eventHit = true;
          break;
        case this.btnSet.queueBtns.deleteTitle.idSurfix:
          this.iSet.cue.deleteItemTitle_p(eventObj, element );
          eventHit = true;
          break;
        case this.btnSet.queueBtns.moveTitle.idSurfix:
          this.iSet.cue.moveTitleToTop_p(eventObj, element );
          eventHit = true;
          break;
        case this.btnSet.queueBtns.addInstantQueue.idSurfix:
          this.iSet.cue.addInstant_p(eventObj,  element);
          eventHit = true;
          break;
      }
      
      if(!eventHit){
        var n = node.title;
        switch(node.className){
          case this.btnSet.ratingBtns[0]:
          case this.btnSet.ratingBtns[1]:
          case this.btnSet.ratingBtns[4]:
            eventHit = true;
            this.iSet.rating.setNumericRating_p(eventObj, 
              {'id':node.id.replace(this.btnSet.ratingPerfix + n,""),
                updateType: 'updateDom'});
            break;
          case this.btnSet.ratingBtns[2]:
          case this.btnSet.ratingBtns[3]:
            eventHit = true; 
            var sID = node.parentNode.id.replace("_"+node.title,'');
            this.iSet.rating.setStrRating_p(eventObj, {'id':sID, updateType: 'updateDom'});
            break;
         }
      }
      if(!eventHit){
        var element_link = {'id':this.h.getPrefix(node.id), updateType: 'updateDom', 'fullId':node.id};

        switch(node.className){
          case this.linkSet.itemClassName:
            this.iSet.item.showPersonInfo_p(eventObj, element_link)
            break;
          case this.linkSet.searchClassName:
            this.iSet.item.showFullSearch_p(element_link)
            break;
          case this.linkSet.epsClassName:
            this.iSet.item.showTitleInfo_p(element_link)
            break;
        }
        
        if(!eventHit && node.id.indexOf(this.btnSet.tagSurfix) !== -1){
          id = node.id.replace("_"+node.className,'');
          this.iSet.item.tagTitle_p(eventObj,  {'id':id, updateType: 'updateDom' });
          eventHit = true;
        }
        
      }
      
      this.h.deleteDomElement(node);
      node = null;

  }
  /*------------------------------------------------------------------------------------------------*/
  
  delegateListClass.prototype.delegateDblclick = function(eventObj, paramSet){
    paramSet.instanceObj.delegateDblclick_p(eventObj);
  }
  
  delegateListClass.prototype.delegateDblclick_p = function(eventObj){
      var node = YAHOO.util.Event.getTarget(eventObj);
      var domRef = YAHOO.util.Dom.getAncestorByClassName(node, this.btnSet.itemShow);

      if(domRef){
        this.iSet.item.showTitleInfo_p({id:domRef.id, updateType: 'updateDom'})
      }
      
      this.h.deleteDomElement(node);
      this.h.deleteDomElement(domRef);
      domRef = null;
      node = null;
  
  }
  /*------------------------------------------------------------------------------------------------*/
  delegateListClass.prototype.delegateMouseover = function(eventObj, paramSet){
    paramSet.instanceObj.delegateMouseover_p(eventObj);
  }
  
  delegateListClass.prototype.delegateMouseover_p = function(eventObj){
      var node = YAHOO.util.Event.getTarget(eventObj);
      var domRef = YAHOO.util.Dom.getAncestorByClassName(node, this.btnSet.itemShow);

      if(domRef){
        var element = this.iSet.hover.initializeListener(domRef.id, this.hoverSet.innerSurfix);
        this.iSet.hover.mouseOverEvent_p(eventObj, element);

      }
      
      this.h.deleteDomElement(node);
      this.h.deleteDomElement(domRef);
      domRef = null;
      node = null;
  
  }
  /*------------------------------------------------------------------------------------------------*/
  delegateListClass.prototype.delegateMouseout = function(eventObj, paramSet){
    paramSet.instanceObj.delegateMouseout_p(eventObj);
  }
  
  delegateListClass.prototype.delegateMouseout_p = function(eventObj){
      var node = YAHOO.util.Event.getTarget(eventObj);
      
      var domRef = YAHOO.util.Dom.getAncestorByClassName(node, this.btnSet.itemShow);

      if(domRef){
        var element = this.iSet.hover.initializeListener(domRef.id, this.hoverSet.innerSurfix);
        this.iSet.hover.mouseOutEvent_p(eventObj, element);
      }
      
      
      this.h.deleteDomElement(node);
      this.h.deleteDomElement(domRef);
      domRef = null;
      node = null;
  
  }
  /*------------------------------------------------------------------------------------------------*/
  delegateListClass.prototype.delegateMousemove = function(eventObj, paramSet){
    paramSet.instanceObj.delegateMousemove_p(eventObj);
  }
  
  delegateListClass.prototype.delegateMousemove_p = function(eventObj){
      var node = YAHOO.util.Event.getTarget(eventObj);
      var id;
      
      var domRef = YAHOO.util.Dom.getAncestorByClassName(node, this.btnSet.itemShow);

      if(domRef){
         id = domRef.id
      }
      
      this.h.deleteDomElement(node);
      this.h.deleteDomElement(domRef);
      
      domRef = null;
      node = null;
      
      if(id){
        var element = this.iSet.hover.initializeListener(id, this.hoverSet.innerSurfix);
        this.animate(eventObj, element);
      }
  }
  
  delegateListClass.prototype.animate = function(eventObj, element){
    requestAnimationFrame(this.nextFrame(eventObj, element)); 
  }
  
  delegateListClass.prototype.nextFrame = function(eventObj, element){
    var instanceObj = this, iEventObj = eventObj,iElement = element;
    return function(){
      instanceObj.iSet.hover.contextTriggerEvent_p(iEventObj, iElement);
    }
  }
  /*------------------------------------------------------------------------------------------------*/