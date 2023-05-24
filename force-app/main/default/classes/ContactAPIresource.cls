@RestResource(urlMapping='/ContactAPI/*')
global with sharing class ContactAPIresource {
    @HTTPGet
    global static List<Contact> getContactId(){
        //Creating a request variable with the request values
        RestRequest contactRequest =RestContext.request;

        String contactRequestURI = contactRequest.requestURI;

        //Getting the integer value for limit condition in query
        Integer contactLimit = Integer.valueof(contactRequestURI.substring(contactRequestURI.lastIndexof('/')+1));

        List<contact> contactList =[SELECT Id, Name FROM Contact LIMIT: contactLimit];

        return contactList;
    }

   
    /*@HTTPPost      //----For creating with specified Parameters
    global static Contact createContact(String firstName, String lastName, String birthDate, String leadSource, String account){

        Contact newContact = new Contact();
        newContact.FirstName = firstName;
        newContact.LastName = lastName;
        newContact.Birthdate = Date.parse(birthDate);   
        newContact.LeadSource = leadSource;
        newContact.AccountId  = account;

        insert newContact;

        return newContact;
        
    }*/
    @HTTPPost
    //Creating Contact without pre-declared parameters
    global static Contact createContact(){

        RestRequest contactRequest= RestContext.request;
        String requestBody = contactRequest.requestBody.toString();

        //Deserializing the JSON response body & assigning it to an instance of Contact Object
        Contact contact =(Contact)JSON.deserialize(requestBody, Contact.class);  
        // Contact.class is a pre-defined wrapper class
        //date format should be "yyyy-mm-dd"

        insert contact;

        return contact;
    }

    @HTTPDelete
    global static Map<String, String> deleteContact(){
        Map<String, String> responseMap = new Map<String, String>();
        
    }

}