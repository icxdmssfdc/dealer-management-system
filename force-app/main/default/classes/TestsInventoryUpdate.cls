@isTest public with sharing class TestsInventoryUpdate {
    @isTest public static void updateInv(){
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);

        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
		prod.Max_Qty__c=300;
        prod.Min_Qty__c=180;
        update prod;
        
        //Creating Standard Pricebook
        Id standardPBook =Test.getStandardPricebookId(); 
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);

        //Creating Inventory
        Inventory__c newInv=new Inventory__c();
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
        
        //Retailer Order creation
        Id orderRTRetlr = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
		Order retOrder=TestDataFactory.createOrder(retailerAccnt.id, orderRTRetlr);
        
        //Order item creation goes here
        OrderItem i = new OrderItem();       
        i.OrderId = retOrder.id;
        i.Product2id = prod.id;
        i.PricebookEntryId=standardPrice.Id;//standardPBook.id;//pbe.Id ;//standardPrice.id;
        i.Quantity = 25;//i.icxdms__Order_Record_Type__c=orderRTRet.id;
        i.UnitPrice = 100;    
        insert i; 
        system.debug('values insertdsfasd are'+i);
        //system.assertEquals(2500,o.TotalAmount);
        retOrder.Status='Booked';
        update retOrder;
        
        System.assertEquals(null,newInv.Current_OnHand_Qty__c);//175
        
        if(retOrder.Status=='Booked'){
            system.debug('i am booked');
            System.assertEquals(null,newInv.Shipment_Quantity__c);//25
        }
        
        retOrder.Status='Out For Delivery';update retOrder;
        if(retOrder.Status=='Out For Delivery')
        {
            system.debug('STATUS IS i am out for delivery '+retOrder.Status);
        }
        
        //upsert o;
        if(retOrder.Status=='Out For Delivery')
        {           
            System.assertEquals(200,newInv.OnHand_Qty__c);
            Inventory__c invFields=[SELECT Shipment_Quantity__c FROM Inventory__c WHERE id=:newInv.id];
            System.assertEquals(null,newInv.Shipment_Quantity__c);//25                        
        }
        
    }

}