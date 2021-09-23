trigger ProjectTrigger on Project__c (before update, after update, before delete) {
    ProjectTriggerHelper helper = new ProjectTriggerHelper();
    
    if(Trigger.isBefore){
        if(Trigger.isDelete){
            for(Project__c itemP : Trigger.old){
                if(!(itemP.Status__c.equals('Done') || itemP.Status__c.equals('Cancelled'))){ 
                    System.debug('print message from isBefore--> isDelete');
                    itemP.addError('You are not allowed to close or delete Project if at least one Issue is still open.');
                }
            }
        }else if(Trigger.isUpdate){
            System.debug('print message from isBefore--> isUpdate');
            for(Project__c newP : Trigger.new){
                Project__c oldP = Trigger.oldMap.get(newP.Id);
                if(newP.Status__c.equals('Closed') && !(oldP.Status__c.equals('Done') ||oldP.Status__c.equals('Cancelled'))){
                    System.debug('Print message try update status, but old value equal Done or Cancelled');
                    newP.addError('You are not allowed to close or delete Project if at least one Issue is still open.');
                    //oldP.addError('You are not allowed to close or delete Project if at least one Issue is still open.');
                }                                            
            }
            
        }
    }else if(Trigger.isAfter){
        System.debug('print message from isAfter--> ...');
        for(Project__c newP : Trigger.new){
            Project__c oldP = Trigger.oldMap.get(newP.Id);
            if(Trigger.isUpdate){
                if(oldP.Status__c.equals('New') && newP.Status__c.equals('In Progress')){
                    System.debug('Print message insted of send mail...');
                    helper.changeStatusObserver('chevalier.vladimir@gmail.com', 'subject example', 'Project status was change.');
                }
            }
        }
    }
    
}