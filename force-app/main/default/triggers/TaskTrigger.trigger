trigger TaskTrigger on Task (after insert) {
for (Task TaskRecord:Trigger.new){
    String whatId = TaskRecord.WhatId;
    List<Account> AccIdCheck = [Select Id from Account where Id =:whatId LIMIT 1 ];
    List<Case> CaseIdCheck = [Select Id from Case where Id =:whatId LIMIT 1 ];
    If (AccIdcheck.size()>0 || CaseIdCheck.size() >0 ){
        TaskTriggerHandle.CreateLarkRecord(TaskRecord.Id);
    }
       
    }
}