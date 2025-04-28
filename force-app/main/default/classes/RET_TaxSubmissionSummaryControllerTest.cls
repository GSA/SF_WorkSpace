@istest
private class RET_TaxSubmissionSummaryControllerTest {

    @isTest
    static void basicCodeCoverage() {
        Map<String, String> tmpData = RET_TaxSubmissionSummaryController.getPageData();
        system.assertEquals(1, tmpData.values().size());
        system.assertEquals(true, tmpData.containskey('userName'));
    }

}