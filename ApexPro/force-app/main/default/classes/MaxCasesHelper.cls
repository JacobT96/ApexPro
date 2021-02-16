public inherited sharing class MaxCasesHelper {
    public static void onInsert(List<Case> cases) {
        Decimal max = [select Maximum__c from Max_Cases_Per_Month__mdt].Maximum__c;
        String userId = System.UserInfo.getUserId();
        User u = [select name from User where Id = :userId];
        Date monthStart = Date.today().toStartOfMonth();
        Integer numcases = [select count() from Case where CreatedById=:userId and CreatedDate >= :monthStart];
        if (numcases+1 > max) {
            cases[0].addError('99 cases already created this month for user ' + u.Name + ' ' + userId);
        }
    }
}