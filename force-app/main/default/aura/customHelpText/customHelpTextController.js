({
  handleOnClick : function(component, event, helper) {
    $A.util.toggleClass(component.find("divHelp"), 'slds-hide');
  },
  handleMouseLeave : function(component, event, helper) {
    $A.util.addClass(component.find("divHelp"), 'slds-hide');
  },
  handleMouseEnter : function(component, event, helper) {
    $A.util.removeClass(component.find("divHelp"), 'slds-hide');
  },
})