@isTest public with sharing class TestApplyOrderOffers {
    @isTest Public static void lineOffers(){
        //Distributor Account Insertion
        Id accDistRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account distAcc=new Account(Name='DistrbAccnt',recordTypeId=accDistRecId,Credit_Limit__c=20000);
        insert distAcc;
        //Retailer Account Insertion
        Id accRetRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();

        Account retAcc=new Account(Name='RetailerAccnt',ParentId=distAcc.Id,recordTypeId=accRetRecId);
        insert retAcc;
        
        // Adding Products
        Product2 p1=new Product2(Name='Fruitnik 50ml',Family='Beverages',IsActive=true,productCode='BEV');
        insert p1;
        
        Product2 p2=new Product2(Name='Fruitnik 200ml',Family='Beverages',IsActive=true,productCode='BEV');
        insert p2;
   
        Id standardPb = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id =standardPb;// Test.getStandardPricebookId();//standardPB1;//standardPb.Id;
        standardPrice.Product2Id = p2.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
        System.debug('Id 3 is'+standardPrice.Pricebook2Id);

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

        Order retailerOrder=new Order(AccountId=retAcc.Id,recordTypeId=orderRTRetlr,Status='Draft',EffectiveDate=system.today()-5,Pricebook2Id =standardPb);
        insert retailerOrder;retailerOrder.Account__c=distAcc.Id;update retailerOrder;

        
        //System.debug('Id 2 is'+retailerOrder.PriceBook2Id);
        
        OrderItem i=new OrderItem(Product2Id=p2.Id,Quantity=100,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        //i.TotalPrice=i.Quantity*i.UnitPrice;
        //i.ListPrice=100;
        insert i;
        System.debug('total price is'+i.TotalPrice+'ret ord'+retailerOrder.TotalAmount);
        System.debug('inserted order id is'+i+'order is'+retailerOrder);
        Order OrdFields=[SELECT Discount_Amount__c FROM Order WHERE Id=:retailerOrder.id];
    // System.assertEquals('Buy 1000 above Get 10% Off', retailerOrder.Applied_Offer__c,'percentoffer');//Scheme__c	'Buy 1000 above,Get 10% Off'
    System.debug('discount amount is'+OrdFields.Discount_Amount__c);     
    System.assertEquals(1000,OrdFields.Discount_Amount__c);
       
    }
    @isTest Public static void AmountCheck(){
        System.debug('I am from amountceck');
        //Distributor Account Insertion
        Id accDistRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account distAcc=new Account(Name='DistrbAccnt',recordTypeId=accDistRecId,Credit_Limit__c=20000);
        insert distAcc;
        //Retailer Account Insertion
        Id accRetRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();

        Account retAcc=new Account(Name='RetailerAccnt',ParentId=distAcc.Id,recordTypeId=accRetRecId);
        insert retAcc;
        
        // Adding Products
        Product2 p1=new Product2(Name='Fruitnik 50ml',Family='Beverages',IsActive=true,productCode='BEV');
        insert p1;
        
        Product2 p2=new Product2(Name='Fruitnik 200ml',Family='Beverages',IsActive=true,productCode='BEV');
        insert p2;
   
        Id standardPb = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id =standardPb;// Test.getStandardPricebookId();//standardPB1;//standardPb.Id;
        standardPrice.Product2Id = p2.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
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

        Order retailerOrder=new Order(AccountId=retAcc.Id,recordTypeId=orderRTRetlr,Status='Draft',EffectiveDate=system.today()-5,Pricebook2Id =standardPb);
        insert retailerOrder;retailerOrder.Account__c=distAcc.Id;update retailerOrder;        
        //System.debug('Id 2 is'+retailerOrder.PriceBook2Id);
        
        OrderItem i=new OrderItem(Product2Id=p2.Id,Quantity=100,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
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
        //Distributor Account Insertion
        Id accDistRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        //RecordType AccDistRecId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Dealer'];
        Account distAcc=new Account(Name='DistrbAccnt',recordTypeId=accDistRecId,Credit_Limit__c=20000);
        insert distAcc;
        //Retailer Account Insertion
        Id accRetRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();

        Account retAcc=new Account(Name='RetailerAccnt',ParentId=distAcc.Id,recordTypeId=accRetRecId);
        insert retAcc;
        
        // Adding Products
        Product2 p1=new Product2(Name='Fruitnik 50ml',Family='Beverages',IsActive=true,productCode='BEV');
        insert p1;
        
        Product2 p2=new Product2(Name='Fruitnik 200ml',Family='Beverages',IsActive=true,productCode='BEV');
        insert p2;
   
        //Pricebook2  standardPb = [select id from Pricebook2 where IsStandard = true];//Name='Standard Price Book'];//IsStandard = true limit 1];

        //Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where Name='Standard Price Book'];//IsStandard = true limit 1];
        //insert standardPb;
        Id standardPb = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id =standardPb;// Test.getStandardPricebookId();//standardPB1;//standardPb.Id;
        standardPrice.Product2Id = p2.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
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

        //RecordType OrderRTRetlr = [SELECT Id FROM RecordType WHERE sObjectType = 'Order' AND Name = 'Retailer'];
        Order retailerOrder=new Order(AccountId=retAcc.Id,recordTypeId=orderRTRetlr,Status='Draft',EffectiveDate=system.today()-5,Pricebook2Id =standardPb);
        insert retailerOrder;retailerOrder.Account__c=distAcc.Id;update retailerOrder;        
        //System.debug('Id 2 is'+retailerOrder.PriceBook2Id);
        
        OrderItem i=new OrderItem(Product2Id=p2.Id,Quantity=1000,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        //i.TotalPrice=i.Quantity*i.UnitPrice;
        //i.ListPrice=100;
        insert i;
        //em.debug('Percentage amount offer total price is'+i.TotalPrice+'ret ord'+retailerOrder.TotalAmount);
       //ystem.debug('inserted order id is'+i+'order is'+retailerOrder);
        Order OrdFields=[SELECT Applied_Offer__c FROM Order WHERE Id=:retailerOrder.id];
        System.assertEquals('Buy100000getfreecoupon', OrdFields.Applied_Offer__c,'couponoffer');//Scheme__c	'Buy 1000 above,Get 10% Off'
        System.debug('discount amount is'+retailerOrder.Discount_Amount__c);
       // Issued_Coupons__c isc=new Issued_Coupons__c();
        
      //  if(retailerOrder.Coupon_Id__c==''){
       // retailerOrder.Issued_Coupon__c = null;
       // }
    }
}