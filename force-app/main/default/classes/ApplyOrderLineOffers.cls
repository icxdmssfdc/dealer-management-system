/*
* Author:- Vamsi Alla
* Created:- 31-08-2020
* Last Updated:- 
* Description:- Created for Quantity Schemes
*/
public without sharing class ApplyOrderLineOffers {
    
    List<Scheme__c> offers = new List<Scheme__c>();
    String offerFields = '';
    
    public ApplyOrderLineOffers() {
        offerFields = GetAllFields.getAllObjectField('Scheme__c');
        String query = 'select ' + offerFields + ' from Scheme__c where active__c = True AND Start_Date__c <= Today AND (End_Date__c = null OR End_Date__c >= Today) and Header_Discount__c = False';
        offers = Database.query(query);
    }
    
    public void applyOffers(OrderItem orderitem){
        String appliedOffer = '';
        String appliedOfferId = '';
        Decimal discountAmount = 0;
        Decimal discount = 0;
        Boolean qualify = false;
        Boolean qtyApplied = false;
        Decimal unitPrice = 0;
        Decimal freeQty = 0;
        Boolean qtyDiscApplied = false;
        
            if(orderitem != null && orderitem.Order_Record_Type__c == 'Retailer'){
                discountAmount = 0;
                for(Scheme__c offer : offers){
                    discount = 0;
                    if(offer.Scheme_Type__c == 'Specific'){
                        if(offer.State__c != null){
                            String[] states = offer.State__c.split(';');
                            for(String state : states){
                                if (state == orderitem.Shipping__c){
                                    qualify = true;
                                }
                            }
                        }
                        if(offer.Order_Amount__c != null){
                            if(orderitem.TotalPrice >= offer.Order_Amount__c){
                                qualify = true;
                            }else{
                                qualify = false;
                            }
                        }
                        if(offer.Product__c != null){
                            if(orderitem.Product2Id == offer.Product__c){
                                qualify = true;
                            }else{
                                qualify = false;
                            }
                        }
                    }else{
                        qualify = true;
                    }
  					 if(offer.Discount_Type__c == 'Quantity' && qualify){
                        if(offer.Buy__c <= orderitem.Quantity){
                            discount = offer.Get__c * orderitem.UnitPrice;
                            
                            if(discount > discountAmount){   
                                Decimal totalunits = orderitem.Quantity + offer.Get__c;
                                if(orderitem.ListPrice != null){
                                    unitPrice = (orderitem.ListPrice * orderitem.Quantity) / totalunits;
                                }else{
                                    unitPrice = (orderitem.UnitPrice * orderitem.Quantity) / totalunits;
                                }
                                orderitem.Quantity = totalunits;
                                discountAmount = discount;
                                appliedOffer = offer.Name;
                                appliedOfferId = offer.Id;
                                qtyDiscApplied = true;
                                freeQty = offer.Get__c;
                            }
                        }
                    }else if(offer.Discount_Type__c == 'Cross Product Offer' && qualify){
                        if(offer.Buy__c <= orderitem.Quantity){
                            if(orderitem.Cross_Discount_Product_Id__c == null){

                                List<Order> order = new List<Order>();
                                Decimal qty = offer.Get__c;
                                String product2Id = offer.Get_Product__c;
                             
                                order = [Select Id,Pricebook2Id from Order where Id =: orderitem.OrderId]; 
                                
                                String priceBookId = order[0].Pricebook2Id;
                                String orderId = order[0].Id;
                               
                                PricebookEntry[] pbe = [Select Id,UnitPrice from PricebookEntry where Pricebook2Id =:priceBookId AND Product2Id =:product2Id];
                                
                                if(pbe.size() > 0){
                                    String priceBookEntryId = pbe[0].Id;
                                    List <OrderItem> ordItm = new List<OrderItem>();
                                    if(Schema.SObjectType.OrderItem.fields.Id.isAccessible()){
                                     ordItm = [Select Id from OrderItem where orderId =:orderId AND PricebookEntryId =:priceBookEntryId];
                                    }
                                    if(ordItm.size() > 0){  
                                        ordItm[0].Quantity = qty;
                                        update ordItm[0];
                                    }else{
                                        OrderItem ordItem = new OrderItem();
                                        ordItem.OrderId = orderitem.OrderId;
                                        ordItem.PricebookEntryId = pbe[0].Id;
                                        ordItem.Product2Id = product2Id;
                                        ordItem.UnitPrice = 0.00;
                                        ordItem.Quantity = qty;

                                        insert ordItem;
                                        
                                        orderitem.Cross_Discount_Product_Id__c = ordItem.Id;
                                    }
                                    appliedOffer = offer.Name;
                                    appliedOfferId = offer.Id;
                                }
                            }
                        }else{
                            if(orderitem.Cross_Discount_Product_Id__c != null){
                                String sPromoProductId = orderitem.Cross_Discount_Product_Id__c;
                                List<OrderItem> ordItemdel = new List<OrderItem>();
                                if(Schema.SObjectType.OrderItem.fields.Id.isAccessible() ){
                                 ordItemdel = [Select id from OrderItem where Id =: sPromoProductId];
                                }
                            
                                delete ordItemdel;
                                
                                orderitem.Cross_Discount_Product_Id__c = null;
                                appliedOffer = null;
                                appliedOfferId = null;
                            }
                        }
                    }else {
                        //do nothing
                    }
                }
                if(qtyDiscApplied == true){
                    orderitem.Offered_Quantity__c = freeQty;
                }else{
                    orderitem.Offered_Quantity__c = 0;
                }
                if(unitPrice > 0){
                    orderitem.UnitPrice = unitPrice;
                }
                if(appliedOfferId != ''){
                    orderitem.Applied_Scheme__c = appliedOfferId;
                }else{
                    orderitem.Applied_Scheme__c = null;
                }
                orderitem.Discount_Amount__c = discountAmount;
                orderitem.Applied_Offer__c = appliedOffer;
            }
        
    }
}