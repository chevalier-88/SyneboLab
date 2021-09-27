public with sharing class EmailMessageSender {
  public static void sendMail(String address, String subject, String body) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new List<String>{ address };
    mail.setToAddresses(toAddresses);
    mail.setSubject(subject);
    mail.setPlainTextBody(body);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
