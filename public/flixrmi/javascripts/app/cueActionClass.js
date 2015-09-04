function cueActionClass(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
     // this.initialize();
     this.buttons = {}
    }catch(err){
      debugger;
    }
  }
  
  cueActionClass.prototype.constructor = cueActionClass;

  /*------------------------------------------------------------------------------------------------*/

  cueActionClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  cueActionClass.prototype.initialize = function(){
  
  }
  
  cueActionClass.prototype.updateObjects = function(panels,scroll,title, hover){
    this.panelsObj = panels;
    this.scrollObj = scroll;
    this.titleObj  = title;
//    this.hoverObj  = hover;
  }
  
  cueActionClass.prototype.getIdMovieId = function(element){
    var inputMovieId = document.getElementById(element.id + '_movieId');
    var movieId = inputMovieId.value;
    this.h.deleteDomElement(inputMovieId);
    inputMovieId = null;
    return movieId;
  }
  
  
  cueActionClass.prototype.getNumMovieId = function(url){
    var num_id = "";
    if(url){
      var s = url.split('/');
      num_id = s[s.length - 1];
    }
    return num_id;
  }
  
  cueActionClass.prototype.getQueueType = function(element){
    var inputQueueType = document.getElementById(element.id + '_queueType');
    var queueType = inputQueueType.value;
    this.h.deleteDomElement(inputQueueType);
    inputQueueType = null;
    return queueType;
  }
  
  
  cueActionClass.prototype.play = function(eventObj, paramSet){
    paramSet.instanceObj.play_p(eventObj, paramSet.element);
  }
  
  // nflx.openPlayer : function(movieId, xPos, yPos, -, domId)
  
  cueActionClass.prototype.play_p = function(eventObj, element){
    var playerId =  "background_player";
//  this.hoverObj.hideAllToolTips();
    var pos =  YAHOO.util.Dom.getXY(playerId);
    this.h.changeClassName('loading','loading');
 //        YAHOO.util.Dom.setStyle(playerId,'background-color','#000');
    var ret = nflx.openPlayer(this.getNumMovieId(this.getIdMovieId(element)), pos[0], pos[1], 
                    "vpskc7vyw5zk527gkyuykhph", playerId);
 //   this.h.setBGtransparent_p(playerId);
    this.h.changeClassName('loading','ready');
  }
  
  cueActionClass.prototype.addInstant = function(eventObj, paramSet){
    paramSet.instanceObj.addInstant_p(eventObj, paramSet.element);
  }
  
  
  cueActionClass.prototype.addInstant_p = function(eventObj, element){
//    this.hoverObj.hideAllToolTips();

    var sendRequest = this.toggleGraphicControl(eventObj, [{className:'add_instant_queue', 
                                                            title: 'Add Instant Queue',
                                                            flag:false},
                                                           {className:'in_instant_queue', 
                                                            title: 'In Instant Queue',
                                                            flag:false} ]);
    if(sendRequest){
      var connectionSet = {baseUrl: this.addInstantbaseUrl, 
                           instanceObj:this.titleObj,
                           paramSet:element,
                           handleFailure:this.showErrorDisplay, 
                           handleFailureType:'updateDom',
                           handleFailureId: this.errorDiv,
                           handleSuccess:this.titleObj.simlarsReturn,
                           params: {ext_id:this.getIdMovieId(element)}};
      var newSimarsConSet = this.h.concatJson(connectionSet, this.simlarsConnectionSet);
      new connectionClass({elements:{one:newSimarsConSet}});
    }
  }
  
  cueActionClass.prototype.showErrorDisplay = function(eventObj, responseObj){;
    eventObj.instanceObj.showErrorDisplay_p(eventObj,responseObj);
  }
  
  cueActionClass.prototype.showErrorDisplay_p = function(eventObj,responseObj){
    //this.panelsObj.showPanel(this.errorPanel);
    this.h.renderError(this.panelsObj, this.errorPanel, this.errorDiv);
  }
  
  cueActionClass.prototype.addDisc = function(eventObj, paramSet){
    paramSet.instanceObj.addDisc_p(eventObj, paramSet.element);
  }
  
  cueActionClass.prototype.addDisc_p = function(eventObj, element){
//    this.hoverObj.hideAllToolTips();

    var sendRequest = this.toggleGraphicControl(eventObj, [{className:'add_disc_queue', 
                                                            title: 'Add Disc Queue',
                                                            flag:false},
                                                           {className:'in_disc_queue', 
                                                            title: 'In Disc Queue',
                                                            flag:false} ]);
    if(sendRequest){
      var connectionSet = {baseUrl: this.addDiscbaseUrl, 
                           instanceObj:this.titleObj,
                           paramSet:element,
                           handleFailure:this.titleObj.simlarsReturn, 
                           handleSuccess:this.titleObj.simlarsReturn,
                           params: {ext_id:this.getIdMovieId(element)}};
      var newSimarsConSet = this.h.concatJson(connectionSet, this.simlarsConnectionSet);
      new connectionClass({elements:{one:newSimarsConSet}});
    }
  }
  cueActionClass.prototype.saveDisc = function(eventObj, paramSet){
    paramSet.instanceObj.saveDisc_p(eventObj, paramSet.element);
  }
  
  cueActionClass.prototype.saveDisc_p = function(eventObj, element){
//    this.hoverObj.hideAllToolTips();

    var sendRequest = this.toggleGraphicControl(eventObj, [{className:'save_disc_queue', 
                                                            title: 'Save Disc Queue',
                                                            flag:false},
                                                           {className:'in_disc_queue', 
                                                            title: 'In Disc Queue',
                                                            flag:false} ]);
    if(sendRequest){
      var connectionSet = {baseUrl: this.saveDiscbaseUrl, 
                           instanceObj:this.titleObj,
                           paramSet:element,
                           handleFailure:this.titleObj.simlarsReturn, 
                           handleSuccess:this.titleObj.simlarsReturn,
                           params: {ext_id:this.getIdMovieId(element)}};
      var newSimarsConSet = this.h.concatJson(connectionSet, this.simlarsConnectionSet);
      new connectionClass({elements:{one:newSimarsConSet}});
    }
  }
  
  cueActionClass.prototype.deleteItemTitle = function(eventObj, paramSet){
    paramSet.instanceObj.deleteItemTitle_p(eventObj, paramSet.element);
  }
  
  cueActionClass.prototype.deleteItemTitle_p = function(eventObj, element){
//    this.hoverObj.hideAllToolTips();

    var deleteNow = this.toggleGraphicControl(eventObj, [{className:'delete', 
                                                            title: 'Delete',
                                                            flag:true},
                                                         {className:'undoDelete', 
                                                            title: 'Undo Delete',
                                                            flag:true} ]);
    var connectionSet = {instanceObj:this,
                         paramSet:element,
                         handleFailure:this.showErrorDisplay, 
                         handleFailureType:'updateDom',
                         handleFailureId: this.errorDiv,
                         handleSuccess:this.deleteReturn,
                         params: {ext_id:this.getIdMovieId(element), 
                                  queueType:this.getQueueType(element)}};
                         
    if(deleteNow){
      connectionSet.baseUrl = this.deletebaseUrl;
    }else{
      connectionSet.baseUrl = this.undoDeletebaseUrl;
    }
    var deleteItemConSet = this.h.concatJson(connectionSet, this.generalConnectionSet);
    new connectionClass({elements:{one:deleteItemConSet}});
  }
  
  cueActionClass.prototype.deleteReturn = function(eventObj, responseObj){;
    eventObj.instanceObj.deleteReturn_p(eventObj,responseObj);
  }
  
  cueActionClass.prototype.deleteReturn_p = function(element, responseObj){
//  this.hoverObj.hideAllToolTips();
    var statusMsg = this.updateStatus(element, responseObj);
    var domRef = document.getElementById(element.paramSet.id + this.deleteSurfix);
    var undoDeleteSet = {className:'undoDelete', 
                         title: 'Undo Delete',
                         flag:true};
    var deleteSet    =  {className:'delete', 
                         title: 'Delete',
                         flag:true};
      if("Title Added to Queue" !== statusMsg && 
          element.baseUrl == this.undoDeletebaseUrl){
        this.toggleGraphicControl_core(domRef, [undoDeleteSet,deleteSet]);
      }else if("Title deleted from Queue" !== statusMsg  && 
               element.baseUrl == this.deletebaseUrl){
        this.toggleGraphicControl_core(domRef, [deleteSet,undoDeleteSet]);
      }
    
      this.h.deleteDomElement(domRef);
      domRef = null;
  }
  
  cueActionClass.prototype.moveTitleToTop = function(eventObj, paramSet){
    paramSet.instanceObj.moveTitleToTop_p(eventObj, paramSet.element);
  }
  
  cueActionClass.prototype.moveTitleToTop_p = function(eventObj, element){
    var position = this.h.getCurrentListPosition(element.id+this.titleItemSurfix);
    this.moveDomRefToTop(element.id+this.titleItemSurfix);
    this.moveTitle(element.id, 1,position);
  }
  
  cueActionClass.prototype.moveDomRefToTop = function(id){
    var domRef = document.getElementById(id);
    
    if(domRef){
      domRef.parentNode.insertBefore(domRef, domRef.parentNode.firstChild); 
      this.h.setIndexeByClassName(id, 1, 'itemIndex');
    }
    this.h.deleteDomElement(domRef);
    domRef = null;
  }
  
  
  cueActionClass.prototype.moveTitle = function(id,newPosition, oldPosition){
    this.hover.hideAllToolTips();

//    this.hoverObj.hideToolTip(id+this.titleItemSurfix);
    var element = {'id':id, 'oldPosition': oldPosition};
    var params = {ext_id:this.getIdMovieId(element),
                  'position':newPosition, 
                  queueType:this.getQueueType(element)};
    element = this.h.concatJson(element,params);               
    var connectionSet = {baseUrl: this.moveTitlebaseUrl, 
                         instanceObj:this,
                         paramSet: element,
                         handleFailure:this.showErrorDisplay, 
                         handleFailureType:'updateDom',
                         handleFailureId: this.errorDiv,
                         handleSuccess:this.moveReturn,
                         'params':params};
    var newSimarsConSet = this.h.concatJson(connectionSet, this.generalConnectionSet);
    new connectionClass({elements:{one:newSimarsConSet}});
  }
  
  cueActionClass.prototype.moveReturn = function(eventObj, responseObj){;
    eventObj.instanceObj.moveReturn_p(eventObj,responseObj);
  }
  
  cueActionClass.prototype.moveReturn_p = function(element, responseObj){
  this.hover.hideAllToolTips();
    var statusMsg = this.updateStatus(element, responseObj);
    
    if(statusMsg !== "Title Moved"){
//      this.hoverObj.hideToolTip(element.paramSet.id+this.titleItemSurfix);
      this.h.setListNodeToPosition(element.paramSet.id + this.titleItemSurfix,
                                   element.paramSet.oldPosition, 'itemIndex');
    }
    
  }
  
  cueActionClass.prototype.toggleGraphicControl = function(eventObj, set){
    var targetRef = YAHOO.util.Event.getTarget(eventObj);
    ret =  this.toggleGraphicControl_core(targetRef, set);
    this.h.deleteDomElement(targetRef);
    targetRef = null;
    return ret;
  }
  
  cueActionClass.prototype.toggleGraphicControl_core = function(targetRef, set){
    if(targetRef.className == "control-btn"){
      targetRef = targetRef.firstChild;
    } 
    if(targetRef.className == set[0].className){
      targetRef.className = set[1].className;
      targetRef.setAttribute('title',set[1].title);
      ret = true;
    }else{
      if(set[0].flag){
        targetRef.className = set[0].className;
        targetRef.setAttribute('title',set[0].title);
      }
      ret = false;
    }
    this.h.deleteDomElement(targetRef);
    targetRef = null;
    return ret;
  }
  
  cueActionClass.prototype.updateStatus = function(element, responseObj){
    var ret = "";
    var results = this.h.getResultsVariable(responseObj);
    var status = this.h.getResultsDisplay(element, results);
    this.panelsObj.updateStatus_core(status, 'queuePanel');
    if(results){
      if(results.status){
        ret = results.status.message; 
      }
    }
    return ret;
  }
  
