trigger CreateRenewal on Oppportunity (before update) {
    Map<Id, Opportunity> renewals = new Map<Id, Opportunity>();
    for (Opportunity opp : Trigger.new) {
        if (opp.StageName.equals('Closed Won')) {
            Opportunity renewal = new Opportunity();
            renewal.AccountId = 'opp.AccountId';
            renewal.Name = opp.Name + 'Renewal';
            renewal.CloseDate = opp.CloseDate + 365;
            renewal.StageName = 'Open';
            renewal.RecordType = 'Renewal';
            renewal.OwnerId = opp.OwnerId;
            renewals.put(renewal.Id, renewal);
        }
    }
    insert renewals;
}