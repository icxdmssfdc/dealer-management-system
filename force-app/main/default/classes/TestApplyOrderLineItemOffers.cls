@isTest
public class TestApplyOrderLineItemOffers {

 

     @isTest Public static void lineOffersQuantityCheck() {
        
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);

 

        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');

 

        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);

 

        // Creating Qunatity Scheme
        Id schemeRecTypId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Quantity Discount').getRecordTypeId();
        Scheme__c sch =new Scheme__c();
        sch.Name = 'Buy 100 Get 10 for Test Product';
        sch.RecordTypeId = schemeRecTypId;
        sch.Active__c=True;
        sch.Start_Date__c = system.today()-10;
        sch.End_Date__c=system.today()+20;
        sch.Scheme_Type__c='Specific';
        sch.Discount_Type__c='Quantity';
        sch.Product__c=prod.Id;   
        sch.Buy__c=100;
        sch.Get__c=10;
        sch.Status__c='Approved';
        sch.Active__c=true;
        sch.State__c='Telangana';
        insert sch;

      /*  Id offerPerRecId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Amount Discount').getRecordTypeId();
        
        Scheme__c offerAmount =new Scheme__c(RecordTypeId=offerPerRecId,Name='Buy7000aboveGet700back',Start_Date__c=system.today()-30,Active__c=True);
        insert offerAmount;
        offerAmount.End_Date__c=system.today()+30;
        offerAmount.Scheme_Type__c='Specific';
        offerAmount.Order_Amount__c=7000;
        offerAmount.Discount_Type__c='Amount';
        offerAmount.Discount_Amount__c=700;   
        //offerAmount.End_Date__c=system.today()+20;
        offerAmount.Header_Discount__c=True;
        offerAmount.Status__c='Approved';
        offerAmount.Active__c=true;
        offerAmount.State__c='Telangana';
        update offerAmount;*/

        //Creating Retailer Order
        Id retOrdRecTypId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();    
        
        Order retailerOrder = TestDataFactory.createOrder(retailerAccnt.Id, retOrdRecTypId);

 

        //Creating Order Item
        OrderItem oi=new OrderItem(Product2Id=prod.Id,Quantity=100,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        insert oi;
 
 
       // System.debug('discount is'+oi.)
           OrderItem newOi = [select Id,Quantity from OrderItem where Id = :oi.Id];
        System.debug('Order Item Quantity is'+newOi.Quantity);
        System.assertEquals(110,newOi.Quantity);
        
 

    }
    
    @isTest Public static void lineOffersCrossProductCheck() {
        
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);

 

        //Creating Products
        Product2 prod1 = TestDataFactory.createProduct('Test Fruit Juice1');
        
        Product2 prod2 = TestDataFactory.createProduct('Test Fruit Juice2');

 

        //Creating PricebookEntrys
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod1.Id);
        
        PricebookEntry standardPrice1 = TestDataFactory.createPricebookEntry(100,prod2.Id);

 

        // Creating CrossProduct Scheme
        Id schemeRecTypId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Cross Product Offer').getRecordTypeId();
        Scheme__c sch =new Scheme__c();
        sch.Name = 'Buy 100 Test Fruit Juice1 Get 10 Test Fruit Juice2';
        sch.RecordTypeId = schemeRecTypId;
        sch.Active__c=True;
        sch.Start_Date__c = system.today()-10;
        sch.End_Date__c = system.today()+20;
        sch.Scheme_Type__c = 'Specific';
        sch.Discount_Type__c='Cross Product Offer';
        sch.Product__c = prod1.Id;
        sch.Get_Product__c= prod2.Id;        
        sch.Buy__c=100;
        sch.Get__c=10;
        sch.Status__c='Approved';
        sch.Active__c=true;
        sch.State__c='Telangana';

 

        insert sch;

 

        //Creating Retailer Order
        Id retOrdRecTypId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();    
        
        Order retailerOrder = TestDataFactory.createOrder(retailerAccnt.Id, retOrdRecTypId);

 

        //Creating Order Item
        OrderItem oi=new OrderItem(Product2Id=prod1.Id,Quantity=100,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        insert oi;

 

           OrderItem newOi = [select Id,Quantity from OrderItem where Product2Id = :prod2.Id and OrderId = :retailerOrder.id];
        System.debug('Order Item Quantity is'+newOi.Quantity);
        System.assertEquals(10,newOi.Quantity);

 

    }
    @isTest Public static void lineOffersAmountCheck() {
        
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);

 

        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');

 

        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
       
        
        
        Id offerPerRecId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Amount Discount').getRecordTypeId();
        
        
        // Creating Qunatity Scheme
        Id schemeRecTypId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Quantity Discount').getRecordTypeId();
        Scheme__c sch =new Scheme__c();
        sch.Name = 'Buy 100 Get 10 for Test Product';
        sch.RecordTypeId = schemeRecTypId;
        sch.Active__c=True;
        sch.Start_Date__c = system.today()-10;
        sch.End_Date__c=system.today()+20;
        sch.Scheme_Type__c='Specific';
        sch.Discount_Type__c='Quantity';
        sch.Product__c=prod.Id;   
        sch.Buy__c=100;
        sch.Get__c=10;
        sch.Status__c='Approved';
        sch.Active__c=true;
        sch.State__c='Telangana';
        insert sch;
        //amount Scheme
        Scheme__c offerAmount =new Scheme__c();        
        //offerAmount.
        offerAmount.Name='Buy7000aboveGet700back';
        offerAmount.Start_Date__c=system.today()-30;
        offerAmount.RecordTypeId=offerPerRecId;
        offerAmount.End_Date__c=system.today()+30;
        offerAmount.Scheme_Type__c='Specific';
        offerAmount.Order_Amount__c=7000;
        offerAmount.Discount_Type__c='Amount';
        offerAmount.Discount_Amount__c=700;         
        offerAmount.Header_Discount__c=True;
        offerAmount.Status__c='Approved';
        offerAmount.Active__c=true;
        offerAmount.State__c='Telangana';
        offerAmount.Product__c=prod.id;
        insert offerAmount;

        //Creating Retailer Order
        Id retOrdRecTypId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();    
        
        Order retailerOrder = TestDataFactory.createOrder(retailerAccnt.Id, retOrdRecTypId);

 

        //Creating Order Item
        OrderItem oi=new OrderItem(Product2Id=prod.Id,Quantity=70,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        insert oi;
 
 		Order retOrd=[SELECT Discount_Amount__c FROM Order WHERE id=:retailerOrder.id];
        System.debug('From Amount ..discount is'+retOrd.Discount_Amount__c);
           OrderItem newOi = [select Id,Quantity,Applied_Offer__c from OrderItem where Id = :oi.Id];
        System.debug('From Amount sOrder Item Quantity is'+newOi.Quantity);
        //System.assertEquals('Buy7000aboveGet700back',retOrd.Applied_Offer__c);
        
 

    }
    
    
    
}