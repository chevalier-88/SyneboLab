@RestResource(urlMapping='/Project/*')
global with sharing class RestHomeworkClass {
  //private String query = 'SELECT Id, Name, Priority__c, Description__c FROM Project__c WHERE Status__c = :status';

  @HttpGet
  global static List<Project__c> doGet() {
    RestRequest request = RestContext.request;
    String status = request.params.get('status');
    List<Project__c> result = Database.query(
      'SELECT Id, Name, Priority__c, Description__c FROM Project__c WHERE Status__c = :status'
    );
    return result;
  }

  @HttpPost
  global static Project__c postMethod(ProjectWrapper pw) {
    RestRequest request = RestContext.request;
    ProjectWrapper projectData = (ProjectWrapper) JSON.deserialize(
      request.requestbody.tostring(),
      ProjectWrapper.class
    );

    Project__c newProject = new Project__c();

    List<Contact> listContact = Database.query(
      'SELECT Id, AccountId, LastName, FirstName, Name, OtherAddress, Phone, Email, Location__c FROM Contact'
    );

    newProject.Name = projectData.name;
    newProject.Status__c = projectData.status;
    newProject.Priority__c = projectData.priority;
    Contact c = findContactByEmail(listContact, projectData.email) == null
      ? new Contact(LastName = 'UNKNOWN', Email = projectData.email)
      : findContactByEmail(listContact, projectData.email);
    newProject.Contact__c = c.Id;

    Database.insert(newProject);

    return newProject;
  }

  private static Contact findContactByEmail(
    List<Contact> contacts,
    String email
  ) {
    if (contacts.size() < 1) {
      return null;
    }
    for (Contact itemCont : contacts) {
      if (!String.isEmpty(itemCont.Email) && itemCont.Email.equals(email)) {
        return itemCont;
      }
    }
    return null;
  }

  global class ProjectWrapper {
    public String name { get; set; }
    public String status { get; set; }
    public String priority { get; set; }
    public String email { get; set; }
  }
}
