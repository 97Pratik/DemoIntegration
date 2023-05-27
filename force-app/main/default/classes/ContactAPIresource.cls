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

    //To delete Multiple contacts using API
    @HTTPDelete
    global static List<ResponseWrapper> deleteContact(){
        List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
        RestRequest contactRequest = RestContext.request;

        String contactRequestURI = contactRequest.requestURI;   \\ To Get Request URI
        String[] contactIdsToDelete =(contactRequestURI.substring(contactRequestURI.lastIndexof('/')+1)).split(','); // adding Ids To list

        List<Contact> contactsToDelete = new List<Contact>();

        for(String contactId : contactIdsToDelete){
            Contact contact = new Contact(Id=contactId); // referencing the Id To Contact Object
            contactsToDelete.add(contact);
        }

        //Deleting contacts with partial success enabled
        Database.DeleteResult[] deleteResults = Database.delete(contactsToDelete,false);
        for(Database.DeleteResult deleteResult :deleteResults){
            ResponseWrapper wrapper = new ResponseWrapper();
            if(deleteResult.IsSuccess()){
                wrapper.success ='1';
                wrapper.message ='Successfully Deleted Contact with Id:  '+ deleteResult.getId();
            }
            else{
                wrapper.success = '0';
                for(Database.Error error : deleteResult.getErrors()){
                    wrapper.message = ' The following Error has occurred for Contact With Id:  '+ deleteResult.getId();
                    wrapper.message += error.getStatusCode()+' : ' + error.getMessage()+'. ';
                    wrapper.message+= 'Contact Fields that affected this error : '+ error.getFields();
                }
            }
            responseWrapperList.add(wrapper);  // adding all the success & error message to the list
        }
        return responseWrapperList; 
    }

    //for handling error & success message
    global class ResponseWrapper{
        String success;
        String message;
    }

}