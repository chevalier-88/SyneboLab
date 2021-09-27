public with sharing class ProjectDataUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
  private String address;
  private String subject = 'Project Updated';
  private String messageBody = 'Congratulation!! Your project was update!';
  private String query = 'SELECT Id, Name, CreatedDate, Contact__c, Description__c, Status__c, LastModifiedDate FROM Project__c';

  public ProjectDataUpdateBatch() {
    this.address = UserInfo.getUserEmail();
  }

  public ProjectDataUpdateBatch(String address) {
    this.address = address;
  }

  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext bc, List<Project__c> projects) {
    List<Project__c> updateResult = new List<Project__c>();
    for (Project__c p : projects) {
      p.Description__c = p.Description__c + ' - Update!!!';
    }
    update updateResult;
  }

  public void finish(Database.BatchableContext bc) {
    EmailMessageSender.sendMail(address, subject, messageBody);
  }
}
