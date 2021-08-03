public class CreateSeviceContractNAsset {
    
    @InvocableMethod
    public static void createSLAPerProduct(List<Id>orderIds){
        
        List<ServiceContract> serConList=new List<ServiceContract>();
        List<ContractLineItem> conliList=new List<ContractLineItem>();
        List<Asset>assetList=new List<asset>();
        List<Asset>aList=new List<asset>();
        Map<Id,OrderItem> orderItemMap=new Map<Id,OrderItem>();
           Map<Id,Order> olProdMap=new Map<Id,Order>();
        
        List<OrderItem> oliList=[select id,Product2Id,Quantity,UnitPrice,TotalPrice,OrderId from OrderItem where OrderId in:orderIds ];
        Map<id,order> olObjMap=new Map<Id,Order>([select id,OrderNumber,AccountId,BillToContactId,	Is_Subscription__c from  order where id in:orderIds]);
        
        List<Product2> Products=new List<Product2>();
        
        // save product into asset
        for(OrderItem orli:oliList){
            
            orderItemMap.put(orli.Product2Id,orli );
            olProdMap.put(orli.Product2Id,olObjMap.get(orli.OrderId));
            //OrderLiMap.put(orli.id,)
            
        }
       
        
        Products=[select id,name from Product2 where id in:orderItemMap.keyset() ];
        
        for(Product2 p:Products ){
            
            
            Asset asObj=new Asset();
            asObj.Name=p.name;
            asObj.Product2Id=p.id;
            asObj.Status='Purchased';
            asObj.PurchaseDate=date.today();
            asObj.Price=orderItemMap.get(p.Id).TotalPrice;
            asObj.Quantity= orderItemMap.get(p.Id).Quantity;
            asObj.AccountId=olProdMap.get(p.id).AccountId;
            asObj.ContactId=olProdMap.get(p.id).BillToContactId;
         
            
            assetList.add(asObj);
            }
        
        insert assetList;
        
        for(Asset a:assetList){
            if(olProdMap.get(a.Product2Id).Is_Subscription__c==true){
                
                aList.add(a);
                
                system.debug('aList'+aList);
            }
        }
        
        
        if(!aList.isEmpty()){
            CreateSeviceContractNAsset.createSubscriptionsMethod(aList);
            
            
        }
        
        
    }
    
    public static  void createSubscriptionsMethod(List<Asset>asObjList){
        
        List<Subscription__c> subList=new List<Subscription__c>();
        
        for(Asset aObj: asObjList){
            
            Subscription__c sp=new Subscription__c();
            
            sp.Asset_Product__c=aObj.Id;
            sp.Start_Date__c=date.today();
            sp.End_Date__c=date.today()+364;
            sp.Term_months__c=12;
            sp.Name='Subscripton of'+' '+''+aObj.Name;
            
            subList.add(sp);
            
        }
        
        insert subList;
        
        
    }
    
}