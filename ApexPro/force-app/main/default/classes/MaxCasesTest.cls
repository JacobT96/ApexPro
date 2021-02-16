@isTest
public with sharing class MaxCasesTest {
    @TestSetup
    static void makeData(){
        List<Case> cases = new List<Case>();
        for (Integer i=0; i<100; i++) {
            cases.add(new Case(status='New', Origin='Phone'));
        }
        insert cases;
    }

    @isTest
    public static void caseTest() {
        Integer count = [select count() from case];
        System.assertEquals(99, count);
    }
}