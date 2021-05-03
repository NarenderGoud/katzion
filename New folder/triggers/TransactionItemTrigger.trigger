/************************************************************************
Trigger Name: TransactionItemTrigger
History of changes: 
-------------------------------------------------------------------------
   Date                Developer                         Comments   
-------------------------------------------------------------------------
   30/4/2021        Narender Goud V                      Created   
**************************************************************************/

trigger TransactionItemTrigger on TransactionItem__c (after insert, after update) {
    
    TransactionItemHelper helper = TransactionItemHelper.getInstance();
    
    /**After Insert Event*/
    if(Trigger.isInsert && Trigger.isAfter){
        helper.updateTransactionCount(Trigger.new, null);
    }
    
    /**After Update Event*/     
    else if(Trigger.isUpdate && Trigger.isAfter){
        helper.updateTransactionCount(Trigger.new, Trigger.oldMap);
    }
}