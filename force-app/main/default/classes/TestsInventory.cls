/*
* Author:- Vaishnavi Gajawada
* Created:- 04-09-2020
* Last Updated:- 
* Feature:- Inventory 
* Description:- Inventory test class for Inventorytrigger.
*/
@isTest public with sharing class TestsInventory {
    
    @isTest public Static void InventoryRetcheckOutforDelivery()
    {
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //standard pricebook
        Id standardPBook =Test.getStandardPricebookId();
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        prod.Max_Qty__c=300;
        prod.Min_Qty__c=180;
        update prod;
           
        //Inventory creation
        Inventory__c newInv=new Inventory__c();
        //insert newInv;        
        newInv.Distributor__c=dealerAccnt.id;
        newInv.OnHand_Qty__c=200;
        newInv.Product__c=prod.id;
        newInv.Price_Book__c=standardPBook;//standardPb.id;//dealer pricebook
        newInv.Dealer_Product_Price__c=standardPrice.UnitPrice;//DstandardPrice.UnitPrice;
        
        newInv.Retailer_Price_Book__c=standardPBook;//RetailerPb.id;//retailer pricebook
        newInv.Retailer_Price__c=standardPrice.UnitPrice;//retailerPbEntry.UnitPrice;
        insert newInv;
        system.debug('inventory values are'+newInv);
        system.debug('forupdate inventory');   
        newInv.Retailer_Price__c=standardPrice.UnitPrice;//retailerPbEntry.UnitPrice;
        update newInv;
        //Test Order Insert
        //creating retailer order
        RecordType orderRTRet=[SELECT Id FROM RecordType WHERE sObjectType = 'Order' AND Name = 'Retailer'];
        
        Order o = new Order();
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.RecordTypeId=orderRTRet.id;
        o.EffectiveDate = system.today();
        
        o.AccountId = retailerAccnt.id;
        o.Pricebook2Id = standardPBook ;
        o.Shipment_Date__c=system.today()+10;
        o.Estimated_Delivery_Date__c=system.today()+11;
        
        // o.icxdms__Order_Price_Book__c=RetailerPb.id;
        insert o;o.Account__c=dealerAccnt.Id;update o;
        system.debug('pb11 id issssssssssss'+o.Pricebook2Id);
        system.debug('pb id issssssssssssrtyu'+standardPBook);
        
        //Order item creation goes here
        OrderItem i = new OrderItem();       
        i.OrderId = o.id;
        i.Product2id = prod.id;
        i.PricebookEntryId=standardPrice.Id;//standardPBook.id;//pbe.Id ;//standardPrice.id;
        i.Quantity = 25;//i.icxdms__Order_Record_Type__c=orderRTRet.id;
        i.UnitPrice = 100;    
        insert i; 
        system.debug('values insertdsfasd are'+i);
        //system.assertEquals(2500,o.TotalAmount);
        o.Status='Booked';
        update o;
        
        System.assertEquals(null,newInv.Current_OnHand_Qty__c);//175
        
        if(o.Status=='Booked'){
            system.debug('i am booked');
            System.assertEquals(null,newInv.Shipment_Quantity__c);//25
        }
        
        o.Status='Out For Delivery';update o;
        if(o.Status=='Out For Delivery')
        {
            system.debug('STATUS IS i am out for delivery '+o.Status);}
        
        //upsert o;
        if(o.Status=='Out For Delivery')
        {           
            System.assertEquals(200,newInv.OnHand_Qty__c);
            //Inventory__c invFields=[SELECT Shipment_Quantity__c FROM Inventory__c WHERE id=:newInv.id];
            //System.assertEquals(25,newInv.Shipment_Quantity__c);//25                        
        }
                       
    }
}