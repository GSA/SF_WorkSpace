public class PBS_LOP_ProgressBarController {
    public string pageURL{get;set;}
    public string baseURL{get;set;}
    public String pageURLForRedirection{get;set;}
    public PBS_LOP_ProgressBarController(){
        baseURL=Label.LOP_Community_Base_URL;
    }
    public PageReference redirectPage(){
           PageReference p =  new PageReference(pageURL);
           pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pageURL);
           p.setRedirect(false);
        	
        	return null; 
        	
    }
}