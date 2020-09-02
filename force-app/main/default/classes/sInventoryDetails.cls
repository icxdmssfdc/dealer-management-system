/*
* Author:- Vaishnavi Gajawada
* Created:- 26-08-2020 1-09-2020
* Last Updated:- 
* Feature:- 
* Description:- Helper class for aura component AccInvDetails used for generate order button in inventory
*/
public with sharing class sInventoryDetails {
    //public SInventoryDetails() {
    
    //}
    
    /*Getting all the inventories lessthan the required min quantity*/
    @AuraEnabled
    public static List<Inventory__c> getAccInventoryDetails(String accountId){
        List<Inventory__c> inventories=new List<Inventory__c>();
        List<Product2> prods=new List<Product2>();
        if (
        Account.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Account.fields.Id.isAccessible()
        ) {
        Account[] acc = [select id from Account where id = : accountId];
        
        if(acc.size() == 0){
            String userId = UserInfo.getUserId();
            if (
        User.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.User.fields.contactId.isAccessible()
        ) {
    
            User u = [select id, contactId from User where id = : userId];
        
            String sContactId = u.contactId;
            if (
        Contact.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Contact.fields.accountId.isAccessible()
        ) {
    
            Contact[] c = [select id, accountId from Contact where id = :sContactId];
        
            if(c.size() > 0){
                accountId = c[0].accountId;
            }
        }
        }
        }
        }
        if (
        Inventory__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Inventory__c.fields.Price_Book__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.LastModifiedDate.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Current_OnHand_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Under_Minimum_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Next_Order_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Minimum_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Maximum_Qty__c.isAccessible()//&& Schema.SObjectType.Inventory__c.fields.Product__r.Product_Classification__c.isAccessible()
        ) {
        inventories = [Select Id,Price_Book__c,LastModifiedDate,Product__r.Name,Product__r.Product_Classification__c,Current_OnHand_Qty__c,Next_Order_Qty__c,Under_Minimum_Qty__c, Minimum_Qty__c,Maximum_Qty__c from Inventory__c where (Distributor__c=:accountId) order by Under_Minimum_Qty__c desc];
        }
        return inventories;
    }
    
    /*Geting all the inventories based on the query Product Name*/
    @AuraEnabled
    public static List<Inventory__c> getQueryInvDetails(Id accountId, String prodName){
        List<Inventory__c> inventories=new List<Inventory__c>();
        List<Product2> prods=new List<Product2>();
        if (
        Account.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Account.fields.Id.isAccessible()
        ) {
        Account[] acc = [select id from Account where id = : accountId];
        
        if(acc.size() == 0){
            String userId = UserInfo.getUserId();
            User u = [select id, contactId from User where id = : userId];
            String sContactId = u.contactId;
            Contact[] c = [select id, accountId from Contact where id = :sContactId];
            if(c.size() > 0){
                accountId = c[0].accountId;
            }
        }
        }
        prodName = '%'+prodName;
        if(prodName != null){
            if (
        Product2.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Product2.fields.Id.isAccessible()&& Schema.SObjectType.Product2.fields.Name.isAccessible()
            ) {
            prods = [Select Id from Product2 where Name like :prodName+ '%'];
            
        if(prods.size() > 0){
            if (
        Inventory__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Inventory__c.fields.Price_Book__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.LastModifiedDate.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Current_OnHand_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Under_Minimum_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Next_Order_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Minimum_Qty__c.isAccessible()&& Schema.SObjectType.Inventory__c.fields.Maximum_Qty__c.isAccessible()//&& Schema.SObjectType.Inventory__c.fields.Product__r.Product_Classification__c.isAccessible()
            ) {
        inventories = [Select Id,Price_Book__c,LastModifiedDate,Product__r.Name,Current_OnHand_Qty__c,Next_Order_Qty__c, Minimum_Qty__c,Maximum_Qty__c from Inventory__c where (Distributor__c=:accountId and Product__c in :prods)];
            }
            }
            }
        }
        return inventories;
    }
    
    @AuraEnabled
    public static void generateInvOrder(Id accountId, List<Inventory__c> lInvDetails){
        //List<PricebookEntry> entry=new List<PricebookEntry>();
        if (
        Account.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Account.fields.Id.isAccessible()
        ) {
        Account[] accounts = [select id from Account where id = : accountId];
        
        if(accounts.size() == 0){
            String userId = UserInfo.getUserId();
            User u = [select id, contactId from User where id = : userId];
            String sContactId = u.contactId;
            Contact[] c = [select id, accountId from Contact where id = :sContactId];
            if(c.size() > 0){
                accountId = c[0].accountId;
            }
        }
        }
        Account acc = [Select Id,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet from Account where Id = :accountId];
        if(lInvDetails.size() > 0){
               // if (
               // Pricebook2.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Pricebook2.fields.Id.isAccessible()&& Schema.SObjectType.Pricebook2.fields.Name.isAccessible()
               // ) {
            Pricebook2 standardBook = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book'];
               // }
            Order newOrder = new Order();
            if(acc != null){
                newOrder.AccountId = acc.Id;
                newOrder.BillingCity = acc.BillingCity;
                newOrder.BillingCountry = acc.BillingCountry;
                newOrder.BillingPostalCode = acc.BillingPostalCode;
                newOrder.BillingState = acc.BillingState;
                newOrder.BillingStreet = acc.BillingStreet;
                
                newOrder.ShippingCity = acc.ShippingCity;
                newOrder.ShippingCountry = acc.ShippingCountry;
                newOrder.ShippingPostalCode = acc.ShippingPostalCode;
                newOrder.ShippingState = acc.ShippingState;
                newOrder.ShippingStreet = acc.ShippingStreet;
            }
    
            newOrder.Status = 'Draft';
            newOrder.EffectiveDate = system.today();
            system.debug(lInvDetails[0].Price_Book__c);
            Id pricebookId = lInvDetails[0].Price_Book__c;
            newOrder.Pricebook2Id = pricebookId;
            insert newOrder;
        
            List<Orderitem> lineitems = new List<Orderitem>();
            for(Inventory__c invOrdProduct : lInvDetails){
                if (
                PricebookEntry.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.PricebookEntry.fields.Id.isAccessible()&& Schema.SObjectType.PricebookEntry.fields.unitprice.isAccessible()&& Schema.SObjectType.PricebookEntry.fields.Pricebook2Id.isAccessible()//&& Schema.SObjectType.PricebookEntry.fields.Product2.Id.isAccessible()
                ) {        
                PricebookEntry entry = [SELECT Id,unitprice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND Product2.Id =:invOrdProduct.Product__r.Id];
                
                Orderitem oitem = new Orderitem();
                oitem.OrderId = newOrder.Id;
                oitem.Quantity = invOrdProduct.Next_Order_Qty__c;
                oitem.PricebookEntryId = entry.Id;
                oitem.Product2Id = invOrdProduct.Product__r.Id;
                oitem.UnitPrice = entry.unitprice;
                lineitems.add(oitem);
                }
            }
            insert lineitems;
            if (!Schema.sObjectType.Order.fields.Name.isUpdateable()) {
    
            newOrder.Is_Inventory_Order__c = true;
            newOrder.Status = 'Approval Request';
            }
            update newOrder;
        }
    }
    
    }