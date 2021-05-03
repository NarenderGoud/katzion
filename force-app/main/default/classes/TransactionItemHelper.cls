/************************************************************************
Class Name: TransactionHelper
History of changes: 
-------------------------------------------------------------------------
   Date                Developer                         Comments   
-------------------------------------------------------------------------
   30/4/2021        Narender Goud V                      Created   
**************************************************************************/
public with sharing class TransactionItemHelper {
    
	private static TransactionItemHelper instance = null;
    
    /**
   * @description       Constructor to initialize all the helper classes and context variable
   * @return            NA
   * @throws            Exception
   */
    public static TransactionItemHelper getInstance(){
        if (instance == null){
             instance = new TransactionItemHelper();
        }    
        return instance;
    }
    
    /**
   * @description       Update the TotalCount of TransactionItem records in Transaction
   * @return            NA
   * @throws            Exception
   */
    
    public void updateTransactionCount(List<TransactionItem__c> newTransactionItemList, Map<Id, TransactionItem__c> oldTransactionItemMap){
        Set<Id> transactionIdSet = new Set<Id>();
        List<TransactionItem__c> transactionItemList = new List<TransactionItem__c>();
        List<Transaction__c> transactionList = new List<Transaction__c>();
        List<Transaction__c> transactionListToUpdate = new List<Transaction__c>();
        Map<Id, List<TransactionItem__c>> transactionItemMap = new Map<Id, List<TransactionItem__c>>();
        
        // collectng the transaction Id into a Set.
        for(TransactionItem__c eachItem: newTransactionItemList){
            if(eachItem.Item_Cost__c!=null){
                 if(oldTransactionItemMap!=null){
                    if(eachItem.Item_Cost__c != oldTransactionItemMap.get(eachItem.Id).Item_Cost__c){
                       transactionIdSet.add(eachItem.Transaction__c);
                    }
                 }else{
                      transactionIdSet.add(eachItem.Transaction__c);
                 }
            }
        }
        
        // Get the TransactionItem__c by using a SOQL query
        // Get the Transaction__c by using a SOQL query
        if(!transactionIdSet.isEmpty()){
            transactionItemList = [SELECT Id, Transaction__c, Item_Cost__c FROM TransactionItem__c Where Transaction__c IN: transactionIdSet];
            transactionList = [Select Id, Total_Cost__c, Transaction_Count__c From Transaction__c Where Id IN: transactionIdSet];
        }
        
        // collectng the TransactionItemRecords for each Transaction record into a Map.
        if(!transactionItemList.isEmpty()){
            for(TransactionItem__c eachItem: transactionItemList){
                if(!transactionItemMap.containsKey(eachItem.Transaction__c)){
                    transactionItemMap.put(eachItem.Transaction__c, new List<TransactionItem__c>());
                }
                transactionItemMap.get(eachItem.Transaction__c).add(eachItem);
            }
        }
        
        // Assign TotdalCost and count the number of records.
        
        if(!transactionList.isEmpty()){
            for(Transaction__c eachTransaction: transactionList){
                Integer count = 0;
                if(!transactionItemMap.isEmpty() && transactionItemMap.containsKey(eachTransaction.Id)){
                    for(TransactionItem__c eachItem: transactionItemMap.get(eachTransaction.Id)){
                        eachTransaction.Total_Cost__c = eachTransaction.Total_Cost__c!=null ? eachTransaction.Total_Cost__c + eachItem.Item_Cost__c : eachItem.Item_Cost__c;
                        count++;
                    }
                }
                eachTransaction.Transaction_Count__c = count!=0 ? count : 0;
                transactionListToUpdate.add(eachTransaction);
            }
        }
        
        System.debug('transactionListToUpdate============='+transactionListToUpdate);
        
        //DML operation
        if(!transactionListToUpdate.isEmpty()){
            update transactionListToUpdate;
        }
    }
}