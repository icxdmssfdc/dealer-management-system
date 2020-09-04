/*
* Author:- Vamsi Alla
* Created:- 31-08-2020
* Last Updated:-  
* Description:- Craete for Schemes applicable on Order
*/
public without sharing class ApplyOrderOffers {
    
    List<Scheme__c> offers = new List<Scheme__c>();
    List<Promotional_Offer__c> issuedCoupons = new List<Promotional_Offer__c>();
    Map<Id,Promotional_Offer__c> issuedCouponsMap = new Map<Id,Promotional_Offer__c>();

    String offerFields = '';
    public ApplyOrderOffers() {
        offerFields = GetAllFields.getAllObjectField('Scheme__c');
        String query = 'select ' + offerFields + ' from Scheme__c where active__c = True AND Start_Date__c <= Today and (End_Date__c = null OR End_Date__c >= Today) and Header_Discount__c = True';
        offers = Database.query(query);
    }

    public void applyOffers(Order order){
        String appliedOffer = '';
        String appliedOfferId = '';
        Decimal discountAmount = 0;
        Decimal discount = 0;
        Boolean qualify = false;
        Boolean couponApplied = false;
        String couponId = '';

      //  for(Order order : orders.values()){
           if(order.Order_Type__c == 'Retailer' && order.TotalAmount > 0){
                discountAmount = 0;
                qualify = false;
                for(Scheme__c offer : offers){
                    discount = 0;
                    
                    if(offer.Scheme_Type__c == 'Specific'){
                        if(offer.State__c != null){
                            String[] states = offer.State__c.split(';');
                            for(String state : states){
                                if (state == order.shippingstate){
                                    qualify = true;
                                }
                            }
                        }
                        if(offer.Order_Amount__c != null){
                            if(order.TotalAmount >= offer.Order_Amount__c){
                                qualify = true;
                            }else{
                                qualify = false;
                            }
                        }
                    }else{
                        qualify = true;
                    }

                    if(offer.Discount_Type__c == 'Amount' && qualify && !couponApplied){
                        discount = offer.Discount_Amount__c;
                        if(discount > discountAmount){
                            discountAmount = discount;
                            appliedOffer = offer.Name;
                            appliedOfferId = offer.Id;
                        }
                    }else if(offer.Discount_Type__c == 'Percentage' && qualify && !couponApplied){
                        discount = order.TotalAmount * (offer.Discount_Percentage__c/100);
                        if(discount > discountAmount){
                            discountAmount = discount;
                            appliedOffer = offer.Name;
                            appliedOfferId = offer.Id;
                        }
                    }else if(offer.Discount_Type__c == 'Coupon' && qualify && !couponApplied){
                        couponId = offer.Coupon__c;
                        appliedOffer = offer.Name;
                        appliedOfferId = offer.Id;
                        couponApplied = true;
                    }else {
                        //do nothing
                    }
                
                    if(couponId != ''){
                        if(order.Coupon_Id__c == null && order.Promotional_Scheme__c == null){
                            order.Coupon_Id__c = couponId;
                            Id accountId = order.accountId;
                            Promotional_Offer__c isscoupon = new Promotional_Offer__c();
                            isscoupon.Account__c = accountId;
                            isscoupon.Coupon__c = couponId;
                         
                            insert isscoupon;
                            
                            order.Promotional_Scheme__c = isscoupon.Id;
                        }
                        discountAmount = 0;
                    }else if(order.Promotional_Scheme__c != null){
                        order.Coupon_Id__c = null;
                        List<Promotional_Offer__c> coupReff = new List<Promotional_Offer__c>();
                        Id coupReffId = order.Promotional_Scheme__c;
                        if(Promotional_Offer__c.SObjectType.getDescribe().isAccessible() ){
                         coupReff = [Select Id from Promotional_Offer__c where Id =:coupReffId];
                        }
                        delete coupReff;
                        order.Promotional_Scheme__c = null;
                    }else{
                        // do nothing
                    }
                    if(appliedOfferId != ''){
                        order.Applied_Scheme__c = appliedOfferId;
                    }else{
                        order.Applied_Scheme__c = null;
                    }
                    order.Discount_Amount__c = discountAmount;
                    order.Applied_Offer__c = appliedOffer;
                    if(appliedOffer != ''){
                        order.Header_Discount__c = true;
                    }else{
                        order.Header_Discount__c = false;
                    }
                }
            }
       // }
    }
}