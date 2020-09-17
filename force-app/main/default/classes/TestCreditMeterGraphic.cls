@isTest
public class TestCreditMeterGraphic {

    @isTest Public static void creditMeterGraphicMethod(){
     	
        //Getting Dealer Account
        Account dealerAccnt = TestDataFactory.createDealerAccount();
        
       Test.StartTest(); 

			ApexPages.currentPage().getParameters().put('id', String.valueOf(dealerAccnt.Id));
			//CreditMeterGraphic  testCreditMeterGraphic = new CreditMeterGraphic();
			//testCreditMeterGraphic.getData();
			

		Test.StopTest();
    
    
    }
    
}