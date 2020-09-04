/*
* Author:- Somesh Mamidwar
* Created:- 01-09-2020
* Last Updated:- 
* Feature:- 
* Description:- Created for Order Trigger as Handler Class
*/
public without sharing class SOrderTriggerHandler {

    public void sOrderTrgBeforeInsertHelper(Order ord){

        String accFields = GetAllFields.getAllObjectField('Account');
            if(ord.AccountId != null){
                String query = 'select ' + accFields + ' from Account Where Id = \''+ ord.AccountId +'\' Limit 1';
                Account acc = Database.query(query);
                if(acc != null){
                    if(ord.Account__c == null && ord.Order_Type__c == 'Dealer'){                   
                            ord.Account__c = acc.Id;
                        }
                        else{
                            ord.Account__c = acc.ParentId;
                            query = 'select ' + accFields + ' from Account Where Id = \''+ acc.ParentId +'\' Limit 1';
                            Account parAccount = Database.query(query);
                            if(parAccount != null){
                                ord.Partner_Dealer__c = parAccount.Partner_Dealer__c;
                            }                      
                    }
                    if(ord.Order_Type__c == 'Dealer'){
                        ord.Partner_Dealer__c = acc.Partner_Dealer__c;
                    }
                    
                    ord.Sales_Representative__c = acc.OwnerId;
                    
                    if(ord.BillingAddress == null){
                        ord.BillingCity = acc.BillingCity;
                        ord.BillingCountry = acc.BillingCountry;
                        ord.BillingPostalCode = acc.BillingPostalCode;
                        ord.BillingState = acc.BillingState;
                        ord.BillingStreet = acc.BillingStreet;
                    }
                    if(ord.ShippingAddress == null){
                        ord.ShippingCity = acc.ShippingCity;
                        ord.ShippingCountry = acc.ShippingCountry;
                        ord.ShippingPostalCode = acc.ShippingPostalCode;
                        ord.BillingState = acc.ShippingState;
                        ord.ShippingStreet = acc.ShippingStreet;
                    }
                }
            }
        }


}
