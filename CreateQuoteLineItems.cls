public class CreateQuoteLineItems {
    @InvocableMethod
    public static void createquoteLineItems(List<Id>OppIds){
        
        List<QuoteLineItem>quoteLneItemList=new List<QuoteLineItem>();
        Map<id,Quote> oppQuoteMap=new map<id,Quote>();
        
        //List<Opportunity> oppList = [SELECT Pricebook2Id, AccountId, ContactId, Order_Created__c  FROM Opportunity WHERE Id in:OppIds];
        List<OpportunityLineItem> opliList = [SELECT id,Product2Id,OpportunityId, UnitPrice, Quantity,PricebookEntryId, TotalPrice  FROM OpportunityLineItem  WHERE OpportunityId in:OppIds];
        List<Quote>QuoteList=[select id,name,OpportunityId from Quote where OpportunityId in: OppIds];
        
        for(quote qo:QuoteList){
            
            oppQuoteMap.put(qo.OpportunityId,qo);
        }
        
        if(!opliList.isEmpty()){
        for(OpportunityLineItem oppli:opliList){
            
            QuoteLineItem quoLi=new QuoteLineItem();
            
            quoLi.QuoteId=oppQuoteMap.get(oppli.OpportunityId).id;
            quoLi.PricebookEntryId=oppli.PricebookEntryId;
            quoLi.Product2Id=oppli.Product2Id;
            quoLi.UnitPrice=oppli.UnitPrice;
            quoLi.Quantity=oppli.Quantity;
            quoLi.ServiceDate=date.today()+5;
            
            quoteLneItemList.add(quoLi);
            
            
        }
           insert quoteLneItemList;   
        }
        
      
        
        
        
        
    } 
    
}