@isTest public with sharing class TestsInventory {
    //public TestsInventory() {

    //}
    //@isTest(seeAllData=true) 
//public class Test_InventoryTrigger 
//{   
    @isTest public Static void InventoryRetcheck()
    {
        //Distributor Account
        RecordType AccRTDist = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Dealer'];
        Account DistAcc=new Account(Name='Gaja',recordTypeId=AccRTDist.id,Credit_Limit__c=20000);
        insert DistAcc;        
        //retailer account
        RecordType AccRTRet=[SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Retailer'];
        Account RetailerAcc=new Account(Name='shiva',ParentId=DistAcc.id,recordTypeId=AccRTRet.id);
        insert RetailerAcc;//'0122v000002AYRFAA4'
        //product
        Product2 painbalm=new Product2(Name='Pain Balm',Family='Pain Management',Product_Classification__c='A',IsActive=true);
        painbalm.Max_Qty__c=300;
        painbalm.Min_Qty__c=180;
        insert painbalm;
        //standard pricebook
        //Pricebook2 standardPBook = [select id from Pricebook2 where isStandard=true limit 1];
        Id standardPBook=Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBook, Product2Id = painbalm.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);//'01s2v00000L2BllAAF'
        insert standardPrice;
        //dealer pricebook
        Pricebook2 standardPb=new Pricebook2(Name='Dealer',IsActive=true);//standardPb.IsStandard=true;
        insert standardPb;
        //dealer pricebook entry
        PricebookEntry DstandardPrice = new PricebookEntry();
        DstandardPrice.Pricebook2Id = standardPb.Id;
        DstandardPrice.Product2Id = painbalm.Id;
        DstandardPrice.UnitPrice = 100;
        DstandardPrice.IsActive = true;
        DstandardPrice.UseStandardPrice = false;
        insert DstandardPrice;
        
        //retailer pricebook
        Pricebook2 RetailerPb=new Pricebook2(Name='Retailer',IsActive=true);
        insert RetailerPb;
        //retailer pricebook entry
        PricebookEntry retailerPbEntry = new PricebookEntry();
        retailerPbEntry.Pricebook2Id = RetailerPb.id;
        retailerPbEntry.Product2Id = painbalm.id;
        retailerPbEntry.UnitPrice = 150;
        retailerPbEntry.IsActive = true;
        retailerPbEntry.UseStandardPrice = false;
        insert retailerPbEntry ;
        
        //Inventory creation
        Inventory__c newInv=new Inventory__c(Distributor__c=DistAcc.Id,Product__c=painbalm.Id);
        //insert newInv;        
        newInv.Distributor__c=DistAcc.id;
        newInv.OnHand_Qty__c=200;
        newInv.Product__c=painbalm.id;
        newInv.Price_Book__c=standardPb.id;//dealer pricebook
        newInv.Dealer_Product_Price__c=DstandardPrice.UnitPrice;
        
        newInv.Retailer_Price_Book__c=RetailerPb.id;//retailer pricebook
        newInv.Retailer_Price__c=retailerPbEntry.UnitPrice;
        insert newInv;
        system.debug('inventory values are'+newInv);
        

        
        //Test Order Insert
        //creating retailer order
        RecordType orderRTRet=[SELECT Id FROM RecordType WHERE sObjectType = 'Order' AND Name = 'Retailer'];
        
        Order o = new Order();
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.RecordTypeId=orderRTRet.id;
        o.EffectiveDate = system.today();
        //o.EndDate = system.today() + 4;
        o.AccountId = RetailerAcc.id;
        o.Pricebook2Id = RetailerPb.Id ;
        o.Shipment_Date__c=system.today()+10;
        o.Estimated_Delivery_Date__c=system.today()+11;
        
        // o.icxdms__Order_Price_Book__c=RetailerPb.id;
        insert o;o.Account__c=DistAcc.Id;update o;
        system.debug('pb11 id issssssssssss'+o.Pricebook2Id);
        system.debug('pb id issssssssssssrtyu'+RetailerPb.Id);
        
        // PriceBookEntry pbe = [SELECT id FROM PricebookEntry 
        //WHERE Product2Id =: painbalm.id AND Pricebook2Id =: RetailerPb.Id];
        //system.debug('pb entry id is'+pbe);Pricebookentry entry = [SELECT Id,unitprice FROM PricebookEntry WHERE Pricebook2Id = :standardBook.Id AND Product2.ProductCode = 'ALW'];
        
        OrderItem i = new OrderItem();       
        i.OrderId = o.id;
        i.Product2id = painbalm.id;
        i.PricebookEntryId=retailerPbEntry.Id;//standardPBook.id;//pbe.Id ;//standardPrice.id;
        i.Quantity = 25;//i.icxdms__Order_Record_Type__c=orderRTRet.id;
        i.UnitPrice = 100;    
        /* try{
insert i;
}
catch (Exception e)
{
e.getMessage();
}*/        insert i; 
        system.debug('values insertdsfasd are'+i);
        //system.assertEquals(2500,o.TotalAmount);
        o.Status='Booked';
        update o;
        // system.debug('pb id issssssssssssrtyu'+standardPBook.id);
        
        //system.assertEquals(RetailerPb.id,o.Pricebook2Id,'aaaaaaaaaaaaaaaaaachecking price book was modified after it was inserted');
        
        //system.debug('onhand quantity is'+newInv.icxdms__Current_OnHand_Qty__c);
        //System.assertEquals(100,standardPrice.UnitPrice);        
        //System.assertEquals(100,newInv.icxdms__Product_Price__c);
        System.assertEquals(null,newInv.Current_OnHand_Qty__c);//175
        
        if(o.Status=='Booked'){
            system.debug('i am booked');
            System.assertEquals(null,newInv.Shipment_Quantity__c);//25
        }
        //update o;
        o.Status='Out for delivery';
        //upsert o;
        if(o.Status=='Out for delivery')
        {
            if(o.AccountId==RetailerAcc.id && o.RecordTypeId==orderRTRet.id)
            {
                Account ordAcc = [Select Id,ParentId from Account where Id =:RetailerAcc.id];
                String sDistributorId = ordAcc.ParentId;
                
            }
            System.assertEquals(200,newInv.OnHand_Qty__c);
            
        }
        // System.assertEquals(175,newInv.icxdms__Current_OnHand_Qty__c);
        
        
    }
     @isTest public Static void InventoryRetcheckOutforDelivery()
    {
        //Distributor Account
        RecordType AccRTDist = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Dealer'];
        Account DistAcc=new Account(Name='Gaja',recordTypeId=AccRTDist.id,Credit_Limit__c=20000);
        insert DistAcc;        
        //retailer account
        RecordType AccRTRet=[SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Retailer'];
        Account RetailerAcc=new Account(Name='shiva',ParentId=DistAcc.id,recordTypeId=AccRTRet.id);
        insert RetailerAcc;//'0122v000002AYRFAA4'
        //product
        Product2 painbalm=new Product2(Name='Pain Balm',Family='Pain Management',Product_Classification__c='A',IsActive=true);
        painbalm.Max_Qty__c=300;
        painbalm.Min_Qty__c=180;
        insert painbalm;
        //standard pricebook
       // Pricebook2 standardPBook = [select id from Pricebook2 where isStandard=true limit 1];
        Id standardPBook =Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBook, Product2Id = painbalm.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);//'01s2v00000L2BllAAF'
        insert standardPrice;
        //dealer pricebook
        Pricebook2 standardPb=new Pricebook2(Name='Dealer',IsActive=true);//standardPb.IsStandard=true;
        insert standardPb;
        //dealer pricebook entry
        PricebookEntry DstandardPrice = new PricebookEntry();
        DstandardPrice.Pricebook2Id = standardPb.Id;
        DstandardPrice.Product2Id = painbalm.Id;
        DstandardPrice.UnitPrice = 100;
        DstandardPrice.IsActive = true;
        DstandardPrice.UseStandardPrice = false;
        insert DstandardPrice;
 
        //retailer pricebook
        Pricebook2 RetailerPb=new Pricebook2(Name='Retailer',IsActive=true);
        insert RetailerPb;
        //retailer pricebook entry
        PricebookEntry retailerPbEntry = new PricebookEntry();
        retailerPbEntry.Pricebook2Id = RetailerPb.id;
        retailerPbEntry.Product2Id = painbalm.id;
        retailerPbEntry.UnitPrice = 150;
        retailerPbEntry.IsActive = true;
        retailerPbEntry.UseStandardPrice = false;
        insert retailerPbEntry ;
        
        //Inventory creation
        Inventory__c newInv=new Inventory__c(Distributor__c=DistAcc.Id,Product__c=painbalm.Id);
        //insert newInv;        
        newInv.Distributor__c=DistAcc.id;
        newInv.OnHand_Qty__c=200;
        newInv.Product__c=painbalm.id;
        newInv.Price_Book__c=standardPb.id;//dealer pricebook
        newInv.Dealer_Product_Price__c=DstandardPrice.UnitPrice;
        
        newInv.Retailer_Price_Book__c=RetailerPb.id;//retailer pricebook
        newInv.Retailer_Price__c=retailerPbEntry.UnitPrice;
        insert newInv;
        system.debug('inventory values are'+newInv);
        system.debug('forupdate inventory');
        
        //newInv.icxdms__Product_Price__c=standardPBook.UnitPrice;
        newInv.Retailer_Price__c=retailerPbEntry.UnitPrice;
        update newInv;
        //Test Order Insert
        //creating retailer order
        RecordType orderRTRet=[SELECT Id FROM RecordType WHERE sObjectType = 'Order' AND Name = 'Retailer'];
        
        Order o = new Order();
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.RecordTypeId=orderRTRet.id;
        o.EffectiveDate = system.today();
        //o.EndDate = system.today() + 4;
        o.AccountId = RetailerAcc.id;
        o.Pricebook2Id = RetailerPb.Id ;
        o.Shipment_Date__c=system.today()+10;
        o.Estimated_Delivery_Date__c=system.today()+11;
        
        // o.icxdms__Order_Price_Book__c=RetailerPb.id;
        insert o;o.Account__c=DistAcc.Id;update o;
        system.debug('pb11 id issssssssssss'+o.Pricebook2Id);
        system.debug('pb id issssssssssssrtyu'+RetailerPb.Id);
        
        // PriceBookEntry pbe = [SELECT id FROM PricebookEntry 
        //WHERE Product2Id =: painbalm.id AND Pricebook2Id =: RetailerPb.Id];
        //system.debug('pb entry id is'+pbe);Pricebookentry entry = [SELECT Id,unitprice FROM PricebookEntry WHERE Pricebook2Id = :standardBook.Id AND Product2.ProductCode = 'ALW'];
        
        OrderItem i = new OrderItem();       
        i.OrderId = o.id;
        i.Product2id = painbalm.id;
        i.PricebookEntryId=retailerPbEntry.Id;//standardPBook.id;//pbe.Id ;//standardPrice.id;
        i.Quantity = 25;//i.icxdms__Order_Record_Type__c=orderRTRet.id;
        i.UnitPrice = 100;    
        /* try{
insert i;
}
catch (Exception e)
{
e.getMessage();
}*/        insert i; 
        system.debug('values insertdsfasd are'+i);
        //system.assertEquals(2500,o.TotalAmount);
        o.Status='Booked';
        update o;
        // system.debug('pb id issssssssssssrtyu'+standardPBook.id);
        
        //system.assertEquals(RetailerPb.id,o.Pricebook2Id,'aaaaaaaaaaaaaaaaaachecking price book was modified after it was inserted');
        
        //system.debug('onhand quantity is'+newInv.icxdms__Current_OnHand_Qty__c);
        //System.assertEquals(100,standardPrice.UnitPrice);        
        //System.assertEquals(100,newInv.icxdms__Product_Price__c);
        System.assertEquals(null,newInv.Current_OnHand_Qty__c);//175
        
        if(o.Status=='Booked'){
            system.debug('i am booked');
            System.assertEquals(null,newInv.Shipment_Quantity__c);//25
        }
        //update o;
        //o.icxdms__Planned_Shipment_Date__c=system.today()+10;
        //o.icxdms__Estimated_Delivery_Date__c=system.today()+11;
        //o.icxdms__Deliverd_Date__c=system.today()+12;
        // o;
        o.Status='Out For Delivery';update o;
                if(o.Status=='Out For Delivery')
                {
                    system.debug('STATUS IS i am out for delivery '+o.Status);}

        //upsert o;
        if(o.Status=='Out For Delivery')
        {
           /* if(o.AccountId==RetailerAcc.id && o.RecordTypeId==orderRTRet.id)
            {
                Account ordAcc = [Select Id,ParentId from Account where Id =:RetailerAcc.id];
                String sDistributorId = ordAcc.ParentId;
                
            }*/
            System.assertEquals(200,newInv.OnHand_Qty__c);
                        System.assertEquals(null,newInv.Shipment_Quantity__c);//25

            
        }
         System.assertEquals(null,newInv.Current_OnHand_Qty__c);
        
        
    }
    
   
    
    @isTest public Static void CheckDistInventory(){
        //Distributor Account
        RecordType AccRTDist = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Dealer'];
        Account DistAcc=new Account(Name='Gaja',recordTypeId=AccRTDist.id,Credit_Limit__c=20000);
        insert DistAcc;        
        //product
        Product2 painbalm=new Product2(Name='Pain Balm',Family='Pain Management',Product_Classification__c='A',IsActive=true);
        painbalm.Max_Qty__c=300;
        painbalm.Min_Qty__c=180;
        insert painbalm;
        //standard pricebook
        //Pricebook2 standardPBook = [select id from Pricebook2 where isStandard=true limit 1];
        Id standardPBook=Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBook, Product2Id = painbalm.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);//'01s2v00000L2BllAAF'
        insert standardPrice;
        //dealer pricebook
        Pricebook2 standardPb=new Pricebook2(Name='Dealer',IsActive=true);//standardPb.IsStandard=true;
        insert standardPb;
        //dealer pricebook entry
        PricebookEntry DtandardPrice = new PricebookEntry();
        DtandardPrice.Pricebook2Id = standardPb.Id;
        DtandardPrice.Product2Id = painbalm.Id;
        DtandardPrice.UnitPrice = 100;
        DtandardPrice.IsActive = true;
        DtandardPrice.UseStandardPrice = false;
        insert DtandardPrice;
        //Inventory creation
        Inventory__c newInv=new Inventory__c(Distributor__c=DistAcc.Id,Product__c=painbalm.Id);
        //insert newInv;        
        newInv.Distributor__c=DistAcc.id;
        newInv.OnHand_Qty__c=200;
        newInv.Product__c=painbalm.id;
        newInv.Price_Book__c=standardPb.id;//dealer pricebook
        newInv.Dealer_Product_Price__c=DtandardPrice.UnitPrice;
        
        //newInv.icxdms__Retailer_Price_Book__c=RetailerPb.id;//retailer pricebook
        //newInv.icxdms__Retailer_Price__c=retailerPbEntry.UnitPrice;
        insert newInv;
        RecordType dealordrt=[SELECT Id FROM RecordType WHERE sObjectType = 'Order' AND Name = 'Dealer'];
        
        //creating dealer order
        Order o = new Order();
        o.Name = 'Test Order ';
        o.Status = 'Draft';
        o.EffectiveDate = system.today();
        o.RecordTypeId=dealordrt.id;
        //o.EndDate = system.today() + 4;
        o.AccountId = DistAcc.id;
        o.Pricebook2Id = standardPb.Id ;
        o.Shipment_Date__c=system.today()+10;
        o.Estimated_Delivery_Date__c=system.today()+11;        
        insert o;        
        OrderItem i = new OrderItem();
        i.OrderId = o.id;
        i.Product2id = painbalm.id;
        i.PricebookEntryId=DtandardPrice.Id;
        i.Quantity = 25;
        i.UnitPrice = 100;    
        insert i;
        System.debug('inserted order id is'+i);
        
        o.Status = 'Confirmed';update o;
        if(o.Status == 'Confirmed') {
            Inventory__c invFields=[SELECT Receivable_Qty__c FROM Inventory__c WHERE id=:newInv.id];
            System.assertEquals(225,invFields.Receivable_Qty__c);
        }
    }
}