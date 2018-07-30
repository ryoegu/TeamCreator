({
	doInit : function(component, event, helper) {
		var member = component.get('v.member');
        var fieldName = component.get('v.fieldName');
        
        var fieldN = fieldName.fieldName.toString();
        
        component.set('v.output',member[fieldN]);
	}
})