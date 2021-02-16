trigger CreateRenewal on Opportunity (before update) {
    Map<String, Schema.RecordTypeInfo> recordTypeInfos = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
    Id renewalRecordTypeId = recordTypeInfos.get('Renewal').getRecordTypeId();
    List<Opportunity> renewals = new List<Opportunity>();
    for (Opportunity opp : Trigger.new) {
        if (opp.StageName.equals('Closed Won')) {
            Opportunity renewal = new Opportunity();
            renewal.AccountId = opp.AccountId;
            renewal.Name = opp.Name + 'Renewal';
            renewal.CloseDate = opp.CloseDate + 365;
            renewal.StageName = 'Open';
            renewal.RecordTypeId = renewalRecordTypeId;
            renewal.OwnerId = opp.OwnerId;
            renewals.add(renewal);
        }
    }
    insert renewals;
}