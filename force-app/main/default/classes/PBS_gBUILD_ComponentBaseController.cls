public with sharing virtual class PBS_gBUILD_ComponentBaseController 
{
    public PBS_gBUILD_PageBaseController pageController { get; set; }
    
    public string key{
        get;
        set{
        	if (value!=null){ 
        	
        	key = value;
                if (pageController!=null){
                    pageController.registerComponentController(value, this);
                    onRegistered();
                }
			}
         }
    }
    
    
    
    protected virtual void onRegistered(){} 
}