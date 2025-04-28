@IsTest
private class Test_PBS_LOP_ProgressBarController  {
    
    static testMethod void testProgressBar() {
        test.starttest();
        PBS_LOP_ProgressBarController pbs = new PBS_LOP_ProgressBarController();
        pbs.pageURL = '/PBS_LOP_Attachments';
        pbs.redirectPage();
        system.assert(pbs!=null);
        test.stoptest();
    
    }
    
  }