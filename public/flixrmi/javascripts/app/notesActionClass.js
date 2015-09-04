function notesActionClass(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
      this.initialize();
     this.buttons = {}
    }catch(err){
      debugger;
    }
  }
  
  notesActionClass.prototype.constructor = notesActionClass;

  /*------------------------------------------------------------------------------------------------*/

  notesActionClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  notesActionClass.prototype.initialize = function(){
    var updatePanel = document.getElementById(this.panel + this.viewSurfix)
    updatePanel.innerHTML = this.templateHTML;
    this.h.deleteDomElement(updatePanel);
    updatePanel = null;
    YAHOO.util.Event.addListener(this.entryToggle, 'click', 
                                 this.toggleEntry, {instanceObj:this});
                                 
    YAHOO.util.Event.addListener(this.dToggle, 'click', 
                                 this.toggleDoneItems, {instanceObj:this});
                                 
    YAHOO.util.Event.addListener(this.submit, 'click', 
                                 this.createNote, {instanceObj:this});
    this.getList();
    this.getListTimeOut();
  }
  
  
  notesActionClass.prototype.getListTimeOut = function(){
    this.timeOut = setTimeout(this.getData_C(),this.dataDelay);
  }
  
  notesActionClass.prototype.getData_C = function(){
    var  instanceObj = this;
    return function(){
      instanceObj.getList();
      instanceObj.getListTimeOut();
    }
  }
  
  
  notesActionClass.prototype.toggleEntry = function(eventObj, paramSet){
    paramSet.instanceObj.toggleEntry_p();
  }
  
  notesActionClass.prototype.toggleEntry_p = function(){
    this.h.toggleShow(this.entrySet);
  }
  
  notesActionClass.prototype.toggleDoneItems = function(eventObj, paramSet){
    paramSet.instanceObj.toggleDoneItems_p(eventObj);
  }
  
  notesActionClass.prototype.toggleDoneItems_p = function(eventObj){
    var list = document.getElementById(this.listId);
    if(list.className == this.hideDoneClass){
      list.className = this.showDoneClass;
    }else{
      list.className = this.hideDoneClass;
    }
    this.h.deleteDomElement(list);
    list = null;
  }
  
  notesActionClass.prototype.updateObjects = function(panels,scroll,title){
    this.panelsObj = panels;
    this.scrollObj = scroll;
    this.titleObj  = title;
  }
  
/*------------------------------------------------------------------------------------------------*/ 
    
  notesActionClass.prototype.getList = function(){
      var connectionSet = {baseUrl: this.listNotesUrl, 
                           instanceObj:this,
                           paramSet:{},
                           handleSuccess:this.listAll,
                           params: {}};
     // var conSet = this.h.concatJson(connectionSet, this.connectionSet);
      new connectionClass({elements:{one:connectionSet}});
  }
  
  notesActionClass.prototype.showErrorDisplay = function(eventObj, responseObj){;
    eventObj.instanceObj.showErrorDisplay_p(eventObj,responseObj);
  }
  
  notesActionClass.prototype.showErrorDisplay_p = function(eventObj,responseObj){
    //this.panelsObj.showPanel(this.errorPanel);
    this.h.renderError(this.panelsObj, this.errorPanel, this.errorDiv);
  }
  
  notesActionClass.prototype.listAll = function(eventObj, responseObj){
    eventObj.instanceObj.listAll_p(responseObj);
  }
  
  notesActionClass.prototype.listAll_p = function(responseObj){
    
    var list = document.getElementById(this.listId);
    list.innerHTML = responseObj.responseText;
    this.h.deleteDomElement(list);
    list = null;
    this.initializeHooks();
  }
  
  notesActionClass.prototype.initializeHooks = function(){
    var contianer = document.getElementById(this.listId);
    this.initializing = true;
    if(contianer){
      var list = YAHOO.util.Dom.getElementsByClassName(this.checks,'',contianer);
      for(var i = 0;i<list.length;i++){
        this.initializeListener(this.h.removePrefix(list[i].id),list[i].id);
      }
    }
    this.h.deleteDomElement(contianer);
    contianer = null;
    this.h.deleteDomArray(list);
    list = null;
    this.initializing = false;
  }
  
  notesActionClass.prototype.initializeListener = function(dbID, id){
    YAHOO.util.Event.removeListener(id, 'click', this.doneCheckClick);
    YAHOO.util.Event.removeListener(this.deletePrefix + dbID, 'click', this.destroyClick);
    YAHOO.util.Event.addListener(id, 'click', 
                                 this.doneCheckClick, {instanceObj:this, 
                                                    element:{checkId:id, 
                                                             dbId: dbID}});
    YAHOO.util.Event.addListener(this.deletePrefix + dbID, 'click', 
                                 this.destroyClick, {instanceObj:this, 
                                                    element:{id:this.deletePrefix + dbID, 
                                                             dbId: dbID}});
  }
  
  notesActionClass.prototype.doneCheckClick = function(eventObj, paramSet){
    paramSet.instanceObj.doneCheckClick_p(eventObj, paramSet.element);
  }
  
  notesActionClass.prototype.doneCheckClick_p = function(eventObj, element){
    var noteItem = document.getElementById(this.itemPerfix + element.dbId);
    var doneCheck = document.getElementById(element.checkId);
    if(doneCheck.checked){
      noteItem.className = this.doneItem;
    }else{
      noteItem.className = this.nonDoneItem;
    }
    this.updateNote({'note[done]':doneCheck.checked, id:element.dbId});
    this.h.deleteDomElement(noteItem);
    noteItem = null;
    this.h.deleteDomElement(doneCheck);
    doneCheck = null;
  }
  
  
  notesActionClass.prototype.updateNote = function(att){
      var connectionSet = {baseUrl: this.updateNoteUrl, 
                           instanceObj:this,
                           handleFailure:this.showErrorDisplay, 
                           handleFailureType:'updateDom',
                           handleFailureId: this.errorDiv, 
                           handleSuccess:this.updateStatus,
                           paramSet:{},
                           params: att};
      var conSet = this.h.concatJson(connectionSet, this.connectionSet);
      new connectionClass({elements:{one:conSet}});
  }
  
  notesActionClass.prototype.destroyClick = function(eventObj, paramSet){
    paramSet.instanceObj.destroyClick_p(eventObj, paramSet.element);
  }
  
  notesActionClass.prototype.destroyClick_p = function(eventObj, element){
    var noteItem = document.getElementById(this.itemPerfix + element.dbId);
    noteItem.parentNode.removeChild(noteItem);
    this.h.deleteDomElement(noteItem);
    noteItem = null;
    
    this.destroyNote({id:element.dbId})
  }
  
  notesActionClass.prototype.destroyNote = function(att){
        var connectionSet = {baseUrl: this.destroyNoteUrl, 
                             instanceObj:this,
                             handleFailure:this.showErrorDisplay, 
                             handleFailureType:'updateDom',
                             handleFailureId: this.errorDiv, 
                             handleSuccess:this.updateStatus,
                             paramSet:{},
                             params: att};
        var conSet = this.h.concatJson(connectionSet, this.connectionSet);
        new connectionClass({elements:{one:conSet}});
  }
  
  
  
  notesActionClass.prototype.createNote = function(eventObj, paramSet){
    paramSet.instanceObj.createNote_p(eventObj, paramSet.element);
  }
  
  notesActionClass.prototype.createNote_p = function(eventObj, element){
      var noteHeading = document.getElementById('noteHeading');
      var noteBody = document.getElementById('noteBody');
      
      var p = {'note[body]':noteBody.value,
               'note[heading]':noteHeading.value};
      this.h.deleteDomElement(noteHeading);
    noteHeading = null;
      this.h.deleteDomElement(noteBody);
    noteBody = null;
      
      var connectionSet = {baseUrl: this.createNoteUrl, 
                           instanceObj:this,
                           paramSet:{},
                           handleFailure:this.showErrorDisplay, 
                           handleFailureType:'updateDom',
                           handleFailureId: this.errorDiv, 
                           handleSuccess:this.createReturn,
                           params: p};
      var conSet = this.h.concatJson(connectionSet, this.connectionSet);
      new connectionClass({elements:{one:conSet}});
  }
/*------------------------------------------------------------------------------------------------*/ 
    
  
  notesActionClass.prototype.createReturn = function(eventObj, responseObj){;
    eventObj.instanceObj.createReturn_p(eventObj,responseObj);
  }
  
  notesActionClass.prototype.createReturn_p = function(element, responseObj){
     this.updateStatus_p(element, responseObj);
     this.toggleEntry_p();
     this.getList();
     
     var noteHeading = document.getElementById('noteHeading');
     var noteBody = document.getElementById('noteBody');
     
     noteBody.value = "";
     noteHeading.value = "";
     
     this.h.deleteDomElement(noteHeading);
    noteHeading = null;
     this.h.deleteDomElement(noteBody);
    noteBody = null;
  }
  
  notesActionClass.prototype.updateStatus = function(eventObj, responseObj){
    eventObj.instanceObj.updateStatus_p(eventObj,responseObj);
  }
  
  notesActionClass.prototype.updateStatus_p = function(element, responseObj){
    var results = this.h.getResultsVariable(responseObj);
    this.panelsObj.updateStatus_core(results.status, 'notePanel');
  }
  
  /*------------------------------------------------------------------------------------------------*/ 
    
