
function cssStyleSheetEditor(options){
    try{
      this.elements = {};
      this.h = new helperClass();
      this.initializeOptions(options);
      this.currentSheet = this.getSheet(options.name);
      this.currentRules = this.getRules();
    }catch(err){
      debugger;
    }
  }
  
  cssStyleSheetEditor.prototype.constructor = cssStyleSheetEditor;

  /*------------------------------------------------------------------------------------------------*/

  cssStyleSheetEditor.prototype.initializeOptions = function(options){
    for( o in options){
      this[o] = options[o];
    }
  }
  
  cssStyleSheetEditor.prototype.getSheet = function(name){
    var ret;
    for(var i in document.styleSheets){
      if(document.styleSheets[i].href.indexOf(name) !== -1){
        ret = document.styleSheets[i];
        break;
      }
    }
    return ret;
  }
  
  cssStyleSheetEditor.prototype.getRules = function(){
      return this.currentSheet.cssRules ? this.currentSheet.cssRules : this.currentSheet.rules;
  }
  
  cssStyleSheetEditor.prototype.findRule = function(selector){
    var ret;
    for(var i in this.currentRules){
      if(this.currentRules[i].selectorText.toLowerCase() == selector.toLowerCase()){
        ret = this.currentRules[i];
        break;
      }
    }
    return ret;
  }
  
    
  cssStyleSheetEditor.prototype.addRule = function(selector, strRules){
    var totalrules = this.currentRules.length;
    if (currentSheet.deleteRule){ //if Firefox
      this.currentSheet.insertRule(selector + "{" + strRules + "}", totalrules-1)
    }else{
      this.currentSheet.addRule(selector, strRules)
    }
  }
  
  cssStyleSheetEditor.prototype.deleteRule = function(selector){
    var rule = this.findRule(selector);
    var index = this.currentRules.indexOf(rule)
    if (currentSheet.deleteRule){ //if Firefox
      this.currentSheet.deleteRule(index);
    } else if (mysheet.removeRule){ //else if IE
      this.currentSheet.removeRule(index);
    }
    rule = null;
  }
  
  cssStyleSheetEditor.prototype.editRule = function(selector, attribute, newValue){
    var rule = this.findRule(selector);
    rule.style[attribute] = newValue;
    rule = null;
  }