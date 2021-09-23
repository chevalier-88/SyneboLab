trigger WorkLogTrigger on WorkLog__c (before insert) {
	for(WorkLog__c wLog: Trigger.new){
		if(wLog.Date__c == null){
            wLog.Date__c = System.today();
        }
    }   
}