@isTest(SeeAllData=true)
public with sharing class RenewalTestAllData {
    @isTest
    static void testSuccess() {
        Opportunity op = [SELECT Id FROM Opportunity WHERE name = 'Test' LIMIT 1].get(0);
        if (op == null)
            op = TestDataFactory.createOpportunity('Test', TestDataFactory.createAccount('acc', true).Id, Date.today(), 'Open', true);
        update op;
        Opportunity renewal = [SELECT Id FROM Opportunity WHERE name = 'Test Renewal'];
        System.assert(renewal != null);
    }

    @isTest
    static void testRunAs() {
        Id profileId = [SELECT id FROM Profile WHERE name = 'Marketing User' LIMIT 1].Id;
        User u = [SELECT id FROM User WHERE profileId = :profileId].get(0);
        System.runAs(u) {
            Integer renewals = [SELECT COUNT() FROM Opportunity WHERE name = 'Test Renewal'];
            Opportunity op = [SELECT Id FROM Opportunity LIMIT 1];
            op.stagename = 'Closed Won';
            update op;
            System.assert([SELECT COUNT() FROM Opportunity WHERE name = 'Test Renewal'] > renewals);
        }
    }
}