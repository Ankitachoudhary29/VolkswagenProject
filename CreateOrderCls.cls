public class CreateOrderCls {
    @InvocableMethod
    public static void createOrderMethod(List<id> oppId){
        
        List<OrderItem> OrderLineItems = New List<OrderItem>();
        List<Order>orList=new List<Order>();
        Map<id,Order>oppOrderMap=new Map<id,Order>();
        
        List<Opportunity> oppList = [SELECT Pricebook2Id, AccountId, ContactId, Order_Created__c  FROM Opportunity WHERE Id in:oppId];
        List<OpportunityLineItem > opliList = [SELECT id,Product2Id,OpportunityId, UnitPrice, Quantity,PricebookEntryId, TotalPrice  FROM OpportunityLineItem  WHERE OpportunityId in:oppId];
        
        //Create an order
        
        for(Opportunity oppRec: oppList){
            Order orders=new order();
            orders.AccountId=oppRec.AccountId;
            orders.BillToContactId=oppRec.ContactId;
            orders.EffectiveDate = date.today();
            orders.Status='Draft';
            orders.Pricebook2Id=oppRec.Pricebook2Id;
            orders.EndDate  = date.today()+7;
            
            orders.OpportunityId=oppRec.Id;
            orList.add(orders);
        }
        Insert orList;
        
        for(Order ol:orList){
            
            oppOrderMap.put(ol.OpportunityId,ol);
        }
        
        
        //create orderItem
        
        for(OpportunityLineItem oplis:opliList){
            
            OrderItem orItem=new OrderItem();
            orItem.Quantity=oplis.Quantity;
            orItem.Product2Id=oplis.Product2Id;
            orItem.OrderId =oppOrderMap.get(oplis.OpportunityId).id;
            orItem.UnitPrice  = oplis.UnitPrice;
            orItem.PricebookEntryId=oplis.PricebookEntryId;
            OrderLineItems.add(orItem);            
        }
        insert OrderLineItems;       
        
    } 
    
}