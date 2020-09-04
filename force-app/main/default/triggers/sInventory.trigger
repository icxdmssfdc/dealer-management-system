/*
* Author:- Vaishnavi Gajawada
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- 
* Description:- Inventory Trigger for inventory object
*/
trigger sInventory on Inventory__c (before insert,before update) {
        
    if(Trigger.isInsert){

        SInventoryTriggerHandler SInvTrgHandlerCls = new SInventoryTriggerHandler();

        for(Inventory__c inv : Trigger.new){
            SInvTrgHandlerCls.sInventoryTrgInsertHelper(inv);

        }


    }

    if(Trigger.isUpdate){

        SInventoryTriggerHandler SInvTrgHandlerCls = new SInventoryTriggerHandler();

        for(Inventory__c newinv : Trigger.new){
            
            Inventory__c oldInv =Trigger.oldMap.get(newInv.Id);
            SInvTrgHandlerCls.sInventoryTrgUpdateHelper(newinv,oldInv);

        }


    }


}
