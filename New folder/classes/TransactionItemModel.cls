/************************************************************************
Class Name: TransactionItemModel
History of changes: 
-------------------------------------------------------------------------
   Date                Developer                         Comments   
-------------------------------------------------------------------------
   30/4/2021         Narender Goud V                      Created   
**************************************************************************/
public with sharing class TransactionItemModel {
    public keys transactionItemKey;
    public values transactionItemValue;
    
    public class keys{
        public String TransactionItemID;
    }
    
    
    public class values{
        public Decimal ItemCost;
        public String ItemName;
    }
    
}