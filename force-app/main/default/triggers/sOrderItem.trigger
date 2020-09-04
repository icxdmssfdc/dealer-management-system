trigger sOrderItem on orderitem (before insert, before update, after insert, after update) {

    if(Trigger.isBefore){

        SOrderItemTriggerHandler ordItmTrgHandlerCls = new SOrderItemTriggerHandler();
        ordItmTrgHandlerCls.sOrderTrgIsBeforeHelper(Trigger.new);

    }

    if (Trigger.isAfter){

        SOrderItemTriggerHandler ordItmTrgHandlerCls = new SOrderItemTriggerHandler();
        ordItmTrgHandlerCls.sOrderTrgIsAfterHelper(Trigger.new,Trigger.old);

    }


}