({
	getInvDetails : function(component, event, helper) {
		 var action = component.get('c.getAccInventoryDetails'); 
        action.setParams({
            "accountId" : component.get('v.recordId') 
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var invData = a.getReturnValue();
                for(var i = 0; i< invData.length; i++){
                    var row = invData[i];
                    if (row.Under_Minimum_Qty__c == true) {
                        row.isSelected = true;
                    }
                }
                component.set('v.sInvList', invData);
            }
        });
        $A.enqueueAction(action);
	},
    queryAccProducts : function(component, event, helper, queryTerm) {
		var action = component.get('c.getQueryInvDetails'); 
        action.setParams({
            "accountId" : component.get('v.recordId'),
            "prodName" : queryTerm
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var invData = a.getReturnValue();
                for(var i = 0; i< invData.length; i++){
                    var row = invData[i];
                    if (row.Under_Minimum_Qty__c == true) {
                        row.isSelected = true;
                    }
                }
                component.set('v.sInvList', invData);
            }
        });
        $A.enqueueAction(action);
	},
    genOrder : function(component, event, helper, lInvItems){
        var action = component.get('c.generateInvOrder'); 
        action.setParams({
            "accountId" : component.get('v.recordId'),
            "lInvDetails" : lInvItems
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                this.getInvDetails(component, event, helper);
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    }
})