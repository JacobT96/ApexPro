public inherited sharing class PrimaryContactHelper {
    public static void doInsert(List<Contact> contacts) {
        for (Contact c : contacts) {
            if (c.AccountId != null) {
                Integer numContacts = [select count() from contact where AccountId = :c.AccountId];
                if (numContacts == 0) {
                    c.Primary_Contact__c = true;
                }
                else if (c.Primary_Contact__c) {
                    if ([select count() from contact where AccountId = :c.AccountId and primary_contact__c = true] > 0) {
                        c.Primary_Contact__c.addError('Only one primary contact allowed');
                    }
                }
            }
        }
    }
}