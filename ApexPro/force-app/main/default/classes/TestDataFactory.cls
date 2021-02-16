@isTest
public inherited sharing class TestDataFactory {
    public static Account createAccount(String accname, Boolean doInsert) {
        Account acc = new Account(name=accname);
        if (doInsert) insert acc;
        return acc;
    }

    public static Opportunity createOpportunity(String oppname, Id accountId, Date closeDate, String stageName, Boolean doInsert) {
        Opportunity opp = new Opportunity(name=oppname, AccountId=accountId, CloseDate=closeDate, StageName=stageName);
        if (doInsert) insert opp;
        return opp;
    }

    public static Contact createContact(String lastName, Boolean doInsert) {
        Contact c = new Contact(LastName=lastName);
        if (doInsert) insert c;
        return c;
    }
}