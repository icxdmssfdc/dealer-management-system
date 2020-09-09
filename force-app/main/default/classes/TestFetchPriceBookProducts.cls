@isTest(seeAllData=true) 
public with sharing class TestFetchPriceBookProducts {
//public class Test_FetchPriceBookProducts {
    @isTest public static void fetchproducts(){
        List<Product2> productslist=new List<Product2>();
        Product2 indproduct;
        //Test Products
        indproduct=new Product2(Name='p1',Family='Beverages',IsActive=true,productCode='BEVA');
        indproduct=new Product2(Name='p2',Family='Beverages',IsActive=true,productCode='BEVB');
        indproduct=new Product2(Name='p3',Family='Beverages',IsActive=true,productCode='BEVC');
        indproduct=new Product2(Name='p4',Family='Beverages',IsActive=true,productCode='BEVD');
        indproduct=new Product2(Name='p5',Family='Beverages',IsActive=true,productCode='BEVE');
        productslist.add(indproduct);
        insert productslist;
        //fetching standard pricebook from org
        Id standardPBId = Test.getStandardPricebookId();
        System.debug('id is'+standardPBId);
        Pricebook2 lov =[SELECT id,name,isActive,IsStandard FROM pricebook2 WHERE id=:standardPBId];
        //ID lov1=lov.id;
        System.debug('values are'+lov);
        List<PricebookEntry> standardPricelist = new List<PricebookEntry>();//Pricebook2Id = lov.id, Product2Id = painbalm.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);//'01s2v00000L2BllAAF'
        PricebookEntry pee;
        pee=new PricebookEntry(Pricebook2Id = lov.id, Product2Id = indproduct.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        standardPricelist.add(pee);
        insert standardPricelist;
		test.startTest();
        FetchPriceBookProducts.getProduts(standardPBId);
        test.stopTest();
        PricebookEntry pe=[SELECT UnitPrice FROM PricebookEntry WHERE Id=:pee.id];
        system.assertEquals(100, pe.UnitPrice, 'unit price');
    }
    @isTest public static void cartprod(){
        //Distributor Account
		Id AccRTDist = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        //RecordType AccRTDist = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Dealer'];
        Account DistAcc=new Account(Name='Gaja',recordTypeId=AccRTDist,Credit_Limit__c=20000);
        insert DistAcc;        
        Product2 painbalm=new Product2(Name='Pain Balm',Family='Pain Management',Product_Classification__c='A',IsActive=true);
        painbalm.Max_Qty__c=300;
        painbalm.Min_Qty__c=180;
        insert painbalm;

        //fetching standard pricebook from org
        Id standardPBId = Test.getStandardPricebookId();
        System.debug('id is'+standardPBId);
        Pricebook2 lov =[SELECT id,name,isActive,IsStandard FROM pricebook2 WHERE id=:standardPBId];
        //ID lov1=lov.id;
        System.debug('values are'+lov);
       // List<PricebookEntry> standardPricelist = new List<PricebookEntry>();//Pricebook2Id = lov.id, Product2Id = painbalm.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);//'01s2v00000L2BllAAF'
        //PricebookEntry pee;
        PricebookEntry pee=new PricebookEntry(Pricebook2Id = lov.id, Product2Id = painbalm.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        //standardPricelist.add(pee);
        insert pee;
		
        Cart__c cartobj=new Cart__c();
        cartobj.Account__c=DistAcc.id;
        cartobj.List_Price__c=100;
        cartobj.PriceBookEntryID__c=pee.id;
        cartobj.Product__c=painbalm.id;
        cartobj.Quantity__c=2;
        cartobj.Unit_Price__c=100;
		insert cartobj;
        ID DistAcc1=DistAcc.id;
		test.startTest();
		FetchPriceBookProducts.clearCart(DistAcc1) ;
        //test.stopTest();
        system.debug('next thing');
        //test.startTest();
        FetchPriceBookProducts.insertLineItem(DistAcc1, painbalm.id, pee.id, 100,100,5);
        test.stopTest();
        
    }
     @isTest public static void insertlineitems(){
        //Distributor Account
		Id AccRTDist = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();

        //RecordType AccRTDist = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Distributor'];
        Account DistAcc=new Account(Name='Gaja',recordTypeId=AccRTDist,Credit_Limit__c=20000);
        insert DistAcc;        
        Product2 painbalm=new Product2(Name='Pain Balm',Family='Pain Management',Product_Classification__c='A',IsActive=true);
        painbalm.Max_Qty__c=300;
        painbalm.Min_Qty__c=180;
        insert painbalm;

        //fetching standard pricebook from org
        Id standardPBId = Test.getStandardPricebookId();
        System.debug('id is'+standardPBId);
        Pricebook2 lov =[SELECT id,name,isActive,IsStandard FROM pricebook2 WHERE id=:standardPBId];
        //ID lov1=lov.id;
        System.debug('values are'+lov);
       // List<PricebookEntry> standardPricelist = new List<PricebookEntry>();//Pricebook2Id = lov.id, Product2Id = painbalm.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);//'01s2v00000L2BllAAF'
        //PricebookEntry pee;
        PricebookEntry pee=new PricebookEntry(Pricebook2Id = lov.id, Product2Id = painbalm.id, UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        //standardPricelist.add(pee);
        insert pee;
		
        Cart__c cartobj=new Cart__c();
        cartobj.Account__c=DistAcc.id;
        cartobj.List_Price__c=100;
        cartobj.PriceBookEntryID__c=pee.id;
        cartobj.Product__c=painbalm.id;
        cartobj.Quantity__c=2;
        cartobj.Unit_Price__c=100;
		insert cartobj;
        ID DistAcc1=DistAcc.id;
		//test.startTest();
		//FetchPriceBookProducts.clearCart(DistAcc1) ;
        //test.stopTest();
        system.debug('next thing');
        test.startTest();
        FetchPriceBookProducts.insertLineItem(DistAcc1, painbalm.id, pee.id, 100,100,5);
        FetchPriceBookProducts obj=new FetchPriceBookProducts();
        test.stopTest();
        
    }


}