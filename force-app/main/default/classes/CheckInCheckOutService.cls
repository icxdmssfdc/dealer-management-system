public with sharing class CheckInCheckOutService {
   // public class CheckInCheckOutSerivce {
        @AuraEnabled
        public static Map<String,Id> getCurrentEvent(Id userId,Id accountId){
            Map<String,Id> responseMap = new Map<String,Id>();
          //  Id eventId = null;
            Id visitId = null;
            List<Sales_Rep_Visit__c> visits = [Select Id from Sales_Rep_Visit__c where (Account__c =: accountId and CreatedById =:userId and CheckOut_Time__c = null) ORDER BY CreatedDate desc LIMIT 1];
            if(visits.size() > 0){
                for(Sales_Rep_Visit__c  visit : visits){
                    visitId = visit.Id;
                }
            }else{
                visitId = null;
            }
            
        //    List<Event> events = [Select Id from Event where (WhatId =: accountId and OwnerId =: userId) ORDER BY CreatedDate desc LIMIT 1];
        //    if(events.size() > 0){
        //        for(Event event : events){
        //            eventId = event.Id;
        //        }
        //    }else{
        //        eventId = null;
         //   }
            
         //   responseMap.put('eventId', eventId);
            responseMap.put('visitId', visitId);
            return responseMap;
        }
        
        @AuraEnabled
        public static map<String,Id> createCheckInEvent(Id userId,Id accountId, Id contactId,String checkInTime,String latitude,String longitude){
            Map<String,Id> responseMap = new Map<String,Id>();
     //       Event evt = new Event();
    //        evt.Subject = 'Meeting';
     //       evt.ActivityDate = system.today();
     //       evt.OwnerId = userId;
     //       evt.StartDateTime = DateTime.now();
     //       evt.WhatId = accountId;
      //      evt.WhoId = contactId;
       //     evt.DurationInMinutes = 60;
       //     insert evt;
            
            Sales_Rep_Visit__c  visit = new Sales_Rep_Visit__c ();
            visit.Account__c = accountId;
            visit.Contact__c = contactId;
            visit.GeoLocation__Latitude__s = decimal.valueOf(latitude);
            visit.GeoLocation__Longitude__s = decimal.valueOf(longitude);
            visit.CheckIn_Time__c = DateTime.now();
            insert visit;
            
     //       responseMap.put('eventId', evt.Id);
            responseMap.put('visitId', visit.Id);
            return responseMap;
        }
        
        @AuraEnabled
        public static map<String,Id> checkOutEvent(Id visitId, String meetingDesc){//Id eventId,
            Map<String,Id> responseMap = new Map<String,Id>();
    //        Event evt = [select Id from Event where Id =: eventId];
    //        evt.Description = meetingDesc;
    //       update evt;
            
            Sales_Rep_Visit__c  visit = [select Id from Sales_Rep_Visit__c  where Id =: visitId];
            visit.CheckOut_Time__c = DateTime.now();
            update visit;
            
     //       responseMap.put('eventId', evt.Id);
            responseMap.put('visitId', visit.Id);
            
            return responseMap;
        }
    //}
}
