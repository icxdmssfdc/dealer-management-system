/*
* Author:- Somesh Mamidwar
* Created:- 17-09-2020
* Last Updated:- 
* Description:- Test class for FetchPriceBookProducts
*/
@isTest(seeAllData=true) 
public class TestFetchPriceBookProducts {

    @isTest public static void fetchPriceBookProds(){

        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        prod.Max_Qty__c=500;
        prod.Min_Qty__c=200;
        update prod;
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
        // Cart Creation
        Cart__c cart = new Cart__c();
        cart.Account__c = retailerAccnt.Id;
        cart.Product__c = prod.Id;
        cart.PriceBookEntryID__c = standardPrice.Id;
        cart.List_Price__c = 100;
        cart.Unit_Price__c = 100;
        cart.Quantity__c = 100;
        insert cart;
        
        //Calling FetchPriceBookProducts class methods
        FetchPriceBookProducts.getProduts();
        
        FetchPriceBookProducts.clearCart(retailerAccnt.Id);
        
        FetchPriceBookProducts.insertLineItem(retailerAccnt.Id,prod.Id,standardPrice.Id,100,100,10);       
        
    }

}