//@isTest(seeAllData = true)
@isTest public with sharing class TestsCase {  
    @isTest Public Static void createCase(){
        //Distributor Account Insertion
        RecordType accDistRecId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Dealer'];
        Account distAcc=new Account(Name='DistrbAccnttest1',recordTypeId=accDistRecId.id,Credit_Limit__c=20000);
        insert distAcc;
        //Retailer Account Insertion
        RecordType accRTRetailer = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Retailer'];
        Account retAcc=new Account(Name='RetailerAccnt',ParentId=distAcc.Id,recordTypeId=accRTRetailer.id);
        insert retAcc;
        //get Standard Price Book id
        RecordType orderRTRetlr = [SELECT Id FROM RecordType WHERE sObjectType = 'Order' AND Name = 'Retailer'];
        Scheme__c orderRTRSchId = [SELECT Id FROM Scheme__c WHERE  Name = 'Buy 1000 above,Get 10% Off'];
        RecordType offerPerRecId = [SELECT Id FROM RecordType WHERE sObjectType = 'icxdms__Offers__c' AND Name ='Buy 100 Fruitnik 250ml Get 10 Fruitnik 180ml Free'];
        system.debug(offerPerRecId.Id);
        // Order Creation
         Product2 p2=new Product2(Name='Fruitnik 200ml',Family='Beverages',IsActive=true,productCode='BEV');
        insert p2;
       //get Standard Price Book id
        Id standardPb = Test.getStandardPricebookId();// [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        //insert standardPb;
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = standardPb;
        standardPrice.Product2Id = p2.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        Order retailerOrder=new Order(AccountId=retAcc.Id,recordTypeId=orderRTRetlr.Id,Status='Draft',EffectiveDate=system.today()-5,Pricebook2Id =standardPb);
        insert retailerOrder;
       retailerOrder.Applied_Scheme__c=offerPerRecId.Id;
        update retailerOrder;
       OrderItem i=new OrderItem(Product2Id=p2.Id,Quantity=300,OrderId=retailerOrder.Id,PricebookEntryId=standardPrice.id);
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
        System.assertEquals(retailerOrder.AccountId,caseResult.AccountId,'');
        System.assertEquals(retailerOrder.Applied_Scheme__c,caseResult.Scheme__c,'');
    }
}

