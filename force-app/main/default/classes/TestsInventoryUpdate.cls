@isTest public with sharing class TestsInventoryUpdate {
    @isTest public static void updateInv(){
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        prod.Max_Qty__c=500;
        prod.Min_Qty__c=200;
        update prod;
        
        //Creating Standard Pricebook
        Id standardPBook =Test.getStandardPricebookId(); 
        
       //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
		 //Inventory creation
      /*  Inventory__c newInv=new Inventory__c();
        //insert newInv;        
        newInv.Distributor__c=dealerAccnt.id;
        newInv.OnHand_Qty__c=150;
        newInv.Product__c=prod.id;
        newInv.Price_Book__c=standardPBook;
        newInv.Dealer_Product_Price__c=standardPrice.UnitPrice;
        
        newInv.Retailer_Price_Book__c=standardPBook;
        newInv.Retailer_Price__c=standardPrice.UnitPrice;
        insert newInv;
        
        newInv.OnHand_Qty__c=150;
        update newInv;*/
       
        //Retailer Order creation
        Id orderRTRetlr = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
		Order retOrder=TestDataFactory.createOrder(retailerAccnt.id, orderRTRetlr);
        retOrder.Account__c=dealerAccnt.Id;
        update retOrder; 
        
        //Order item creation goes here
        OrderItem i = new OrderItem();       
        i.OrderId = retOrder.id;
        i.Product2id = prod.id;
        i.PricebookEntryId=standardPrice.Id;
        i.Quantity = 25;
        i.UnitPrice = 100;    
        insert i; 
      
        retOrder.Status='Booked';
        update retOrder;
        
       // System.assertEquals(null,newInv.Current_OnHand_Qty__c);//175
        
        if(retOrder.Status=='Booked'){
            system.debug('i am booked');
           // System.assertEquals(null,newInv.Shipment_Quantity__c);//25
        }
        
        retOrder.Status='Out For Delivery';
        update retOrder;
                
    }

}