/*
* Author:- Somesh Mamidwar
* Created:- 17-09-2020
* Last Updated:- 
* Description:- Test Class for CheckProductInventory
*/
@isTest
public class TestCheckProductInventory {

    @isTest Public static void checkProdInv(){
        
         //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        prod.Max_Qty__c=500;
        prod.Min_Qty__c=200;
        update prod;
        
        //standard pricebook
        Id standardPBook =Test.getStandardPricebookId();
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
        //Inventory creation
        Inventory__c newInv=new Inventory__c();
        //insert newInv;        
        newInv.Distributor__c=dealerAccnt.id;
        newInv.OnHand_Qty__c=150;
        newInv.Product__c=prod.id;
        newInv.Price_Book__c=standardPBook;
        newInv.Dealer_Product_Price__c=standardPrice.UnitPrice;
        
        newInv.Retailer_Price_Book__c=standardPBook;
        newInv.Retailer_Price__c=standardPrice.UnitPrice;
        insert newInv;
        
         // Order creation
        Id orderRetailerRecTypId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        Order retailerOrder=TestDataFactory.createOrder(retailerAccnt.Id, orderRetailerRecTypId);
        
        retailerOrder.Account__c=dealerAccnt.Id;
        update retailerOrder; 
        
        // Order Item Creation
		OrderItem retailerOi=new OrderItem(Product2Id=prod.Id,Quantity=100,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);       
        insert retailerOi;      
        
        CheckProductInventory.getOrderInventory(retailerOrder.Id);
        
        
        //Dealer  Order creation
        Id orderDealerRecTypId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Order dealerOrder=TestDataFactory.createOrder(dealerAccnt.Id, orderDealerRecTypId);
        
        // Order Item Creation
		OrderItem dealeroi=new OrderItem(Product2Id=prod.Id,Quantity=100,OrderId=dealerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);       
        insert dealeroi;  
        
        CheckProductInventory.getOrderInventory(dealerOrder.Id);
        
    }
    
}