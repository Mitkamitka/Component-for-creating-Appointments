public with sharing class RandomNumberInFieldTriggerHelper {
    public static void randomNum(List<Contact> listOfTriggerContactsForInsert) {
        List<Contact> newListOfContactsForInsert = new List<Contact>();
        for (Contact contact: listOfTriggerContactsForInsert) {
            contact.Random_number__c = Integer.valueOf(Math.random()*1000);
            newListOfContactsForInsert.add(contact);
        }
    } 

    public static void incrementRandomNumberFieldValue(List<Contact> listOfTriggerContactsForUpd) {
        List<Contact> newListOfContactsForUpd = new List<Contact>();
        for (Contact contact: listOfTriggerContactsForUpd) {
            contact.Random_number__c = contact.Random_number__c + 1;
            newListOfContactsForUpd.add(contact);
        }
    }
}