/************************************************************************
Class Name: TransactionHelper
History of changes: 
-------------------------------------------------------------------------
   Date                Developer                         Comments   
-------------------------------------------------------------------------
   30/4/2021         Narender Goud V                      Created   
**************************************************************************/
public with sharing class TransactionHelper {
    private static TransactionHelper instance = null;
    
    /**
   * @description       Constructor to initialize all the helper classes and context variable
   * @return            NA
   * @throws            Exception
   */
    public static TransactionHelper getInstance(){
        if (instance == null){
            instance = new TransactionHelper();
        }    
        return instance;
    }
    
     /**
   * @description       Collecting Transaction and TransactionItem Data to send it to Third party application
   * @return            NA
   * @throws            Exception
   */
    
    public void sendDataToThirdParty(List<Transaction__c> newTransactionList, Map<Id, Transaction__c> oldTransactionMap){
        Set<Id> transactionIDSet = new Set<Id>();
        List<TransactionItem__c> transactionItemList = new List<TransactionItem__c>();
        List<TransactionItemModel> transactionItemModelList = new List<TransactionItemModel>();
        List<TransactionModel> transactionModelList = new List<TransactionModel>();
        
        // collectng the transaction Id into a Set.
        for(Transaction__c eachTransaction : newTransactionList){
            if(oldTransactionMap!=null && eachTransaction.Transaction_Count__c!=null && 
               eachTransaction.Transaction_Count__c != oldTransactionMap.get(eachTransaction.Id).Transaction_Count__c){
               		transactionIDSet.add(eachTransaction.Id);
               }else if (eachTransaction.Transaction_Count__c!=null){
                   transactionIDSet.add(eachTransaction.Id);
               }
            
        }
        
        // Get the TransactionItem__c by using a SOQL query
        if(!transactionIDSet.isEmpty()){
            transactionItemList = [SELECT Id, Transaction__c,Name, Item_Cost__c FROM TransactionItem__c Where Transaction__c IN: transactionIdSet];
        }
        
        // collect the data into Transaction and TransactionItem Models
        
        if(!transactionItemList.isEmpty()){
            
            // collect the data into TransactionItem Model
            
            for(TransactionItem__c eachItem: transactionItemList){
                TransactionItemModel transItemModel = new TransactionItemModel();
                transItemModel.transactionItemKey = new TransactionItemModel.keys();
                transItemModel.transactionItemValue = new TransactionItemModel.values();
                TransactionItemModel.keys transItemModelKey = new TransactionItemModel.keys();
                TransactionItemModel.values transItemModelValues = new TransactionItemModel.values();
                
                transItemModelKey.TransactionItemID = eachItem.Id;
                transItemModelValues.ItemCost = eachItem.Item_Cost__c;
                transItemModelValues.ItemName = eachItem.Name;
                
                transItemModel.transactionItemKey = transItemModelKey;
                transItemModel.transactionItemValue = transItemModelValues;
                
                transactionItemModelList.add(transItemModel);
                
            }
            
            // collect the data into Transaction Model
            
            for(Transaction__c eachTransaction : newTransactionList){
                if(transactionItemList.size() == eachTransaction.Transaction_Count__c){
                    
                    TransactionModel transModel = new TransactionModel();
                    transModel.transactionKey = new TransactionModel.keys();
                    transModel.transactionValue = new TransactionModel.values();
                    TransactionModel.keys transModelKey = new TransactionModel.keys();
                    TransactionModel.values transModelValues = new TransactionModel.values();
                    
                    transModelKey.TransactionID = eachTransaction.Id;
                    transModelValues.TotalCost = eachTransaction.Total_Cost__c;
                    transModelValues.TotalDiscount = eachTransaction.Total_Discount__c;
                    transModelValues.TransactionDate = eachTransaction.LastModifiedDate;
                    transModelValues.TotalCount = eachTransaction.Transaction_Count__c;
                    
                    transModel.transactionKey = transModelKey;
                    transModel.transactionValue = transModelValues;
                    
                    transactionModelList.add(transModel);
                }
            }
        }

		String transactionItemReqBody = JSON.serialize(transactionItemModelList); // Serialize the transactionItemModel
		String transactionReqBody = JSON.serialize(transactionModelList);  // Serialize the transactionModel
        
        System.debug('transactionItemReqBody======='+transactionItemReqBody);
        System.debug('transactionReqBody======='+transactionReqBody);
        
        
        if(String.isNotBlank(transactionItemReqBody)){
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('Endpoint URL'); //Adding Encript url to rest call   
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json');
            req.setTimeout(60000);
            req.setBody(transactionItemReqBody);
            
            HttpResponse response = new HttpResponse();
            response = http.send(req);
            System.debug('response======'+response);
            
            
            //Below condition is not going to satisy in test class as we don't have actual integration in place. So we don't get any response.
            
            
            if(response.getStatusCode() == 201 && String.isNotBlank(transactionReqBody)){
                
                Http http1 = new Http();
                HttpRequest req1 = new HttpRequest();
                req1.setEndpoint('Endpoint URL'); //Adding Encript url to rest call   
                req1.setMethod('POST');
                req1.setHeader('content-type', 'application/json');
                req1.setTimeout(60000);
                req1.setBody(transactionReqBody);
                
                HttpResponse response1 = new HttpResponse();
                response1 = http.send(req1);
                System.debug('response======'+response);
            }
            
        }
    }
}