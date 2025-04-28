@isTest(SeeAllData=false)
public class TestPBS_ePM_FileManagerController
{
    static 
    {
        TestPBS_gBUILD_Utility.setup();
    }

    public static testMethod void testConstructor()
    {
        PBS_ePM_FileManagerController ctrl = new PBS_ePM_FileManagerController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.uploadAgain());
        system.assertEquals(null, ctrl.logout());
    }

    public static testMethod void testSoapFault()
    {
        dom.XmlNode x;

        x = TestPBS_gBUILD_Utility.getXmlRoot(
'<?xml version="1.0" encoding="utf-8"?>'+
'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing">'+
'  <soap:Header>'+
'    <wsa:Action>http://schemas.xmlsoap.org/ws/2004/08/addressing/fault</wsa:Action>'+
'    <wsa:MessageID>urn:uuid:625ba6d0-5f0a-4cc5-b7a8-8c6a675ceaec</wsa:MessageID>'+
'    <wsa:RelatesTo>urn:uuid:5c55cad2-0fdf-4acb-b5dc-b1f30a77b00c</wsa:RelatesTo>'+
'    <wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To>'+
'  </soap:Header>'+
'  <soap:Body>'+
'    <soap:Fault>'+
'      <faultcode>soap:Server</faultcode>'+
'      <faultstring>Cannot authenticate user. Invalid user credentials provided.</faultstring>'+
'      <detail>'+
'        <serviceException type="MeridianSystems.Platform.Exceptions.SecurityServiceException, MeridianSystems.Platform, Version=4.2.5430.0, Culture=neutral, PublicKeyToken=null">'+
'          <SecurityServiceException xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
'            <Message>Cannot authenticate user. Invalid user credentials provided.</Message>'+
'            <ResourceID>Core.Communications.Strings:InvalidUserCredentials</ResourceID>'+
'            <DescriptionParameters />'+
'            <Severity>Critical</Severity>'+
'            <DeveloperNotes />'+
'          </SecurityServiceException>'+
'        </serviceException>'+
'      </detail>'+
'    </soap:Fault>'+
'  </soap:Body>'+
'</soap:Envelope>');
                
        try
        {
            PBS_ePM_FileManagerController.validateNoFault(x, 'jason thomas');
            system.assert(false, 'an exception was expected');
        }
        catch (PBS_ePM_FileManagerController.SoapFaultException sfex)
        {
            PBS_ePM_FileManagerController.SoapFault sf = sfex.fault;
            system.assertEquals(true, sf.IsFault);
            system.assertEquals('Cannot authenticate user. Invalid user credentials provided.', sf.FaultString);
            system.assertEquals('soap:Server', sf.FaultCode);
        }

        x = TestPBS_gBUILD_Utility.getXmlRoot('<?xml version="1.0" encoding="utf-8"?><a>gBUILD rocks</a>');
        PBS_ePM_FileManagerController.validateNoFault(x, 'jason thomas');
    }
  
    public static testMethod void testePMDoc()
    {  
        ApexPages.currentPage().getParameters().put('desc','test');
        PBS_ePM_FileManagerController con= new PBS_ePM_FileManagerController();
        con.documentAreaGuid ='1234';
        PageReference  pf=con.selectProject();
        system.assertEquals(pf,null);
        con.username='ankit.mishra@eglobaltech.com'; 
        con.password='Acess503*';
        // con.ePMUrl ='https://workspace--wsdev.cs12.my.salesforce.com';
        con.org='wsdev';
        pf=con.login();
        Document file= new Document();
        file.body=Blob.valueOf('Unit Test Attachment Body');
        file.name='test';
        con.file=file;
  
        //file.BodyLength=file.size();
        system.assertEquals(pf,null);
        pf=con.selectDocument();
        //pf=con.upload();
        //con.getDocuments();
        // Integer i=PBS_ePM_FileManagerController.convertHexCharToNum('1');
        //PBS_ePM_FileManagerController.charCodeAt('1',1);
   
        DOM.Document doc = new DOM.Document();
        
        String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
        String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
        String serviceNS = 'http://www.myservice.com/services/MyService/';
        
        dom.XmlNode envelope
        = doc.createRootElement('Envelope', soapNS, 'soapenv');
        envelope.setNamespace('xsi', xsi);
        envelope.setAttributeNS('schemaLocation', soapNS, xsi, null);
        
        dom.XmlNode body
        = envelope.addChildElement('Body', soapNS, null);
        
        body.addChildElement('echo', serviceNS, 'req').
        addChildElement('category', serviceNS, null).
        addTextNode('classifieds');
        
        System.debug(doc.toXmlString());
        
        // Send the request 
    
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        // req.setEndpoint(endpoint);
        req.setHeader('Content-Type', 'text/xml');
        
        req.setBodyDocument(doc);
        
        PBS_ePM_FileManagerController.EpmProject e = new PBS_ePM_FileManagerController.EpmProject(body); 
   
        // PBS_ePM_FileManagerController.EpmDocument d= new    PBS_ePM_FileManagerController.EpmDocument(body);
        // PBS_ePM_FileManagerController.DocSubTypeTemplate dd= new  PBS_ePM_FileManagerController.DocSubTypeTemplate(body);
    }
}