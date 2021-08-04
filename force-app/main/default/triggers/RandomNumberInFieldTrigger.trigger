trigger RandomNumberInFieldTrigger on Contact (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert) {
        RandomNumberInFieldTriggerHelper.randomNum(Trigger.new);
    } else if(Trigger.isBefore && Trigger.isUpdate) {
        RandomNumberInFieldTriggerHelper.incrementRandomNumberFieldValue(Trigger.new);
    }
}