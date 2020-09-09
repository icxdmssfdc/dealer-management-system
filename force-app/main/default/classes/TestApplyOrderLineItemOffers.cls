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

        //Creating Retailer Order
        Id retOrdRecTypId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();    
        
        Order retailerOrder = TestDataFactory.createOrder(retailerAccnt.Id, retOrdRecTypId);

        //Creating Order Item
        OrderItem oi=new OrderItem(Product2Id=prod.Id,Quantity=100,OrderId=retailerOrder.id,UnitPrice=100,ListPrice=100,PricebookEntryId=standardPrice.id);
        insert oi;

       	OrderItem newOi = [select Id,Quantity from OrderItem where Id = :oi.Id];
        System.debug('Order Item Quantity is'+newOi.Quantity);
		System.assertEquals(110,newOi.Quantity);

    }
    
    
}