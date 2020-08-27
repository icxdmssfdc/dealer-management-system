/*
* Author:- Somesh Mamidwar
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- 
* Description:- 
*/

public without sharing class SaccountTrigger {
    public static void sAccountTrigClsMethod(List<Account> accountData) {
        //Recomondation to not write SOQL Solution
        List<Id> accntId = new List<Id>();
        List<Account> parAccntIds = new List<Account>();
            for(Account acc : accountData){
                parAccntIds.add(acc.ParentId);
            }
            //Validate CRUD permission before SOQL/DML operation Solution
            if(
                Account.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Account.fields.Name.isAccessible()         
                ){
            List <Account> parentAcc = [Select Id,Partner_Dealer__c from Account where Id in :parAccntIds];
                    }
                   
                    for(Account acc : accountData){
                        for(Account pAcc : parentAcc){
                        //Comparing record type Id's using dynamic apex
                        Id retAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
                        if( acc.RecordTypeId  == retAccRecordTypeId && acc.ParentId != null){
                        acc.Partner_Dealer__c = pAcc.Partner_Dealer__c;
                        }
                    }
                }

}

}


