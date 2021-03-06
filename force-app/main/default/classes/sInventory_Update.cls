/*
* Author:- Vaishnavi Gajawada
* Created:- 
* Last Updated:- 
* Feature:- 
* Description:- 
*/
public with sharing class sInventory_Update {
    public sInventory_Update() {

    }

//This Class is created to update an Inventory of dealer once the Order is booked
    public void updateInventory(List<Order> Orderdata){
        System.debug('In Update Inventory method');
        String sOrderAccId = '';
        for(Order order : Orderdata){
            sOrderAccId = order.AccountId;
            
            // In Retailer Scenario
            if(order.Status == 'Booked') {
                if(order.Order_Type__c == 'Retailer'){                         
                    Account ordAcc = [Select Id,ParentId from Account where Id =:sOrderAccId];
                    String sDistributorId = ordAcc.ParentId;

                    //Fetching List of Order Items related to the Order
                    List<OrderItem> orderItems = [ SELECT Id, Quantity, Product2Id FROM OrderItem WHERE OrderId = :order.Id ];
                    
                    List<Id> InvProdIds = new List<Id>();
                    for(OrderItem oi : orderItems){
                        InvProdIds.add(oi.Product2Id);
                    }
                    
                    map<Id, OrderItem> ordProdDetails = new map<Id, OrderItem>();
                    for(OrderItem oi : orderItems){
                        ordProdDetails.put(oi.Product2Id, oi);
                    }
                    
                    List<Inventory__c> invItems = [SELECT Id, Product__c, Shipment_Quantity__c FROM Inventory__c WHERE Distributor__c =:sDistributorId and Product__c in :InvProdIds];
                    for(Inventory__c inv : invItems){
                        Decimal Qty = ordProdDetails.get(inv.Product__c).Quantity;
                        System.debug('Order Item Qty..:'+ Qty);
                        inv.Shipment_Quantity__c += Qty;
                    }
                    if(invItems.size() > 0){
                        update invItems;
                    }
                }
            }

            if(order.Status == 'Out For Delivery') {
                if(order.Order_Type__c == 'Retailer'){                         
                    Account ordAcc = [Select Id,ParentId from Account where Id =:sOrderAccId];
                    String sDistributorId = ordAcc.ParentId;

                    //Fetching List of Order Items related to the Order
                    List<OrderItem> orderItems = [ SELECT Id, Quantity, Product2Id FROM OrderItem WHERE OrderId = :order.Id ];
                    
                    List<Id> InvProdIds = new List<Id>();
                    for(OrderItem oi : orderItems){
                        InvProdIds.add(oi.Product2Id);
                    }
                    
                    map<Id, OrderItem> ordProdDetails = new map<Id, OrderItem>();
                    for(OrderItem oi : orderItems){
                        ordProdDetails.put(oi.Product2Id, oi);
                    }
                    
                    List<Inventory__c> invItems = [SELECT Id, Product__c, Shipment_Quantity__c, OnHand_Qty__c FROM Inventory__c WHERE Distributor__c =:sDistributorId and Product__c in :InvProdIds];
                    for(Inventory__c inv : invItems){
                        Decimal Qty = ordProdDetails.get(inv.Product__c).Quantity;
                        System.debug('Order Item Qty..:'+ Qty);
                        inv.Shipment_Quantity__c -= Qty;
                        inv.OnHand_Qty__c -= Qty;
                    }
                    if(invItems.size() > 0){
                        update invItems;
                    }
                }
            }
            
            //Distributor Scenario
            if(order.Status == 'Confirmed') {
                if(order.Order_Type__c == 'Distributor'){                
                    Account ordAcc = [Select Id,ParentId from Account where Id =:sOrderAccId];
                    String sDistributorId = ordAcc.Id;

                    //Fetching List of Order Items related to the Order
                    List<OrderItem> orderItems = [ SELECT Id, Quantity, Product2Id FROM OrderItem WHERE OrderId = :order.Id ];
                    
                    List<Id> InvProdIds = new List<Id>();
                    for(OrderItem oi : orderItems){
                        InvProdIds.add(oi.Product2Id);
                    }
                    
                    map<Id, OrderItem> ordProdDetails = new map<Id, OrderItem>();
                    for(OrderItem oi : orderItems){
                        ordProdDetails.put(oi.Product2Id, oi);
                    }
                    
                    List<Inventory__c> invItems = [SELECT Id, Product__c, Receivable_Qty__c FROM Inventory__c WHERE Distributor__c =:sDistributorId and Product__c in :InvProdIds];
                    for(Inventory__c inv : invItems){
                        Decimal Qty = ordProdDetails.get(inv.Product__c).Quantity;
                        System.debug('Order Item Qty..:'+ Qty);
                        inv.Receivable_Qty__c += Qty;
                    }
                    if(invItems.size() > 0){
                        update invItems;
                    }
                }
            }

            if(order.Status == 'Delivered') {
                if(order.Order_Type__c == 'Distributor'){                         
                    Account ordAcc = [Select Id,ParentId from Account where Id =:sOrderAccId];
                    String sDistributorId = ordAcc.Id;

                    //Fetching List of Order Items related to the Order
                    List<OrderItem> orderItems = [ SELECT Id, Quantity, Product2Id FROM OrderItem WHERE OrderId = :order.Id ];
                    
                    List<Id> InvProdIds = new List<Id>();
                    for(OrderItem oi : orderItems){
                        InvProdIds.add(oi.Product2Id);
                    }
                    
                    map<Id, OrderItem> ordProdDetails = new map<Id, OrderItem>();
                    for(OrderItem oi : orderItems){
                        ordProdDetails.put(oi.Product2Id, oi);
                    }
                    
                    List<Inventory__c> invItems = [SELECT Id, Product__c, OnHand_Qty__c, Receivable_Qty__c FROM Inventory__c WHERE Distributor__c =:sDistributorId and Product__c in :InvProdIds];
                    for(Inventory__c inv : invItems){
                        Decimal Qty = ordProdDetails.get(inv.Product__c).Quantity;
                        System.debug('Order Item Qty..:'+ Qty);
                        inv.Receivable_Qty__c -= Qty;
                        inv.OnHand_Qty__c += Qty;
                    }
                    if(invItems.size() > 0){
                        update invItems;
                    }
                }
            }
        }
    }
}
