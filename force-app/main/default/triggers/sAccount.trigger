/*
* Author:- Somesh Mamidwar
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- Account Trigger
* Description:- 
*/
trigger sAccount on Account (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        for(Account acc: Trigger.new) {
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
        //List<Account> accnts = Trigger.new;
        //SaccountTrigger.sAccountTrigger(accnts);

    }
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Account record: Trigger.new) {
            record.Credit_Usage__c = null;
            record.Billable_Amount__c = null;
        }
        for(AggregateResult result: [SELECT SUM(Amount_Due__c) Amt, AccountId Id FROM Order WHERE AccountId IN :Trigger.new GROUP BY AccountId]) {
            Trigger.newMap.get((Id)result.get('Id')).Credit_Usage__c = (Decimal)result.get('Amt');
        }
        for(AggregateResult result: [SELECT SUM(Amount_Due__c) Amt, AccountId Id FROM Order WHERE (Billable_Days__c < TODAY) AND AccountId IN :Trigger.new GROUP BY AccountId]) {
            Trigger.newMap.get((Id)result.get('Id')).Billable_Amount__c = (Decimal)result.get('Amt');
        }
    }
}