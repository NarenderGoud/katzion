/************************************************************************
Trigger Name: TransactionTrigger
History of changes: 
-------------------------------------------------------------------------
   Date                Developer                         Comments   
-------------------------------------------------------------------------
   30/4/2021        Narender Goud V                      Created   
**************************************************************************/

trigger TransactionTrigger on Transaction__c (after update) {
    TransactionHelper helper = TransactionHelper.getInstance();
        
    /**After Update Event*/     
    if(Trigger.isUpdate && Trigger.isAfter){
       helper.sendDataToThirdParty(Trigger.new, Trigger.oldMap);
    }
}