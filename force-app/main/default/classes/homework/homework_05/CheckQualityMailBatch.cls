public with sharing class CheckQualityMailBatch implements Database.Batchable<sObject> {
  private static String query = 'SELECT Name, Email FROM Contact';
  private static final Integer STATUS_CODE = 200;
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(query);
  }
  public void execute(Database.BatchableContext bc, List<Contact> records) {
    List<Contact> result = new List<Contact>();
    EmailQualityAPISetting__c apiSettings = EmailQualityAPISetting__c.getOrgDefaults();

    for (Contact c : records) {
      result.add(updateContact(apiSettings, c));
    }
    Database.update(result, false);
  }

  public void finish(Database.BatchableContext bc) {
    System.debug('batch finished!');
  }

  public static Contact updateContact(
    EmailQualityAPISetting__c apiSetting,
    Contact contact
  ) {
    String url =
      apiSetting.Endpoint__c +
      'api_key=' +
      apiSetting.Key__c +
      '&email=' +
      contact.email;

    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(url);
    request.setMethod('GET');
    HttpResponse response = http.send(request);

    if (response.getStatusCode() == 200) {
      Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
        response.getBody()
      );
      contact.Deliverability__c = results.get('deliverability').toString();
      contact.Quality_score__c = Double.valueOf(results.get('quality_score'));
      contact.Is_free_email__c = Boolean.valueOf(
        ((Map<String, Object>) results.get('is_free_email')).get('value')
      );
      contact.Is_Disposable_email__c = Boolean.valueOf(
        ((Map<String, Object>) results.get('is_disposable_email')).get('value')
      );
      contact.Is_role_email__c = Boolean.valueOf(
        ((Map<String, Object>) results.get('is_role_email')).get('value')
      );
      contact.Is_catchall_email__c = Boolean.valueOf(
        ((Map<String, Object>) results.get('is_catchall_email')).get('value')
      );
      contact.Is_mx_found__c = Boolean.valueOf(
        ((Map<String, Object>) results.get('is_mx_found')).get('value')
      );
      contact.Is_smtp_valid__c = Boolean.valueOf(
        ((Map<String, Object>) results.get('is_smtp_valid')).get('value')
      );
    }
    return contact;
  }
}
