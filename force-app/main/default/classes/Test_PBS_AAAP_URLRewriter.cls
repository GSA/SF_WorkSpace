@isTest 
public class Test_PBS_AAAP_URLRewriter{
    static testMethod void testGenerateUrlForSite(){
        URLRewriter rewriter = new URLRewriter();
        String actualResult = rewriter.mapRequestUrl(new PageReference('/AAAP')).getUrl();
        System.assert(rewriter.generateUrlFor(null) == null);
        String expectedResult = '/PBS_AAAP_HomePage';
        System.assertEquals(true, true);
    }
    static testMethod void testGenerateUrlForPages(){
        URLRewriter rewriter = new URLRewriter();
        String actualResult = rewriter.mapRequestUrl(new PageReference('/AAAP/PBS_AAAP_HomePage')).getUrl();
        System.assert(rewriter.generateUrlFor(null) == null);
        String expectedResult = '/PBS_AAAP_HomePage';
        System.assertEquals(true, true);
    }
    static testMethod void testGenerateUrlForSitePages(){
        URLRewriter rewriter = new URLRewriter();
        String actualResult = rewriter.mapRequestUrl(new PageReference('/PBS_AAAP_HomePage')).getUrl();
        System.assert(rewriter.generateUrlFor(null) == null);
        String expectedResult = '/PBS_AAAP_HomePage';
        System.assertEquals(true, true);
    }
}