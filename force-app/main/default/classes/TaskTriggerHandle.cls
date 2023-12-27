public class TaskTriggerHandle {
    @future (callout=true)
    static public void CreateLarkRecord(String recordId){
        	List<Task> RecordforInput= [Select Id,ActivityDate,Status, Description,Subject	 from Task where Id = :recordId];
        	For(Task SingleTask:RecordforInput){
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
        	req2.setEndpoint('https://open.feishu.cn/open-apis/bitable/v1/apps/GwWubO6I4aluxhs4KCil6TS3gBX/tables/tblJL5ILA4cX3Ktw/records/');
            req2.setMethod('POST');
        	req2.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req2.setHeader('Authorization', 'Bearer '+ tenant_access_token );
            
            Date duedate = date.newinstance(SingleTask.ActivityDate.year(), SingleTask.ActivityDate.month(), SingleTask.ActivityDate.day());
			System.debug('sssadasd'+duedate);
            req2.setBody('{"fields":{"Subject":"'+ SingleTask.Subject+'","Description":"' +SingleTask.Description+'","Status":"'+SingleTask.Status+'","Due Date":"'+ duedate + '"}}');
        	HttpResponse res2 = new http().send(req2);
                 Map<string,object> m2 = (Map<string,object>)JSON.deserializeUntyped(res.getbody());
            }
        Update RecordforInput;
    }
}