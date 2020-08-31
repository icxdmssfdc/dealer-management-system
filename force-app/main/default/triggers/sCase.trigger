/*
* Author:- Vaishnavi Gajawada
* Created:- 26-08-2020
* Last Updated:- 
* Feature:- 
* Description:- Case Trigger for case object
*/
trigger sCase on Case(before insert){
if(Trigger.isInsert){
SCaseHelper caseObj=new SCaseHelper();
List<Case> v1 = Trigger.new;
caseObj.sCaseTgrHelperClass(v1);                 
    }
 
}

