@IsTest
private class Test_PBS_AAAP_PageBaseController extends PBS_AAAP_PageBaseController {
    public boolean Go() {
        PageReference pr = new PageReference('/TEST');
        Test.setCurrentPageReference(pr);
        setQueryParam('p1', 'v1');
        setQueryParam('d1', '123.456');
        system.assertEquals('v1', getQueryParamAsString('p1'));
        system.assertEquals(123.456, getQueryParamAsDecimal('d1'));
        system.assertEquals(78.9, getQueryParamAsDecimal('d2', 78.9));
        return true;
    }

    @IsTest
    static void testBehavior() {
        TEST_PBS_AAAP_PageBaseController c = new Test_PBS_AAAP_PageBaseController();
        system.assert(c.Go());
    }
}