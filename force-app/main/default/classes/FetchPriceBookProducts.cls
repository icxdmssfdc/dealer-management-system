public with sharing class FetchPriceBookProducts {
    
    @AuraEnabled
    public static list<PricebookEntry> getProduts(){
        Pricebook_Setting__mdt retPriceBookId = [SELECT PBRecordTypeId__c from Pricebook_Setting__mdt where MasterLabel = 'RetailerPBRT'];
        
        list<PricebookEntry> products = [select Product2Id, Product2.Name, Product2.Description, UnitPrice, ProductCode from PricebookEntry where Pricebook2Id = :retPriceBookId.PBRecordTypeId__c];
        return products;
    }

    @AuraEnabled
    public static void clearCart(String AccountId){
        list<Cart__c> cart = [Select Account__c, Product__c, List_Price__c, Unit_Price__c, Quantity__c from Cart__c where Account__c =: AccountId];
        delete cart;
    }

    @AuraEnabled
    public static List<Cart__c> insertLineItem(String AccountId, String Product2Id, String PriceBookEntryId,Integer ListPrice, Integer UnitPrice, Integer Quantity){
        Cart__c cart = new Cart__c();
        cart.Account__c = AccountId;
        cart.Product__c = Product2Id;
        cart.PriceBookEntryID__c = PriceBookEntryId;
        cart.List_Price__c = UnitPrice;
        cart.Unit_Price__c = UnitPrice;
        cart.Quantity__c = Quantity;
        insert cart;

        return [Select Account__c, Product__c, List_Price__c, Unit_Price__c, Quantity__c from Cart__c where Account__c =: AccountId];
    }
}