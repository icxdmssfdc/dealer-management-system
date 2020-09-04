/*
* Author:- Somesh Mamidwar
* Created:- 28-08-2020
* Last Updated:- 
* Description:-  InventoryTriggerHandler Class
*/
public without sharing class SInventoryTriggerHandler {

    public void sInventoryTrgInsertHelper(Inventory__c inventoryData) {

         List<PricebookEntry> pbe = new List<PricebookEntry>();
         if (Schema.sObjectType.PricebookEntry.fields.UnitPrice.isAccessible()){
            pbe  = [Select PriceBook2.Name, Product2.Id, Product2.Name, UnitPrice, Name From PricebookEntry 
              WHERE  PriceBook2.Id = :inventoryData.Retailer_Price_Book__c  AND Product2.Id = :inventoryData.Product__c limit 1 ];
         }

            if(!pbe.isEmpty()) {
             inventoryData.Retailer_Price__c = pbe[0].UnitPrice;
            }
         

     }
 
     public void sInventoryTrgUpdateHelper(Inventory__c invNew ,Inventory__c oldinv) {
        
        List<PricebookEntry> pbe = new List<PricebookEntry>();

             if (Schema.sObjectType.PricebookEntry.fields.UnitPrice.isAccessible()){
               pbe  = [Select PriceBook2.Name, Product2.Id, Product2.Name, UnitPrice, Name From PricebookEntry 
                  WHERE  PriceBook2.Id = :invNew.Retailer_Price_Book__c  AND Product2.Id = :invNew.Product__c limit 1 ];
             }

             if(!pbe.isEmpty()) {           
                 invNew.Retailer_Price__c = pbe[0].UnitPrice;  
             }                    
 
         }
 }