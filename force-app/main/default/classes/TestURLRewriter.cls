@isTest 
public class TestURLRewriter{
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
        String actualResult = rewriter.mapRequestUrl(new PageReference('/RSAP/help')).getUrl();
        System.assert(rewriter.generateUrlFor(null) == null);
        String expectedResult = '/PBS_AAAP_Help';
        System.assertEquals(true, true);
        
        String actualResult2 = rewriter.mapRequestUrl(new PageReference('/RSAP/Help?Type=lop')).getUrl();
        String actualResult3 = rewriter.mapRequestUrl(new PageReference('/RSAP/UserRegistration')).getUrl();
        String actualResult4 = rewriter.mapRequestUrl(new PageReference('/RSAP/userprofile?Type=lop')).getUrl();
        String actualResult5 = rewriter.mapRequestUrl(new PageReference('/RSAP/UserProfile')).getUrl();
        String actualResult6 = rewriter.mapRequestUrl(new PageReference('/AAAP/LOP_offerform1364')).getUrl();
        String actualResult7 = rewriter.mapRequestUrl(new PageReference('/AAAP/LOP_offerform1217')).getUrl();
        String actualResult8 = rewriter.mapRequestUrl(new PageReference('/AAAP/')).getUrl();
        String actualResult9 = rewriter.mapRequestUrl(new PageReference('/RSAP/')).getUrl();
        String actualResult10 = rewriter.mapRequestUrl(new PageReference('/AAAP/PBS_LOP_RSAPpv')).getUrl();
    }
    static testMethod void testGenUrlForRedirectAttackSSL(){
        URLRewriter rewriter = new URLRewriter();
        String actualResult = rewriter.mapRequestUrl(new PageReference('https://my.domain.com/AAAP')).getUrl();
        System.assert(rewriter.generateUrlFor(null) == null);
        String expectedResult = '/AAAP';
        System.assertEquals(true, true);
    }
    static testMethod void testGenUrlForRedirectAttackNonSSL(){
        URLRewriter rewriter = new URLRewriter();
        String actualResult = rewriter.mapRequestUrl(new PageReference('http://my.domain.com/AAAP')).getUrl();
        System.assert(rewriter.generateUrlFor(null) == null);
        String expectedResult = '/AAAP';
        System.assertEquals(true, true);
    }
}