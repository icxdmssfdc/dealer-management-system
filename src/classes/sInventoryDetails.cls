/*
* Author:- Vaishnavi Gajawada
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- 
* Description:- 
*/
public with sharing class sInventoryDetails {
    public sInventoryDetails() {

    }
    
        /*Geting all the inventories lessthan the required min quantity*/
        @AuraEnabled
        public static List<Inventory__c> getAccInventoryDetails(String accountId){
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
            List<Inventory__c> inventories = [Select Id,Price_Book__c,LastModifiedDate,Product__r.Name,Product__r.Product_Classification__c,Current_OnHand_Qty__c,Next_Order_Qty__c,Under_Minimum_Qty__c, Minimum_Qty__c,Maximum_Qty__c from Inventory__c where (Distributor__c=:accountId) order by Under_Minimum_Qty__c desc];
            return inventories;
        }
        
        /*Geting all the inventories based on the query Product Name*/
        @AuraEnabled
        public static List<Inventory__c> getQueryInvDetails(Id accountId, String prodName){
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
            prodName = '%'+prodName;
            List<Inventory__c> inventories;
            if(prodName != null){
                List<Product2> prods = [Select Id from Product2 where Name like :prodName+ '%'];
                if(prods.size() > 0){
                    inventories = [Select Id,Price_Book__c,LastModifiedDate,Product__r.Name,Current_OnHand_Qty__c,Next_Order_Qty__c, Minimum_Qty__c,Maximum_Qty__c from Inventory__c where (Distributor__c=:accountId and Product__c in :prods)];
                }
            }
            return inventories;
        }
        
        @AuraEnabled
        public static void generateInvOrder(Id accountId, List<Inventory__c> lInvDetails){
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
            Account acc = [Select Id,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet from Account where Id = :accountId];
            if(lInvDetails.size() > 0){
                Pricebook2 standardBook = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard'];
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
                    PricebookEntry entry = [SELECT Id,unitprice FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND Product2.Id =:invOrdProduct.Product__r.Id];
                    Orderitem oitem = new Orderitem();
                    oitem.OrderId = newOrder.Id;
                    oitem.Quantity = invOrdProduct.Next_Order_Qty__c;
                    oitem.PricebookEntryId = entry.Id;
                    oitem.Product2Id = invOrdProduct.Product__r.Id;
                    oitem.UnitPrice = entry.UnitPrice;
                    lineitems.add(oitem);
                }
                insert lineitems;
               newOrder.Is_Inventory_Order__c = true;
               newOrder.Status = 'Approval Request';
               update newOrder;
            }
        }
    
}
