trigger CaseTrigger on Case (after insert) {
for (Case CaseRecord:Trigger.new){
        CaseTriggerHandle.CreateLarkRecord(CaseRecord.Id);
    }
}