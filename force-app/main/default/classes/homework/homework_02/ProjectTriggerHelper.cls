public with sharing class ProjectTriggerHelper {
  public void changeStatusObserver(
    String mailRecipient,
    String subject,
    String bodyMessage
  ) {
    List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String[] toAddresses = new List<String>{ mailRecipient };
    mail.setToAddresses(toAddresses);

    mail.setSubject(subject);
    mail.setPlainTextBody(bodyMessage);
    emailList.add(mail);

    Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
  }
}
