@isTest
public with sharing class TestICXTwilioSMSService {
       //public class Test_ICXTwilioSMSService {
        
        @isTest static void testPostCallout() {
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new IntegrationHttpCalloutMock()); 
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock. 
            // 
            test.startTest();
            ICXTwilioSMSService.send('+919014630847','Mock Test Callout');
            test.stopTest();
            
            /* HttpResponse response = ICXTwilioSMSService.send('919014630847','Mock Test Callout');
            // Verify that the response received contains fake values
            String contentType = response.getHeader('Content-Type');
            System.assert(contentType == 'application/json');
            String actualValue = response.getBody();
            System.debug(response.getBody());
            String expectedValue = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';
            System.assertEquals(actualValue, expectedValue);
            System.assertEquals(200, response.getStatusCode());*/
        }   
    
        
    }

