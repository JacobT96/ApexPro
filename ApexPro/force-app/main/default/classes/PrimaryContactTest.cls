@isTest
public with sharing class PrimaryContactTest {
    @TestSetup
    static void makeData(){
        Account a = new Account(name='test account');
        insert a;
        insert new Contact(lastname='test', accountid=a.id);
        insert new Contact(lastname='test2', accountid=a.id);
    }
    
    @isTest
    public static void testFirst() {
        Contact c = [select id,Primary_Contact__c from Contact where lastname = 'test'];
        System.assert(c.Primary_Contact__c);
    }

    @isTest
    public static void testNotPrimary() {
        Contact c = [select id,Primary_Contact__c from Contact where lastname = 'test2'];
        System.assert(!c.Primary_Contact__c);
    }

    @isTest
    public static void testCantAdd() {
        Id profileId = [select id from Profile where name='Marketing Team'].id;
        User u = [select id from User where profileId=:profileId];
        Id acc = [select id from Account where name='test account'].id;
        System.runAs(u) {
            Contact c = new Contact(lastname='bad test', accountId=acc, Primary_Contact__c=true);
            insert c;
            Integer badcontact = [select count() from Contact where lastname='bad test'];
            System.assertEquals(0, badcontact);
        }
    }
}