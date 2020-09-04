trigger sOrderTrigger on Order (before insert, before update, after insert, after update) {

    if(Trigger.isBefore && Trigger.isInsert){

        for(Order ord : Trigger.New){
            SOrderTriggerHandler ordTrigCls = new SOrderTriggerHandler();
            ordTrigCls.sOrderTrgBeforeInsertHelper(ord);
        }
    } 

    if(Trigger.isBefore && Trigger.isUpdate){

        for(Order ord : Trigger.newMap.Values()){
            ApplyOrderOffers applyoffers = new ApplyOrderOffers();
            applyoffers.applyOffers(ord);

        }

    }

        // Below is to set the credit usage at the Account Level.
        if(Trigger.isAfter){ 
            Set<Id> accountIds = new Set<Id>();
            if(Trigger.old != null) {
                for(Order record: Trigger.old) {
                    accountIds.add(record.AccountId);
                }
            }
            if(Trigger.new != null) {
                for(Order record: Trigger.new) {
                    accountIds.add(record.AccountId);
                }
            }
            update [SELECT Id FROM Account WHERE Id IN :accountIds];
            
            //Updating Inventory once order is created
            if(Trigger.isUpdate){
                list<Order> orders = new list<Order>();
                for(Order ord : Trigger.new){
                    Order oldord = Trigger.oldMap.get(ord.Id);
                    if(oldord.Status != ord.Status){
                        orders.add(ord);
                    }
                }
                if(orders.size() > 0){
                    SInventoryUpdate invUpdate = new SInventoryUpdate();
                    invUpdate.updateInventory(Trigger.New);
                }
            }
        }

}