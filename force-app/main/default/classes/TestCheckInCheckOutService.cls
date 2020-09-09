@isTest public with sharing class TestCheckInCheckOutService {
    //@isTest private class Test_CheckInCheckOutService {
        @isTest static void visitcheck(){
            Account acc = new account(name='acc');
            insert acc;
            Contact cont=new Contact();
            cont.AccountId=acc.id;
            cont.FirstName='raj';
            cont.LastName='kumar';
            insert cont;
            //Profile profName=new Profile();
            //profName.Name='DMS Profile';
            //insert profName;
            Profile profName=[SELECT Id From Profile WHERE Name='DMS Profile'];
            
            User aUser= new User();
            aUser.FirstName='Swamy';
            aUser.LastName='Nanda';
            aUser.ProfileId=profName.Id;
            aUser.IsActive=true;
            aUser.Username = 'testerwer_User@test.com';
            aUser.email = 'tester@test.com';
            aUser.Alias = 'tstr';
            aUser.TimeZoneSidKey = 'Asia/Kolkata';
            aUser.LocaleSidKey ='en_GB';
            aUser.EmailEncodingKey ='ISO-8859-1';
            aUser.LanguageLocaleKey = 'en_US';
    
            //aUser.System.DmlException: Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [Username, Email,
            // Alias, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, LanguageLocaleKey]: [Username, Email, Alias, TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, LanguageLocaleKey]
            insert aUser;
            system.debug('user is'+aUser);
            List<Sales_Rep_Visit__c> visits = [Select Id from Sales_Rep_Visit__c where (Account__c =: acc.Id and CreatedById =:aUser.Id and CheckOut_Time__c = null) ORDER BY CreatedDate desc LIMIT 1];
            
            Sales_Rep_Visit__c  visit = new Sales_Rep_Visit__c ();
            visit.Account__c = acc.id;
            visit.Contact__c = cont.Id;
            //visit.CreatedById=aUser.id;
            visit.Sales_Rep__c=aUser.id;
            String latitude='54.2222';        String longitude='34.2222';
            visit.GeoLocation__Latitude__s = decimal.valueOf(latitude);
            visit.GeoLocation__Longitude__s = decimal.valueOf(longitude);
            visit.CheckIn_Time__c = DateTime.now();
            visit.CheckOut_Time__c = DateTime.now()+10;
            visit.Visited_Date__c=system.today();
            insert visit;
            system.debug('visit is'+visit);
            Test.startTest();
            CheckInCheckOutService.getCurrentEvent(aUser.Id, acc.Id);
            CheckInCheckOutService.createCheckInEvent(aUser.Id, acc.Id, cont.Id,'10:00', latitude, longitude);
            CheckInCheckOutService.checkOutEvent(visit.id,'meetingDesc');
            Test.stopTest();
            //String v1 = 'latitude';
            //String v1 = v1;
            system.assertEquals(54.2222,visit.GeoLocation__Latitude__s,'latitude');//acc.Geo_Location__Latitude__s
            //system.assertEquals(acc.Geo_Location__Longitude__s,visit.GeoLocation__Longitude__s);
           
        }
        
    }