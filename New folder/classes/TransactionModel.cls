/************************************************************************
Class Name: TransactionModel
History of changes: 
-------------------------------------------------------------------------
   Date                Developer                         Comments   
-------------------------------------------------------------------------
   30/4/2021         Narender Goud V                      Created   
**************************************************************************/
public  with sharing class TransactionModel {
    public keys transactionKey;
    public values transactionValue;
    
    public class keys{
        public String TransactionID;
    }
    
    
    public class values{
        public Decimal TotalCost;
        public Decimal TotalDiscount;
        public DateTime TransactionDate;
        public Decimal TotalCount;
    }
}