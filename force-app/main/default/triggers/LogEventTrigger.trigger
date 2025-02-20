trigger LogEventTrigger on Log__e (after insert) {
    new LogEventTriggerHandler(trigger.new).handle();
}