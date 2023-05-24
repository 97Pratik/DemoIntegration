@RestResource(urlMapping='/ContactAPIParam/*')
global with sharing class ContactAPIidName {

    @HTTPGet
    global static List<Contact> getContactFromParams(){

        RestRequest contactReq = RestContext.request;

        Map<String,String> contactRequestParams = contactReq.params;

        Integer contactLimit = Integer.valueof(contactRequestParams.get('limit'));

        String leadSource = contactRequestParams.get('leadsource');

        List<contact> contactList =[SELECT Id, Name FROM Contact WHERE LeadSource =: leadSource LIMIT: contactLimit];

        return contactList;
    }

    
}