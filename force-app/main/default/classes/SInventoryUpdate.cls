/*
 * Author:- Vamsi Alla
 * Created:- 28-08-2020
 * Last Updated:- 
 * Feature:- 
 * Description:- To Update an Inventory at Dealer account  on Order Creation
 */
public without sharing class SInventoryUpdate {

    public void updateInventory(List < Order > orderdata) {

        String sOrderAccId = '';
        List < Id > orderIds = new List < Id > ();
        List < Id > accIds = new List < Id > ();
        List < Id > distributorIds = new List < Id > ();
        List < Id > invProdIds = new List < Id > ();
        List < OrderItem > orderItems = new List < OrderItem > ();
        List < OrderItem > relatedOrderItems = new List < OrderItem > ();
        List < Inventory__c > invItems = new List < Inventory__c > ();
        Map < Id, Account > accDetails = new Map < Id, Account > ();
        Map < Id, OrderItem > ordProdDetails = new Map < Id, OrderItem > ();

        for (Order order: orderdata) {
            accIds.add(order.AccountId);
            orderIds.add(order.Id);
        }

        if (Schema.sObjectType.Account.fields.ParentId.isReadable()) {
            accDetails = [Select Id, ParentId from Account where Id in: accIds];
        }

        for (Order order: orderdata) {
            if (accDetails.get(order.AccountId).ParentId != null) {
                distributorIds.add(accDetails.get(order.AccountId).ParentId);
            } else {
                distributorIds.add(accDetails.get(order.AccountId).Id);
            }
        }

        if (Schema.sObjectType.OrderItem.fields.Product2Id.isReadable() && Schema.sObjectType.OrderItem.fields.Quantity.isReadable()) {
            orderItems = [SELECT Id, Quantity, Product2Id FROM OrderItem WHERE OrderId in: orderIds];
        }

        for (OrderItem oi: orderItems) {
            invProdIds.add(oi.Product2Id);
            ordProdDetails.put(oi.Product2Id, oi);
        }

        if (Schema.sObjectType.Inventory__c.fields.Product__c.isReadable() && Schema.sObjectType.Shipment_Quantity__c.fields.Product__c.isReadable()) {
            invItems = [SELECT Id, Product__c, Distributor__c, Shipment_Quantity__c FROM Inventory__c WHERE Product__c in: InvProdIds];
        }

        for (Order order: orderdata) {
            //Get Order Related OrderItems
            for (OrderItem oi: orderItems) {
                if (oi.Order == order.Id) {
                    relatedOrderItems.add(oi);
                }
            }

            for (OrderItem oi: relatedOrderItems) {
                for (Inventory__c inv: invItems) {
                    if (inv.Distributor__c == order.Account && inv.Product__c == oi.Product2Id) {
                        if (order.Order_Type__c == 'Retailer') {
                            if (order.Status == 'Booked') {
                                Decimal qty = ordProdDetails.get(inv.Product__c).Quantity;
                                inv.Shipment_Quantity__c += qty;
                            } else if (order.Status == 'Out For Delivery') {
                                Decimal qty = ordProdDetails.get(inv.Product__c).Quantity;
                                inv.Shipment_Quantity__c -= qty;
                                inv.OnHand_Qty__c -= qty;
                            } else {
                                continue;
                            }
                        } else if (order.Order_Type__c == 'Distributor') {
                            if (order.Status == 'Confirmed') {
                                Decimal qty = ordProdDetails.get(inv.Product__c).Quantity;
                                System.debug('Order Item Qty..:' + qty);
                                inv.Receivable_Qty__c += qty;
                            } else if (order.Status == 'Delivered') {
                                Decimal qty = ordProdDetails.get(inv.Product__c).Quantity;
                                inv.Receivable_Qty__c -= qty;
                                inv.OnHand_Qty__c += qty;
                            } else {
                                continue;
                            }
                        }
                    } else {
                        continue;
                    }
                }
            }
        }

        if (invItems.size() > 0) {
            if (Schema.sObjectType.Inventory__c.fields.OnHand_Qty__c.isUpdateable() &&
                Schema.sObjectType.Inventory__c.fields.Receivable_Qty__c.isUpdateable() &&
                Schema.sObjectType.Inventory__c.fields.Shipment_Quantity__c.isUpdateable()) {
                update invItems;
            }
        }
    }
}