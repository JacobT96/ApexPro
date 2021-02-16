@isTest
public with sharing class CreateRenewalTest {
    @TestSetup
    static void setupTest(){
        Map<String, Schema.RecordTypeInfo> recordTypeInfos = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        Id oppRecordTypeId = recordTypeInfos.get('Opportunity').getRecordTypeId();
        Id renewalRecordTypeId = recordTypeInfos.get('Renewal').getRecordTypeId();
        Account acc = TestDataFactory.createAccount('Test', true);
        Opportunity opp = TestDataFactory.createOpportunity('Test', acc.Id, Date.newInstance(2021, 2, 11), 'Open', true);
    }

    @isTest
    public static void testSuccess() {
        Opportunity op = [SELECT OwnerId FROM Opportunity WHERE Name = 'Test'];
        op.StageName = 'Closed Won';
        Update op;
        Opportunity renewal = [SELECT AccountId,Name,CloseDate,StageName,RecordTypeId,OwnerId FROM Opportunity WHERE Name='Test Renewal'];
        Account acc = [SELECT name,Id FROM Account WHERE Id = :op.AccountId];
        Map<String, Schema.RecordTypeInfo> recordTypeInfos = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        Id oppRecordTypeId = recordTypeInfos.get('Opportunity').getRecordTypeId();
        Id renewalRecordTypeId = recordTypeInfos.get('Renewal').getRecordTypeId();
        System.assertEquals(acc.Id, renewal.AccountId);
        System.assertEquals('Test Renewal', renewal.Name);
        System.assert(renewal.CloseDate.isSameDay(Date.newInstance(2022, 2, 11)));
        System.assertEquals('Open', renewal.StageName);
        System.assertEquals(renewalRecordTypeId, renewal.RecordTypeId);
        System.assertEquals(op.ownerId, renewal.OwnerId);
    }

    @isTest
    public static void testWrongStage() {
        Opportunity op = [SELECT OwnerId FROM Opportunity WHERE Name = 'Test' AND StageName != 'Closed Won'];
        Integer renewals = [SELECT COUNT() FROM Opportunity WHERE Name = 'Test Renewal'];
        Update op;
        System.assertEquals(renewals, [SELECT COUNT() FROM Opportunity WHERE Name = 'Test Renewal']);
    }
}