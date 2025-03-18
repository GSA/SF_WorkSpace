@IsTest
private class Test_PBS_AAAP_TriggerHelper {

    static testMethod void TriggerHelper_Test() {
        // test default constructor
        PBS_AAAP_TriggerHelper test = new PBS_AAAP_TriggerHelper();
        System.assertEquals(PBS_AAAP_TriggerHelper.Action.BEFOREINSERT, PBS_AAAP_TriggerHelper.Action.BEFOREINSERT);
    }

    static testMethod void Action_Test() {
        System.assertEquals(PBS_AAAP_TriggerHelper.Action.BEFOREINSERT, PBS_AAAP_TriggerHelper.Action.BEFOREINSERT);
        System.assertNotEquals(PBS_AAAP_TriggerHelper.Action.BEFOREINSERT, PBS_AAAP_TriggerHelper.Action.AFTERUPDATE);
    }


}