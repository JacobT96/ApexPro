trigger MaxCases on Case (before insert) {
    MaxCasesHelper.onInsert(Trigger.new);
}