public with sharing class CheckProductInventory {

//public CheckProductInventory() {

//}

@AuraEnabled
public static List<OrderInvDetails> getOrderInventory(String sOrderId){
    List<OrderInvDetails> ordInvDetails = new List<OrderInvDetails>();

    String sAccount = '';
    if (
    Order.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Order.fields.Id.isAccessible()&& Schema.SObjectType.Order.fields.AccountId.isAccessible()
    ) {
    Order ord = [Select Id, AccountId, Account.ParentId from Order where Id = :sOrderId];
    
    sAccount = ord.Account.ParentId;
    if(sAccount != null && sAccount != ''){
        sAccount = sAccount;
    }else{
        sAccount = ord.AccountId;
    }
    }
    if (
    OrderItem.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.OrderItem.fields.Id.isAccessible()&& Schema.SObjectType.OrderItem.fields.Quantity.isAccessible()&& Schema.SObjectType.OrderItem.fields.Product2Id.isAccessible()&& Schema.SObjectType.OrderItem.fields.OrderId.isAccessible()
    ) {
    List<OrderItem> orderItems = [ SELECT Id, Quantity, Product2Id FROM OrderItem WHERE OrderId = :sOrderId ];
    List<Id> orderProdIds = new List<Id>();
    for(OrderItem oi : orderItems){
        orderProdIds.add(oi.Product2Id);
    }
    if (
    Inventory__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Inventory__c.fields.Id.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Product__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Current_OnHand_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Distributor__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Product__c.isAccessible()
    ) {
    List<Inventory__c> invItems = [SELECT Id, Product__c, Product__r.Name, Current_OnHand_Qty__c FROM Inventory__c WHERE Distributor__c =:sAccount and Product__c in :orderProdIds];
    
    
    /*List<Id> orderProdIds = new List<Id>();
    for(OrderItem oi : orderItems){
        orderProdIds.add(oi.Product2Id);
    }*/

    map<Id, OrderItem> ordProdDetails = new map<Id, OrderItem>();
    for(OrderItem oi : orderItems){
        ordProdDetails.put(oi.Product2Id, oi);
    }
    
//    List<OrderInvDetails> ordInvDetails = new List<OrderInvDetails>();
    //  if (
    // Inventory__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Inventory__c.fields.Id.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Product__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Product__r.Name.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Current_OnHand_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Distributor__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Product__c.isAccessible()
    // ) {
    //List<Inventory__c> invItems = [SELECT Id, Product__c, Product__r.Name, Current_OnHand_Qty__c FROM Inventory__c WHERE Distributor__c =:sAccount and Product__c in :orderProdIds];
    
    for(Inventory__c inv : invItems){
        OrderInvDetails ordInvDetail = new OrderInvDetails();
        ordInvDetail.lineItemId = ordProdDetails.get(inv.Product__c).Id;
        ordInvDetail.productName = inv.Product__r.Name;
        ordInvDetail.orderQty = ordProdDetails.get(inv.Product__c).Quantity;
        ordInvDetail.onHandQty = inv.Current_OnHand_Qty__c;
        ordInvDetails.add(ordInvDetail);
    }
    }
    }
    return ordInvDetails;
    
}

public class OrderInvDetails{                                                                                                                                                                                                                                                                                   
    @AuraEnabled
    public String lineItemId;

    @AuraEnabled
    public String productName;
    
    @AuraEnabled
    public Decimal orderQty;
    
    @AuraEnabled
    public Decimal onHandQty;
}
}
