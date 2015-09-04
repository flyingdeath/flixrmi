function ratingActionClass(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
     // this.initialize();  
    }catch(err){
      debugger;
    }
  }
  
  ratingActionClass.prototype.constructor = ratingActionClass;

  /*------------------------------------------------------------------------------------------------*/

  ratingActionClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  ratingActionClass.prototype.initialize = function(){
    
  }
  
  ratingActionClass.prototype.getIdMovieId = function(element){
    var inputMovieId = document.getElementById(element.id + '_movieId');
    var movieId = inputMovieId.value;
    this.h.deleteDomElement(inputMovieId);
    inputMovieId = null;
    return movieId;
  }
  
  ratingActionClass.prototype.setNumericRating = function(eventObj, paramSet){
    paramSet.instanceObj.setNumericRating_p(eventObj, paramSet.element);
  }
  
  ratingActionClass.prototype.setNumericRating_p = function(eventObj, element){
    var targetRef = YAHOO.util.Event.getTarget(eventObj);
    var ratingIdSet = targetRef.id.split('_');
    var rating = ratingIdSet[ratingIdSet.length -1];
    element.rating = rating;
    this.h.deleteDomElement(targetRef);
    targetRef = null;
    this.sendRating_p(rating, element);
  }
  
  ratingActionClass.prototype.setStrRating = function(eventObj, paramSet){
    paramSet.instanceObj.setStrRating_p(eventObj, paramSet.element);
  }
  
  ratingActionClass.prototype.setStrRating_p = function(eventObj, element){
    var targetRef = YAHOO.util.Event.getTarget(eventObj);
    var rating = targetRef.title;
    element.rating = rating;
    this.h.deleteDomElement(targetRef);
    targetRef = null;
    this.sendRating_p(rating, element);
  }
  
  
  ratingActionClass.prototype.sendRating_p = function(rating, element){
    this.h.changeClassName(element.id + this.msgSurfix, this.msgOnClass);
    var connectionSet = {baseUrl: this.setbaseUrl, 
                         instanceObj:this,
                         paramSet:element,
                         handleFailure:this.showErrorDisplay, 
                         handleFailureType:'updateDom',
                         handleFailureId: this.errorDiv,
                         handleSuccess:this.dataReturn,
                         params: {ext_id:this.getIdMovieId(element),'rating':rating}};
    new connectionClass({elements:{one:connectionSet}});
  }
  
  ratingActionClass.prototype.showErrorDisplay = function(eventObj, responseObj){;
    eventObj.instanceObj.showErrorDisplay_p(eventObj,responseObj);
  }
  
  ratingActionClass.prototype.showErrorDisplay_p = function(eventObj,responseObj){
    this.panelsObj.showPanel(this.errorPanel);
  }
  
  ratingActionClass.prototype.setRatingClasses = function(element,rating){
    for(var i = 0;i<=this.scaleSize;i++){
      if(rating >= i){
        this.h.changeClassName(element.id + this.surfix + i, this.ratedClass);
      }else{
        this.h.changeClassName(element.id + this.surfix + i, this.clearClass);
      }
    }
  }
  
  
  ratingActionClass.prototype.dataReturn = function(eventObj, responseObj){
    eventObj.instanceObj.dataReturn_p(eventObj.paramSet,responseObj);
  }
  
  ratingActionClass.prototype.dataReturn_p = function(element, responseObj){
    this.h.changeClassName(element.id + this.msgSurfix, this.msgOffClass);
     var display= "";
    if(!isNaN(parseInt(element.rating))){
      this.setRatingClasses(element, element.rating);
      this.setFirstChildClassName(element.id +"_"+ this.noInterested, this.notInterestedClear);
      var display = parseFloat(element.rating)
    }else{
      this.setRatingClasses(element, 0);
      this.setFirstChildClassName(element.id +"_"+ this.noInterested,this.noInterested);
    
    }
    this.h.updateHTML(element.id + this.displaySurfix,display);
    this.h.hide(element.id + this.percentageClass)
  }
  
  ratingActionClass.prototype.setFirstChildClassName = function(id, name){
    var targetRef = document.getElementById(id);
    targetRef = targetRef.firstChild;
    targetRef.className = name;
    this.h.deleteDomElement(targetRef);
    targetRef = null;
  }
  
  
  
