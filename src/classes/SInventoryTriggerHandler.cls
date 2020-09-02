/*
* Author:- Somesh Mamidwar
* Created:- 28-08-2020
* Last Updated:- 
* Feature:- InventoryTriggerHandler Class
* Description:- 
*/
public without sharing class SInventoryTriggerHandler {
    public static void sAccountTrgInsertHelper(List <Inventory__c> inventoryData) {

        List < Id > invtIds = new List < Id > ();
        for (Inventory__c inv: inventoryData) {
            invtIds.add(inv.Id);
        }


    }


}
