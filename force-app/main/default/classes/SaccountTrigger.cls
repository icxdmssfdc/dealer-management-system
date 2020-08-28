/*
 * Author:- Somesh Mamidwar
 * Created:- 26-08-2020
 * Last Updated:- 
 * Description:- Account Trigger Helper Class
 */

public without sharing class SaccountTrigger {
    public static void sAccountTrgInsertHelper(List < Account > accountData) {
        //Recomondation to not write SOQL Solution
        List < Id > parAccntIds = new List < Id > ();
        for (Account acc: accountData) {
            parAccntIds.add(acc.ParentId);
        }
        //Validating CRUD permission before SOQL/DML operation Solution
        if (
            Account.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.Account.fields.Name.isAccessible()
        ) {
            // Defining a List object of Parent Accounts to store 
            List < Account > parentAccList = [Select Id, Partner_Dealer__c from Account where Id in: parAccntIds];
        }

          // Defining a Map object to store a key,value pair of child and Parent Accounts
            Map<Id, Account> mapParentAccount = new Map<Id, Account>();
            For (Account acc : parentAccList) {
               // store Accnt Id and Account objects for all the matched accounts
             mapParentAccount.put(parAccntIds.Id,parentAccList);
         }

         // Loop thru trigger collection, match account from the map

        for (Account acc: accountData) {
                //Comparing record type Id's using dynamic apex
                Id retAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Retailer').getRecordTypeId();
                if (acc.RecordTypeId == retAccRecordTypeId && acc.ParentId != null) {
                    //Get matching parentAccount from the Map
                    Account parAccnt = mapParentAccount.Get(acc.ParentId);
                    acc.Partner_Dealer__c = parAccnt.Partner_Dealer__c;
                
            }
        }

    }

    public static void sAccountTrgUpdateHelper(List < Account > accountData){

        List < Id > accntIds = new List < Id > ();
        for (Account acc: accountData) {
            accntIds.add(acc.ParentId);
        }

    }


}