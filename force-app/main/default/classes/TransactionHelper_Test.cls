/************************************************************************
Class Name: TransactionHelper_Test
History of changes: 
-------------------------------------------------------------------------
   Date                Developer                         Comments   
-------------------------------------------------------------------------
   03/4/2021         Narender Goud V                      Created   
**************************************************************************/
@isTest(seeAllData=false)
public class TransactionHelper_Test {
    @testSetup static void setup() {
        // Create common Transaction records
        List<Transaction__c> testTransactionList = new List<Transaction__c>();
        
        Transaction__c transactionOne = new Transaction__c();
        Transaction__c transactionTwo = new Transaction__c();
        
        transactionOne.Name = 'Transaction One';
        transactionTwo.Name = 'Transaction Two';
        
        testTransactionList.add(transactionOne);
        testTransactionList.add(transactionTwo);
        insert testTransactionList;        
    }
    
    @isTest static void testMethod1() {
        // Get the first test Transaction__c by using a SOQL query
        Transaction__c transactionOne = [SELECT Id FROM Transaction__c WHERE Name='Transaction One' LIMIT 1];
        List<TransactionItem__c> transactionItemList = new List<TransactionItem__c>();
        
        TransactionItem__c firstTransaction = new TransactionItem__c();
        firstTransaction = getTransactionItem(transactionOne.Id, 'TransactionItem one', 100000);
        transactionItemList.add(firstTransaction);
        
        TransactionItem__c secondTransaction = new TransactionItem__c();
        secondTransaction = getTransactionItem(transactionOne.Id, 'TransactionItem one', 100000);
        transactionItemList.add(secondTransaction);
        
        insert transactionItemList;
       
        transactionItemList[0].Item_Cost__c = 40000;
        update transactionItemList[0];
        
    }
    
    private static TransactionItem__c getTransactionItem(Id parentId, String transactionItemName, Decimal itemCost){
        TransactionItem__c returnTransactionItem = new TransactionItem__c();
        returnTransactionItem.Transaction__c = parentId;
        returnTransactionItem.Name = transactionItemName;
        returnTransactionItem.Item_Cost__c = itemCost;
        
        return returnTransactionItem;
    }
}