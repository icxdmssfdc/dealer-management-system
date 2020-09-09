@isTest public with sharing class TestApplyOrderOffers {
    @isTest Public static void lineOffers(){
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        
        //Creating standard pricebook
        Id standardPb = Test.getStandardPricebookId();
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
        Id offerPerRecId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Percentage Discount').getRecordTypeId();
        
        Scheme__c offerPercentage =new Scheme__c(RecordTypeId=offerPerRecId,Name='Buy 1000 above Get 10% Off',Start_Date__c=system.today()-30,Active__c=True);
        insert offerPercentage;
        offerPercentage.Scheme_Type__c='Specific';
        offerPercentage.Order_Amount__c=10000;
        offerPercentage.Discount_Type__c='Percentage';
        offerPercentage.Discount_Percentage__c=10;   
        offerPercentage.End_Date__c=system.today()+20;
        offerPercentage.Header_Discount__c=True;
        offerPercentage.Status__c='Approved';
        offerPercentage.Active__c=true;
        offerPercentage.State__c='Telangana';
        update offerPercentage;
        
        System.debug('Percentage offer inserted is'+offerPercentage);
        Id orderRTRetlr = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        
        Order retailerOrder=new Order(AccountId=retailerAccnt.Id,recordTypeId=orderRTRetlr,Status='Draft',EffectiveDate=system.today()-5,Pricebook2Id =standardPb);
        insert retailerOrder;retailerOrder.Account__c=dealerAccnt.Id;update retailerOrder;       
        //System.debug('Id 2 is'+retailerOrder.PriceBook2Id);
        
        OrderItem i=new OrderItem(Product2Id=prod.Id,Quantity=100,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        //i.TotalPrice=i.Quantity*i.UnitPrice;
        //i.ListPrice=100;
        insert i;
        System.debug('total price is'+i.TotalPrice+'ret ord'+retailerOrder.TotalAmount);
        System.debug('inserted order id is'+i+'order is'+retailerOrder);
        system.debug('removing coupon');       
        Order OrdFields=[SELECT Discount_Amount__c FROM Order WHERE Id=:retailerOrder.id];
        // System.assertEquals('Buy 1000 above Get 10% Off', retailerOrder.Applied_Offer__c,'percentoffer');//Scheme__c	'Buy 1000 above,Get 10% Off'
        System.debug('discount amount is'+OrdFields.Discount_Amount__c);     
        System.assertEquals(1000,OrdFields.Discount_Amount__c);
        
    }
    @isTest Public static void AmountCheck(){
        System.debug('I am from amountceck');
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        
        //Creating standard pricebook
        Id standardPb = Test.getStandardPricebookId();
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
        System.debug('Id 3 is'+standardPrice.Pricebook2Id);
        
        Id offerPerRecId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Amount Discount').getRecordTypeId();
        
        Scheme__c offerAmount =new Scheme__c(RecordTypeId=offerPerRecId,Name='Buy1000aboveGet100back',Start_Date__c=system.today()-30,Active__c=True);
        insert offerAmount;
        offerAmount.End_Date__c=system.today()+30;
        offerAmount.Scheme_Type__c='Specific';
        offerAmount.Order_Amount__c=1000;
        offerAmount.Discount_Type__c='Amount';
        offerAmount.Discount_Amount__c=100;   
        //offerAmount.End_Date__c=system.today()+20;
        offerAmount.Header_Discount__c=True;
        offerAmount.Status__c='Approved';
        offerAmount.Active__c=true;
        offerAmount.State__c='Telangana';
        update offerAmount;
        
        System.debug('Percentage offer inserted is'+offerAmount);
        Id orderRTRetlr = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        
        Order retailerOrder=new Order(AccountId=retailerAccnt.Id,recordTypeId=orderRTRetlr,Status='Draft',EffectiveDate=system.today()-5,Pricebook2Id =standardPb);
        insert retailerOrder;retailerOrder.Account__c=dealerAccnt.Id;update retailerOrder;        
        //System.debug('Id 2 is'+retailerOrder.PriceBook2Id);
        
        OrderItem i=new OrderItem(Product2Id=prod.Id,Quantity=100,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        //i.TotalPrice=i.Quantity*i.UnitPrice;
        //i.ListPrice=100;
        insert i;
        Order OrdFields=[SELECT Discount_Amount__c FROM Order WHERE Id=:retailerOrder.id];
        
        
        System.debug('Percentage amount offer total price is'+i.TotalPrice+'ret ord'+retailerOrder.TotalAmount);
        System.debug('inserted order id is'+i+'order is'+retailerOrder);
        //System.assertEquals('Buy1000aboveGet100back',retailerOrder.Applied_Offer__c,'');//1000 above,Get 10% Off'
        
        System.assertEquals(100,OrdFields.Discount_Amount__c,'amountoffer');
        //System.debug('discount is 100');
    }
    @isTest Public static void CouponCheck(){
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        
        //Creating standard pricebook
        Id standardPb = Test.getStandardPricebookId();
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
        System.debug('Id 3 is'+standardPrice.Pricebook2Id);
        
        Coupon__c coup=new Coupon__c();
        coup.Active__c=true;
        coup.Name='Free FlightCoupon';
        coup.Valid_From__c=system.today()-10;
        coup.Valid_To__c=system.today()+30;
        insert coup;
        Id offerPerRecId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Promotional Offers').getRecordTypeId();
        //RecordType offerPerRecId = [SELECT Id FROM RecordType WHERE sObjectType = 'Offers__c' AND Name ='Percentage Discount'];
        
        Scheme__c offerAmount =new Scheme__c(RecordTypeId=offerPerRecId,Start_Date__c=system.today()-30,Active__c=True,Name='Buy100000getfreecoupon');
        insert offerAmount;
        offerAmount.End_Date__c=system.today()+30;
        offerAmount.Scheme_Type__c='Specific';
        offerAmount.Order_Amount__c=100000;
        offerAmount.Discount_Type__c='Coupon';
        offerAmount.Coupon__c=coup.id;
        offerAmount.Header_Discount__c=True;
        offerAmount.Status__c='Approved';
        offerAmount.Active__c=true;
        offerAmount.State__c='Telangana';
        update offerAmount;
        
        System.debug('Percentage offer inserted is'+offerAmount);
        Id orderRTRetlr = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        Order retailerOrder=TestDataFactory.createOrder(retailerAccnt.Id, orderRTRetlr);
        
        retailerOrder.Account__c=dealerAccnt.Id;update retailerOrder;        
        //System.debug('Id 2 is'+retailerOrder.PriceBook2Id);
        
        OrderItem i=new OrderItem(Product2Id=prod.Id,Quantity=1000,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        
        insert i;
        
        
        //system.debug('Percentage amount offer total price is'+i.TotalPrice+'ret ord'+retailerOrder.TotalAmount);
        //system.debug('inserted order id is'+i+'order is'+retailerOrder);
        Order OrdFields=[SELECT Applied_Offer__c FROM Order WHERE Id=:retailerOrder.id];
        System.assertEquals('Buy100000getfreecoupon', OrdFields.Applied_Offer__c,'couponoffer');//Scheme__c	'Buy 1000 above,Get 10% Off'
        System.debug('discount amount is'+retailerOrder.Discount_Amount__c);
        
    }
    @isTest Public static void NoOffer(){
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        
        //Creating standard pricebook
        Id standardPb = Test.getStandardPricebookId();
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
        System.debug('Id 3 is'+standardPrice.Pricebook2Id);
        
        Coupon__c coup=new Coupon__c();
        coup.Active__c=true;
        coup.Name='Free FlightCoupon';
        coup.Valid_From__c=system.today()-10;
        coup.Valid_To__c=system.today()+30;
        insert coup;
        Id offerPerRecId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Promotional Offers').getRecordTypeId();
        //RecordType offerPerRecId = [SELECT Id FROM RecordType WHERE sObjectType = 'Offers__c' AND Name ='Percentage Discount'];
        
        Scheme__c offerAmount =new Scheme__c(RecordTypeId=offerPerRecId,Start_Date__c=system.today()-30,Active__c=True,Name='Buy100000getfreecoupon');
        insert offerAmount;
        offerAmount.End_Date__c=system.today()+30;
        offerAmount.Scheme_Type__c='Specific';
        offerAmount.Order_Amount__c=100000;
        offerAmount.Discount_Type__c='Coupon';
        offerAmount.Coupon__c=coup.id;
        offerAmount.Header_Discount__c=True;
        offerAmount.Status__c='Approved';
        offerAmount.Active__c=true;
        offerAmount.State__c='Telangana';
        update offerAmount;
        
        System.debug('Percentage offer inserted is'+offerAmount);
        Id orderRTRetlr = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        Order retailerOrder=TestDataFactory.createOrder(retailerAccnt.Id, orderRTRetlr);
        
        retailerOrder.Account__c=dealerAccnt.Id;update retailerOrder;        
        //System.debug('Id 2 is'+retailerOrder.PriceBook2Id);
        
        OrderItem i=new OrderItem(Product2Id=prod.Id,Quantity=1000,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        
        insert i;
        i.Quantity=10;
        update i;
        
        //system.debug('Percentage amount offer total price is'+i.TotalPrice+'ret ord'+retailerOrder.TotalAmount);
        //system.debug('inserted order id is'+i+'order is'+retailerOrder);
        Order OrdFields=[SELECT Applied_Offer__c FROM Order WHERE Id=:retailerOrder.id];
        System.assertEquals(null, OrdFields.Applied_Offer__c,'couponoffer');//Scheme__c	'Buy 1000 above,Get 10% Off'
        System.debug('discount amount is'+retailerOrder.Discount_Amount__c);
        
    }
}