@isTest
public with sharing class CreateRenewalTest {
    @TestSetup
    static void setupTest(){
        Map<String, Schema.RecordTypeInfo> recordTypeInfos = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        Id oppRecordTypeId = recordTypeInfos.get('Opportunity').getRecordTypeId();
        Id renewalRecordTypeId = recordTypeInfos.get('Renewal').getRecordTypeId();
        Account acc = new Account(Name = 'Test');
        Insert acc;
        Opportunity opp = new Opportunity(
            AccountId = acc.Id,
            Name = 'Test',
            CloseDate = Date.newInstance(2021, 2, 11),
            StageName = 'Open',
            RecordTypeId = oppRecordTypeId
        );
        Insert opp;
        Update opp;
    }

    @isTest
    public static void test() {
        Opportunity op = [SELECT OwnerId FROM Opportunity WHERE Name = 'Test'];
        Opportunity renewal = [SELECT AccountId,Name,CloseDate,StageName,RecordTypeId,OwnerId FROM Opportunity WHERE Name='Test Renewal'];
        Account acc = [SELECT name,Id FROM Account WHERE acc.Id = :op.AccountId];
        System.assertEquals(acc.Id, renewal.AccountId);
        System.assertEquals('Test Renewal', renewal.Name);
        System.assert(renewal.CloseDate.isSameDay(Date.newInstance(2022, 2, 11)));
        System.assertEquals('Open', renewal.StageName);
        System.assertEquals(renewalRecordTypeId, renewal.RecordTypeId);
        System.assertEquals(ownerId, renewal.OwnerId);
    }
}