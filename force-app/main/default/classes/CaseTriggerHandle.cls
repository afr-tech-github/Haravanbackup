public class CaseTriggerHandle {

    @future (callout=true)
    static public void CreateLarkRecord(String recordId){
        	List<Case> RecordforInput= [Select Id,Status,Subject,Priority,Description,ContactPhone,Type,External_ID__c,Origin	 from Case where Id = :recordId];
        	For(Case SingleCase:RecordforInput){
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://open.larksuite.com/open-apis/auth/v3/app_access_token/internal');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            
                JSONGenerator gen = JSON.createGenerator(true);
				gen.writeStartObject();
        		gen.writeStringField('app_id', 'cli_a44cd6ec7c78d010');
       			gen.writeStringField('app_secret', 'wiuWuSwiauER25QgUO2WZeY4WY0NAgJg');
       			gen.writeEndObject();        
       			String body = gen.getAsString();
                
        	req.setBody(body);
            HttpResponse res = new http().send(req);
            Map<string,object> m = (Map<string,object>)JSON.deserializeUntyped(res.getbody());
            String tenant_access_token =(String)m.get('tenant_access_token');
            //if(res.getStatusCode() == 200) {acc.token__c = '1';} 	
           
          	System.debug(tenant_access_token); 
     
                
          	HttpRequest req2 = new HttpRequest();
        	req2.setEndpoint('https://open.feishu.cn/open-apis/bitable/v1/apps/GwWubO6I4aluxhs4KCil6TS3gBX/tables/tblMpp8KmmNUzzvK/records/');
            req2.setMethod('POST');
        	req2.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req2.setHeader('Authorization', 'Bearer '+ tenant_access_token );
            req2.setBody('{"fields":{"Subject":"'+ SingleCase.Subject+'","Description":"' +SingleCase.Description+'","Status":"'+SingleCase.Status+ '","Priority":"' +SingleCase.Priority+'","Type":"'+SingleCase.Type+'","Case Origin":"'+SingleCase.Origin+'"}}');
        	HttpResponse res2 = new http().send(req2);
                 Map<string,object> m2 = (Map<string,object>)JSON.deserializeUntyped(res.getbody());
                
                SingleCase.External_ID__c = (String)m2.get('record_id');
        }
        Update RecordforInput;
    }
}