({
    doInit : function(component, event, helper){
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.currentUser",userId);
        var latitude;
        var longitude;
        navigator.geolocation.getCurrentPosition(function(e) {
            console.log(e.coords.latitude + ', ' + e.coords.longitude);
            latitude = e.coords.latitude;
            longitude = e.coords.longitude;
            component.set("v.latitude",latitude);
            component.set("v.longitude",longitude);
        });
        helper.getCurrentEvent(component, event, helper);
    },
    createCheckIn : function(component, event, helper) {
        var accountId = null;
        var contactId = null;
        if(component.get("v.selectedAccount").Id != undefined){
            accountId = component.get("v.selectedAccount").Id;
            component.set("v.selectedAccountId",accountId);
        }
        if(component.get("v.selectedContact").Id != undefined){
            contactId = component.get("v.selectedContact").Id;
            component.set("v.selectedContactId",contactId);
        }
        console.log('Account Id..:'+accountId);
        console.log('Contact Id..:'+contactId);
        
        var today = $A.localizationService.formatDate(new Date(),"DD-MM-YYYY HH:MM:SS");
        console.log('Current Time..:'+today);
        component.set("v.checkInTime",today);
        
        var latitude;
        var longitude;
        navigator.geolocation.getCurrentPosition(function(e) {
            console.log(e.coords.latitude + ', ' + e.coords.longitude);
            latitude = e.coords.latitude;
            longitude = e.coords.longitude;
            component.set("v.latitude",latitude);
            component.set("v.longitude",longitude);
        });
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log(userId);
        component.set("v.currentUser",userId);
        
        helper.createCheckInEvent(component, event, helper);
        //$A.get("e.force:closeQuickAction").fire();
    },
    checkOut: function(component, event, helper){
    	var meetingdesc = component.find("meetingdesc").get("v.value");
        helper.checkOut(component, event, helper);
	}
})