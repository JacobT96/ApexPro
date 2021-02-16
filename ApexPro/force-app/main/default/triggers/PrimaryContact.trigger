trigger PrimaryContact on Contact (before insert) {
    PrimaryContactHelper.doInsert(Trigger.new);
}