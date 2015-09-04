function mediaPlayerClass(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
      this.initialize();
     this.buttons = {}
     
     
      this.d = new debugClass({createNode:1});
    }catch(err){
      debugger;
    }
  }
  
  mediaPlayerClass.prototype.constructor = mediaPlayerClass;

  /*------------------------------------------------------------------------------------------------*/

  mediaPlayerClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  mediaPlayerClass.prototype.initialize = function(){
    var paramObj = {instanceObj: this};
    YAHOO.util.Event.addListener('lastfmAuth_sumbit', 'click',  this.auth, paramObj);
    YAHOO.util.Event.addListener('lastfmsubmit_tune', 'click', this.getList, paramObj);
    YAHOO.util.Event.addListener('authToggle', 'click', this.authToggle, paramObj);
    YAHOO.util.Event.addListener('lastfm_tune', 'keyup',  this.getListKey, paramObj);
    this.playerInit = true;
    this.currentCount = 0;
    var paramObj = {instanceObj: this};
    YAHOO.MediaPlayer.onAPIReady.subscribe(function(eventObj){
      YAHOO.MediaPlayer.onTrackComplete.subscribe(function(eventObj){
        paramObj.instanceObj.testTrackComplete(eventObj, "onTrackComplete");
      });
      YAHOO.MediaPlayer.onProgress.subscribe(function(eventObj){
        paramObj.instanceObj.testTrackComplete(eventObj, "onProgress");
      });
      YAHOO.MediaPlayer.onTrackStart.subscribe(function(eventObj){
        paramObj.instanceObj.testTrackComplete(eventObj, "onTrackStart");
      });  
     this.playerInit = false;
      paramObj.instanceObj.getList_p()
    });;
    
  }
  
  mediaPlayerClass.prototype.getListKey = function(eventObj, paramSet){
      paramSet.instanceObj.getListKey_p(eventObj, paramSet.element);
  }
  
  mediaPlayerClass.prototype.getListKey_p = function(eventObj, element){
    switch(eventObj.keyCode){
      case 13:
      case 10:
        this.getList_p(eventObj, element);
        break;
      default:
        break;
    }
  }
  
  
  mediaPlayerClass.prototype.getList_C = function(){
    var instanceObj = this;
    return function(obj1,obj2,obj3){
      var n = YAHOO.MediaPlayer.getPlaylistCount();
      var c = YAHOO.MediaPlayer.getPlayerState();
      this.d.output(c+", "+n+", "+obj1+", "+obj2+", "+obj3);
      if(c == 7){
        //instanceObj.getList_p();
      }
    }
  }
  
  mediaPlayerClass.prototype.getList = function(eventObj, paramSet){
    paramSet.instanceObj.getList_p(eventObj, paramSet.element);
  }
  
  mediaPlayerClass.prototype.getList_p = function(eventObj, element){
      var p = {'lastfm[tune]': this.h.getFieldValue('lastfm_tune')};
      var connectionSet = {baseUrl: this.playlistbaseUrl, 
                           instanceObj:this,
                           paramSet:{},
                           handleSuccess:this.listReturn,
                           handleSuccessType:'updateDom',
                           id: this.playListId,
                           params: p};
     // var conSet = this.h.concatJson(connectionSet, this.connectionSet);
      new connectionClass({elements:{one:connectionSet}});
  }
  
  mediaPlayerClass.prototype.listReturn = function(eventObj, responseObj){;
    eventObj.instanceObj.listReturn_p(eventObj,responseObj);
  }
  
  mediaPlayerClass.prototype.listReturn_p = function(element, responseObj){
    var domRef = document.getElementById(this.playListId);
    var emptyPlayList = document.getElementById('emptyPlayList');
    if(domRef.children.length > 0){
      try{
      YAHOO.MediaPlayer.stop();
      }catch(error){
      
      }
      try{
        YAHOO.MediaPlayer.addTracks(emptyPlayList, null, true);
      }catch(error){
      
      }
      try{
        YAHOO.MediaPlayer.addTracks(domRef, null);
      }catch(error){
      
      }
      this.h.deleteDomElement(emptyPlayList);
      emptyPlayList = null;
      this.h.deleteDomElement(domRef);
      domRef = null;

      this.currentCount = YAHOO.MediaPlayer.getPlaylistCount();
      
      try{
      YAHOO.MediaPlayer.play(); 
      }catch(error){
      
      }
    }
    if(!this.playerInit){
      if(1 >= this.currentCount){
        YAHOO.MediaPlayer.setPlayerViewState(0);
        YAHOO.MediaPlayer.setQueueViewState(0);
      }
    }
  }
  
  mediaPlayerClass.prototype.onTrackComplete = function(eventObj, paramSet){
    paramSet.instanceObj.testTrackComplete(eventObj, "onTrackComplete");
  }
  mediaPlayerClass.prototype.onProgress = function(eventObj, paramSet){
    paramSet.instanceObj.testTrackComplete(eventObj, "onProgress");
  }
  mediaPlayerClass.prototype.onTrackStart = function(eventObj, paramSet){
    paramSet.instanceObj.testTrackComplete(eventObj, "onTrackStart");
  }
  
  mediaPlayerClass.prototype.testTrackComplete = function(eventObj, func){
    var n = YAHOO.MediaPlayer.getPlaylistCount();
    var c = YAHOO.MediaPlayer.getPlayerState();
    var i = YAHOO.MediaPlayer.controller.playlistmanager.currentIndex +1;
    var p = YAHOO.MediaPlayer.getTrackPosition();
    var d = YAHOO.MediaPlayer.getTrackDuration();
    if(this.currentCount == (i) && c == 0){
      this.getList_p();
    }
  // this.d.output(c+", "+ i+", "  + func);
  }


  
  mediaPlayerClass.prototype.auth = function(eventObj, paramSet){
    paramSet.instanceObj.auth_p(eventObj, paramSet.element);
  }
  
  mediaPlayerClass.prototype.auth_p = function(eventObj, element){
  
  var params = {'lastfm[user]': this.h.getFieldValue('lastfm_user'),
                'lastfm[pass]': this.h.getFieldValue('lastfm_pass')};
            
    var connectionSet = {instanceObj:this,
                         paramSet:element,
                         baseUrl: this.authbaseUrl,
                         handleFailure:this.showErrorDisplay, 
                         handleFailureType:'updateDom',
                         handleFailureId: this.errorDiv,
                         handleSuccess:this.authReturn,
                         handleSuccessType:'updateDom',
                         id: this.playListId,
                         'params': params};
    new connectionClass({elements:{one:connectionSet}});
  }
  
  mediaPlayerClass.prototype.authReturn = function(eventObj, responseObj){;
    eventObj.instanceObj.authReturn_p(eventObj,responseObj);
  }
  
  mediaPlayerClass.prototype.authReturn_p = function(element, responseObj){
    if("Authenticaed !" == responseObj.responseText){
      this.h.hide(this.authId,'b');
    }
  }
  mediaPlayerClass.prototype.authToggle = function(eventObj, paramSet){
    paramSet.instanceObj.authToggle_p(eventObj, paramSet.element);
  }
  
  mediaPlayerClass.prototype.authToggle_p = function(element, responseObj){
    this.h.toggleShow('authFieldSet','b');
  }
  
  mediaPlayerClass.prototype.updateObjects = function(panels){
    this.panelsObj = panels;
  }
  
  mediaPlayerClass.prototype.getMediaPlayerId = function(){
    var domRef = YAHOO.util.Dom.getElementBy(this.isMediaPlayerNode);
    this.playerId = domRef.id;
    this.h.deleteDomElement(domRef);
    domRef = null;
  }
  
  mediaPlayerClass.prototype.isMediaPlayerNode = function(){
    var ret = false;
    if(YAHOO.util.Dom.getAttribute(this.playerAtt) == this.playerName){
      ret = true;
    }
    return ret;
  }
  
  
  