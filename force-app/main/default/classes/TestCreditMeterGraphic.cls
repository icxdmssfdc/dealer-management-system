/*
* Author:- Somesh Mamidwar
* Created:- 17-09-2020
* Last Updated:- 
* Description:- Test class for VF page Controller CreditMeterGraphic
*/
@isTest
public class TestCreditMeterGraphic {

    TestCreditMeterGraphic(){}
    
    @isTest Public static void creditMeterGraphicMethod(){
     	
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();

		ApexPages.StandardController sc = new ApexPages.StandardController(dealerAccnt); 
        ApexPages.currentPage().getParameters().put('id', String.valueOf(dealerAccnt.Id));
			CreditMeterGraphic testCM = new CreditMeterGraphic(sc);
			testCM.getData();
   
    }
    
}