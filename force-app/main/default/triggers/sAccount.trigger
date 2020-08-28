/*
* Author:- Somesh Mamidwar
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- Account Trigger created
* Description:- 
*/
trigger sAccount on Account (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert){
        SaccountTrigger sAccountTriggerCls = new SaccountTrigger();
        sAccountTriggerCls.sAccountTrgInsertHelper(Trigger.new);         
    }

    if(Trigger.isBefore && Trigger.isUpdate){
        for(Account record: Trigger.new) {
            record.icxdms__Credit_Usage__c = null;
            record.icxdms__Billable_Amount__c = null;
        }
        for(AggregateResult result: [SELECT SUM(icxdms__Amount_Due__c) Amt, AccountId Id FROM Order WHERE AccountId IN :Trigger.new GROUP BY AccountId]) {
            Trigger.newMap.get((Id)result.get('Id')).icxdms__Credit_Usage__c = (Decimal)result.get('Amt');
        }
        for(AggregateResult result: [SELECT SUM(icxdms__Amount_Due__c) Amt, AccountId Id FROM Order WHERE (icxdms__Billable_Days__c < TODAY) AND AccountId IN :Trigger.new GROUP BY AccountId]) {
            Trigger.newMap.get((Id)result.get('Id')).icxdms__Billable_Amount__c = (Decimal)result.get('Amt');
        }
    }
}