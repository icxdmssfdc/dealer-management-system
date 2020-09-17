@isTest
public class TestSInventoryDetails {

    @isTest Public static void getAccInvDetails(){
        
         //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
        //Creating Product
        Product2 prod = TestDataFactory.createProduct('Test Fruit Juice');
        prod.Max_Qty__c=500;
        prod.Min_Qty__c=200;
        update prod;
        
        //standard pricebook
        Id standardPBook =Test.getStandardPricebookId();
        
         Pricebook2 newPriceBook = new Pricebook2();
       	 newPriceBook.Name = 'Standard Price Book';
         newPriceBook.IsActive =true ;
         insert newPriceBook;
        
        //Creating PricebookEntry
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(100,prod.Id);
        
      	/*PricebookEntry standardPrice = new PricebookEntry();  
        standardPrice.Pricebook2Id =newPriceBook.Id;
        standardPrice.Product2Id = prod.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice;*/
   
        //Inventory creation
        Inventory__c newInv=new Inventory__c();
        //insert newInv;        
        newInv.Distributor__c=dealerAccnt.id;
        newInv.OnHand_Qty__c=150;
        newInv.Product__c=prod.id;
        newInv.Price_Book__c=standardPBook;
        newInv.Dealer_Product_Price__c=standardPrice.UnitPrice;
        
        newInv.Retailer_Price_Book__c=standardPBook;
        newInv.Retailer_Price__c=standardPrice.UnitPrice;
        insert newInv;
        
		List <Inventory__c> getAccInvInv = sInventoryDetails.getAccInventoryDetails(dealerAccnt.id);
        
        List <Inventory__c> getQueryRetInv = sInventoryDetails.getQueryInvDetails(dealerAccnt.id,'Test Fruit Juice');
        
        
        
        sInventoryDetails.generateInvOrder(dealerAccnt.id,getQueryRetInv);
        
    }
    
}