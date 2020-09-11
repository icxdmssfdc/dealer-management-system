({
    getCurrentEvent: function(component, event, helper){
         var action = component.get("c.getCurrentEvent");
         action.setParams({
            "userId": component.get("v.currentUser"),
            "accountId": component.get("v.recordId"),
         });
         action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var response = response.getReturnValue();
               // component.set('v.eventId',response.eventId);
                component.set('v.visitId',response.visitId);
            }
         });
         $A.enqueueAction(action);
    },
    createCheckInEvent: function(component, event, helper) {
        var action = component.get("c.createCheckInEvent");
        action.setParams({
            "userId": component.get("v.currentUser"),
            "accountId": component.get("v.recordId"),
            "contactId": component.get("v.selectedContactId"),
            "checkInTime": component.get("v.checkInTime"),
            "latitude": component.get("v.latitude"),
            "longitude": component.get("v.longitude"),
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var response = response.getReturnValue();
               // component.set('v.eventId',response.eventId);
                component.set('v.visitId',response.visitId);
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
    checkOut: function(component, event, helper) {
        var action = component.get("c.checkOutEvent");
        action.setParams({
           // "eventId": component.get("v.eventId"),
            "visitId": component.get("v.visitId"),
            "meetingDesc": component.find("meetingdesc").get("v.value")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                response.getReturnValue();
                component.set('v.visitId',null);
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    }
})