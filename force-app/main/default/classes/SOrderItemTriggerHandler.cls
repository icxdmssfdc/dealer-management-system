public with sharing class SOrderItemTriggerHandler {

    public void sOrderTrgIsBeforeHelper(List<OrderItem> ordItemData){
        Decimal orderTotal = 0;
        Decimal creditremaing = 0;
        Set<Id> orderIds = new Set<Id>(); 

        for (OrderItem oi : ordItemData) {
            if (oi.orderid != null) {
                orderIds.add(oi.orderid);
            }
        }

        Map<Id, Order> orders = new Map<Id, Order>(
             [select id,Credit_Remaining__c from Order where id in :orderIds]
        );

        for (OrderItem orderitem : ordItemData) {
            if(orderitem.Order_Record_Type__c == 'Dealer'){ 
                Order ord = orders.get(orderitem.orderid);
                creditremaing = ord.Credit_Remaining__c;
                for(OrderItem orditem : ordItemData){
                    if(orderitem.orderid == orditem.orderid){
                        orderTotal += orditem.UnitPrice * orditem.Quantity;
                    }
                }
                if(orderTotal > creditremaing){
                    orderitem.adderror('You will not able to proceed with this Order. As your order value is greater than your Credit Available.');
                }
            }
        }

    }

    public void sOrderTrgIsAfterHelper(List<OrderItem> ordNewData,List<OrderItem> ordOldData){

        Set<Id> orderIds = new Set<Id>();

        if(ordOldData != null) {
            for(OrderItem oi: ordOldData) {
                orderIds.add(oi.orderid);
            }
        }

        if(ordNewData != null) {
            for(OrderItem oi: ordNewData) {
                orderIds.add(oi.orderid);
            }
        }

        Map<Id, Order> orders = new Map<Id, Order>(
            [select id, Line_Discount__c from Order where id in :orderIds]
        );

        for (OrderItem orderitem : ordNewData) {
            if(orderitem.Applied_Offer__c  != null){
                Order ord = orders.get(orderitem.orderid);
                ord.Line_Discount__c = true;
            }else{
                Order ord = orders.get(orderitem.orderid);
                ord.Line_Discount__c = false;
            }
        }
        update orders.values(); 

    }

}
