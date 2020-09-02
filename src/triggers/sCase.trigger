/*
* Author:- Vaishnavi Gajawada
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- 
* Description:- Case Trigger for case object
*/
trigger sCase on Case (before insert) {
    if(Trigger.isInsert){
        
        for(Case Vcase : Trigger.New) {  
            
            if(Vcase.Order__c != null){
                // List<Order> ord = new List<Order>();
                // List<Order> ord = [select AccountId,icxdms__Scheme__c from Order where Id =:Vcase.icxdms__Order__c];
                Order Ord = [select AccountId,Applied_Scheme__c from Order where Id =:Vcase.Order__c];
                //system.debug(Ord.AccountId);
                Vcase.AccountId = Ord.AccountId;
               // system.debug(Vcase.AccountId);
                if(Vcase.Scheme__c == null){
                    if(Ord.Applied_Scheme__c != null) {
                        Vcase.Scheme__c= Ord.Applied_Scheme__c;                    
                    }
                }
                
            }       
            
        }
        
    }

}