@isTest 
public with sharing class TestSaccountTrigger {
    Public Static testMethod void checkAccount(){
        
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Getting Retailer Account
        Account retailerAccnt = TestDataFactory.createRetailerAccount(dealerAccnt.Id);
        
        //Getting Contact
        Contact dealerCont= TestDataFactory.createContact(dealerAccnt.id);
        
        system.debug('account values are'+dealerAccnt);
        
        Contact contactVal=[SELECT Name FROM Contact WHERE id=:dealerCont.id];
        
        system.assertEquals('Test Contact',contactVal.Name,'contact value output');
        
    }
}