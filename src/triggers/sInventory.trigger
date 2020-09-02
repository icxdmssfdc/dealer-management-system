/*
* Author:- Vaishnavi Gajawada
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- 
* Description:- Inventory Trigger for inventory object
*/
trigger sInventory on Inventory__c (before insert,before update) {
        for(Inventory__c newInv : trigger.new){
            if(newInv.Price_Book__c  != null){
                if(trigger.isInsert){
                    List<PricebookEntry> PBE  = [Select PriceBook2.Name, Product2.Id, Product2.Name, UnitPrice, Name From PricebookEntry WHERE  PriceBook2.Id =:newInv.Price_Book__c  AND Product2.Id =:newInv.Product__c limit 1];
                    if(!PBE.isEmpty()){
                        newInv.Dealer_Product_Price__c = PBE[0].UnitPrice;
                    }
                    
                    List<PricebookEntry> PBE1  = [Select PriceBook2.Name, Product2.Id, Product2.Name, UnitPrice, Name From PricebookEntry WHERE  PriceBook2.Id =:newInv.Retailer_Price_Book__c AND Product2.Id =:newInv.Product__c limit 1];
                    if(!PBE1.isEmpty()){
                        newInv.Retailer_Price__c = PBE1[0].UnitPrice;
                    }
                }
                else{
                    Inventory__c oldinv = Trigger.oldMap.get(newInv.Id);
                    if(oldinv.Price_Book__c != newInv.Price_Book__c ){
                        List<PricebookEntry> PBE  = [Select PriceBook2.Name, Product2.Id, Product2.Name, UnitPrice, Name From PricebookEntry WHERE  PriceBook2.Id =:newInv.Price_Book__c  AND Product2.Id =:newInv.Product__c limit 1];
                        if(!PBE.isEmpty()){
                            newInv.Dealer_Product_Price__c = PBE[0].UnitPrice;
                        }
                    }
                    if(oldinv.Retailer_Price_Book__c != newInv.Retailer_Price_Book__c ){
                        List<PricebookEntry> PBE1  = [Select PriceBook2.Name, Product2.Id, Product2.Name, UnitPrice, Name From PricebookEntry WHERE  PriceBook2.Id =:newInv.Retailer_Price_Book__c  AND Product2.Id =:newInv.Product__c limit 1];
                        if(!PBE1.isEmpty()){
                            newInv.Retailer_Price__c = PBE1[0].UnitPrice;
                        }
                    }
                }
            }
        }
    
    
}