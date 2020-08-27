/*
* Author:- Somesh Mamidwar
* Created:- 
* Last Updated:- 
* Feature:- 
* Description:- 
*/

public without sharing class SaccountTrigger {
    public static void sAccountTrigClsMethod(List<Account> accountData) {

        for(Account acc : accountData){

            //Fetching record data record typeId with Retailer recordTypeId
           Id retAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
           if( acc.RecordTypeId  == retAccRecordTypeId){
               if(acc.ParentId != null)
              {
               Account parentAcc = [Select Id,Partner_Dealer__c from Account where Id =: acc.ParentId];
               acc.Partner_Dealer__c = parentAcc.Partner_Dealer__c;
               }
           }

        }

    }
}
