/*
* Author:- Somesh Mamidwar
* Created:- 09-09-2020
* Last Updated:- 
* Feature:- TestDataFactory
* Description:- This class is created to create all test data.
*/

@isTest 
public without sharing class TestDataFactory {

    // This method is to create Dealer Account
    public static Account createDealerAccount()
    {
        Id accDealerRectId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Dealer Account';
        acc.recordTypeId = accDealerRectId;
        acc.Credit_Limit__c=200000;
        insert acc;
        return acc;
    }

    // This method is to create Retailer Account
    public static Account createRetailerAccount(Id accId)
    {
        Id accRetailererRectId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Retailer Account';
        acc.recordTypeId = accRetailererRectId;
        acc.ParentId=accId;
        insert acc;
        return acc;
    }
    //This method is to create Contact
    public static Contact createContact(Id accId)
    {
           Contact con = new Contact();
           con.FirstName='Test';
           con.LastName='Contact';
           con.AccountId=accId;
           insert con;
        return con;
    }
        
    // This method is to create Product
    public static Product2 createProduct(String prodName)
    {
        Product2 prod = new Product2();
        prod.Name = prodName;
        prod.Family = 'Beverages';
        prod.IsActive=true;
        insert prod;
        return prod;
    }

    // This method is to create PricebookEntry
    public static PricebookEntry createPricebookEntry(Decimal price, Id prodctId)
    {   
        Id standardPb = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry();  
        standardPrice.Pricebook2Id =standardPb;
        standardPrice.Product2Id = prodctId;
        standardPrice.UnitPrice = price;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice;
        return standardPrice;
    }

    // This method is to create Order which should have account Id and Record type Id as input parameters
    public static Order createOrder(Id accntId, Id recTypeId)
    {
        Id standardPb = Test.getStandardPricebookId();

        Order ord = new Order();
        ord.AccountId = accntId;
        ord.recordTypeId = recTypeId;
        ord.Status='Draft';
        ord.EffectiveDate=system.today();
        ord.Pricebook2Id = standardPb;
        insert ord;
        return ord;
    }


}