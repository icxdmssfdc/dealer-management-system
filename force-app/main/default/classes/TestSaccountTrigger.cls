@isTest 
public with sharing class TestSaccountTrigger {
    Public Static testMethod void checkAccount(){
        RecordType accRTDist=[SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Dealer'];
        //distributor account
        Account distacc=new Account(Name='Gajendra',recordTypeId=accRTDist.id,Credit_Limit__c=3000);
        insert distacc;
        String distAccID=distacc.id;
        //distibutor contact
        Contact c=new Contact(FirstName='Agarwal',LastName='Manish',AccountId=distAccID);
        
        RecordType accRTRet=[SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Retailer'];
        //retailer account
        Account retailerAcc=new Account(Name='shiva',ParentId=distAccID,recordTypeId=accRTRet.id);
        insert retailerAcc;//'0122v000002AYRFAA4'
        //retailer order
        Order retOrder=new Order(AccountId=retailerAcc.Id,Status='Draft',EffectiveDate=system.today()-6);//,RecordTypeId=dealrOrdRT.id
        insert retOrder;
        String accFields = GetAllFields.getAllObjectField('Account');
        String query = 'select ' + accFields + ' from Account Where Id = \''+ retOrder.AccountId +'\' Limit 1';
        retOrder.Account__c = retailerAcc.ParentId;
        query = 'select ' + accFields + ' from Account Where Id = \''+ retailerAcc.ParentId +'\' Limit 1';
        Account parAccount = Database.query(query);
        //retOrder.Partner_Dealer__c = parAccount.Partner_Dealer__c;
        system.debug('I am Query V'+parAccount);
        String v1 = 'assert';
        retailerAcc.ParentId=distacc.id;
        update retailerAcc;
        //Order OrdFields=[SELECT Partner_Dealer__c FROM Order WHERE id=:retOrder.id];
        Account acFields=[SELECT Partner_Dealer__c FROM Account WHERE id=:retailerAcc.id];
        System.assertEquals('Gajendra',parAccount.Name,v1);
        //System.assertEquals('Gajendra',acFields.Partner_Dealer__c,v1);
        System.debug('checking for assert');
        
    }
}