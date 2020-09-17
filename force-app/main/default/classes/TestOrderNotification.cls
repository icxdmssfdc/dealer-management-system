/*
* Author:- Somesh Mamidwar
* Created:- 16-09-2020
* Last Updated:- Test Class for Order Notifications Class
* Description:- 
*/
@isTest
public class TestOrderNotification {

    @isTest Public static void trackOrder(){
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //retailerAccnt.Phone = '+919014630847';
        //update retailerAccnt;
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        
        //Creating standard pricebook
        Id standardPb = Test.getStandardPricebookId();
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
        Id orderRTRetlr = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        Order retailerOrder=TestDataFactory.createOrder(retailerAccnt.Id, orderRTRetlr);
        
        retailerOrder.Account__c=dealerAccnt.Id;
        
        update retailerOrder;
        
        retailerOrder.Status = 'Approval Request';
        update retailerOrder;

        retailerOrder.Status = 'Booked';
        update retailerOrder;
        
         retailerOrder.Status = 'Out For Delivery';
        update retailerOrder;          
        
        retailerOrder.Status = 'Delivered';
        update retailerOrder;
        
        
        Id orderDealerRecTypId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Order dealerOrder=TestDataFactory.createOrder(dealerAccnt.Id, orderDealerRecTypId);
        
        dealerOrder.Status = 'Confirmed';
        dealerOrder.Channel__c = 'SalesRep';
        update dealerOrder;
        
    }
    
}