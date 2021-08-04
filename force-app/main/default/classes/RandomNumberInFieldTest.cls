@isTest
public class RandomNumberInFieldTest {
    @isTest
    public static void correctRange() {
        List<Contact> newListOfContact = new List<Contact>();
        for (Integer i = 1; i<1001; i++) {
            newListOfContact.add(new Contact(LastName = 'Mitkevich' + i));
        }
        insert newListOfContact;
        List<Contact> oldListOfContact = [SELECT Random_number__c FROM Contact];
        Set<Decimal> countOfUnicNumbers = new Set<Decimal>(); 
        for (Contact contact: oldListOfContact) {
            System.assert(0 <= contact.Random_number__c && contact.Random_number__c <= 1000);
            countOfUnicNumbers.add(contact.Random_number__c);
        }
        System.assert(countOfUnicNumbers.size()>1);
    }

    @isTest 
    public static void incrementFieldValue() {
        List<Contact> newListOfContact = new List<Contact>();
        for (Integer i = 1; i<10; i++) {
            newListOfContact.add(new Contact(LastName = 'Mitkevich' + i));
        }
        insert newListOfContact;
        List<Contact> contactListForUpd = new List<Contact>();
        Map<Id, Decimal> valueOfContactRandomField = new Map<Id, Decimal>();
        for (Contact contact: [SELECT Id, LastName, Random_number__c FROM Contact]) {
            valueOfContactRandomField.put(contact.Id, contact.Random_number__c);
            contact.LastName = contact.LastName + 'upd';
            contactListForUpd.add(contact);
        }
        update contactListForUpd;
        for(Contact contact: [SELECT Id, Random_number__c FROM Contact]) {
            System.assert((valueOfContactRandomField.get(contact.Id) + 1) == contact.Random_number__c);
            System.debug((valueOfContactRandomField.get(contact.Id) + 1) + '--->' + contact.Random_number__c );
        }
    }
}