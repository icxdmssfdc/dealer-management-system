public with sharing class SCaseHelper{
public void sCaseTgrHelperClass(List<Case> caseData)
{
//List < Id > caseIds = new List < Id > ();
List< Order> listOrd = new List<Order>();//[select AccountId,Applied_Scheme__c from Order where Id in: orderIds];
List < Id > orderIds = new List < Id > ();
for (Case cas: CaseData) {
orderIds.add(cas.Order__c);
//caseIds.add(cas.Id);
}

if (
    Order.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Order.fields.Applied_Scheme__c.isAccessible()&& Schema.SObjectType.Order.fields.AccountId.isAccessible()
) {
    // Defining a List object of Parent Accounts to store 
    //List < Account > parentAccList = [Select Id, Partner_Dealer__c from Account where Id in: parAccntIds];
    //List<Order>
    listOrd = [select AccountId,Applied_Scheme__c from Order where Id in: orderIds];
}
// Defining a Map object to store a key,value pair of child and Parent Accounts
Map<Id, Order> mapParentOrder = new Map<Id, Order>();
for (Order o : listOrd) {
    mapParentOrder.put(o.Id,o);
}
List<Case> v1 = caseData;
for(Case cases : v1) {  

if(cases.Order__c != null){
    Order ord = mapParentOrder.Get(cases.Order__c);

cases.AccountId = ord.AccountId;
if(cases.Scheme__c == null){
    if(ord.Applied_Scheme__c != null) {
        cases.Scheme__c= ord.Applied_Scheme__c;                    
    }  
}
}
}
}
}
