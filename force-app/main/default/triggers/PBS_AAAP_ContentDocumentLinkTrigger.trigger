trigger PBS_AAAP_ContentDocumentLinkTrigger on ContentDocumentLink (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    //Here we are calling PBS_AAAP_ContentDocumentLinkHandler
    TriggerDispatcher.Run(new PBS_AAAP_ContentDocumentLinkHandler());
}