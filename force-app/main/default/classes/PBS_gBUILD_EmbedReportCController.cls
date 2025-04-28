public with sharing class PBS_gBUILD_EmbedReportCController
{
    public Integer zIndex { get; set; }
    public Integer width { get; set; }
    public Integer height { get; set; }
    public String reportId { get; set; }  
    public string frameId { get; private set; }  
    private static integer frameNum = 0;
    public String heightAttrVal
    {
        get
        {
            return string.valueOf(height)+'px';
        }
    }
    public String widthAttrVal
    {
        get
        {
            if (width==null) return '100%';
            return string.valueOf(width)+'px';
        }
    }
    
    public PBS_gBUILD_EmbedReportCController()
    {
        zIndex = 0;
        frameId = 'erf'+string.valueOf(frameNum++);
    }
}