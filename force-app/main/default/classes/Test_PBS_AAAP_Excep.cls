@IsTest
private class Test_PBS_AAAP_Excep {

    static testMethod void testApprovalException() {
        try {
            PBS_AAAP_Exception excpt = new PBS_AAAP_Exception('Approval exception error message');
            //throw new PBS_AAAP_Exception('Approval exception error message');
            throw excpt;
            // should not reach here
            System.assert(false);
        } catch (PBS_AAAP_Exception e) {
            //throw new PBS_AAAP_Exception('Approval exception error message');
        }

        try {
            throw new PBS_AAAP_Exception();
            // should not reach here
            System.assert(false);
        } catch (PBS_AAAP_Exception e) {
            //throw new PBS_AAAP_Exception('Approval exception error message');
        }
        try {
            PBS_AAAP_Exception o = new PBS_AAAP_Exception('Callout exception error message');
            // I am not sure what is being tested here.  the methods look like constructors but
            // are coded incorrectly for constructors by returning data types and the methods does nothing
            o.PBS_AAAP_Exception('');
            o.PBS_AAAP_Exception('', '');
            throw new PBS_AAAP_Exception('Callout exception error message');
        } catch (PBS_AAAP_Exception ce) {
        }
    }
}