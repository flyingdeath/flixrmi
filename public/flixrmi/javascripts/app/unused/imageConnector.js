
  function panelClass(options){
    try{
      this.h = new helperClass();
      this.panelSet = {};
      this.focusStack = [];
      this.initializeOptions(options);
      this.initialize(this.elements);
    }catch(err){
      debugger;
    }
  }
  
  panelClass.prototype.constructor = panelClass;

  /*------------------------------------------------------------------------------------------------*/

  panelClass.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  panelClass.prototype.initialize = function(elements){
    for(var el in elements){
      this.initializeElement(el,elements[el]);
    }
  }