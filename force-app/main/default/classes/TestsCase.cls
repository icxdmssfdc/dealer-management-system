//@isTest(seeAllData = true)
@isTest public with sharing class TestsCase {  
    @isTest Public Static void createCase(){
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

        Id orderRTRetlr = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();

   		//Create Retailer Order
   		Order retailerOrder=TestDataFactory.createOrder(retailerAccnt.Id, orderRTRetlr);
        //Order retailerOrder=new Order(AccountId=retAcc.Id,recordTypeId=orderRTRetlr.Id,Status='Draft',EffectiveDate=system.today()-5,Pricebook2Id =standardPb);
        //insert retailerOrder;
        Id offerPerRecId = Schema.SObjectType.Scheme__c.getRecordTypeInfosByName().get('Promotional Offers').getRecordTypeId();                                                                                                                                                                                                      
        //RecordType offerPerRecId = [SELECT Id FROM RecordType WHERE sObjectType = 'Offers__c' AND Name ='Percentage Discount'];
        Coupon__c coup=new Coupon__c();
        coup.Active__c=true;
        coup.Name='Free FlightCoupon';
        coup.Valid_From__c=system.today()-10;
        coup.Valid_To__c=system.today()+30;
        insert coup;
        Scheme__c offerAmount =new Scheme__c(RecordTypeId=offerPerRecId,Start_Date__c=system.today()-30,Active__c=True,Name='Buy100000getfreecoupon');
        insert offerAmount;
        offerAmount.End_Date__c=system.today()+30;
        offerAmount.Scheme_Type__c='Specific';
        offerAmount.Order_Amount__c=1000;
        offerAmount.Discount_Type__c='Coupon';
        offerAmount.Coupon__c=coup.id;
        offerAmount.Header_Discount__c=True;
        offerAmount.Status__c='Approved';
        offerAmount.Active__c=true;
        offerAmount.State__c='Telangana';
        update offerAmount;
        retailerOrder.Applied_Scheme__c=offerAmount.id;
        update retailerOrder;
        OrderItem i=new OrderItem(Product2Id=prod.Id,Quantity=30,OrderId=retailerOrder.Id,UnitPrice=100,PricebookEntryId=standardPrice.id);
        insert i;
        order orderResult = [Select Applied_Scheme__c from order where Id =:retailerOrder.Id];
        //system.debug(orderresult.icxdms__Scheme__c);
        RecordType rcdtypeid=[SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Delayed Shipments'];
        system.debug(rcdtypeid.Id);
        Case newCase=new Case(Order__c=retailerOrder.id,RecordTypeId=rcdtypeid.Id,status='New');
        newCase.RecordTypeId=rcdtypeid.Id;
        
        insert newCase;
      
        Case caseResult = [Select AccountId,Scheme__c from Case where Id =:newCase.Id];
        //system.debug(Caseresult.AccountId);
        if(newCase.Scheme__c==''){
        newCase.Scheme__c=retailerOrder.Applied_Scheme__c;
        update newCase;
        }
        System.assertEquals(retailerOrder.AccountId,caseResult.AccountId,'');
        //System.assertEquals(retailerOrder.Applied_Scheme__c,caseResult.Scheme__c,'');
    }
}