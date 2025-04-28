public with sharing class PBS_ePM_FileManagerController
{
    public string epmFileManagerUrl { get { return 'https://epm.pbs.gsa.gov/filemanager/default.aspx'; } }
    private static final string POSTMethod = 'POST';
    private static final string SoapActionHeader = 'SOAPAction';
    private static final string ContentTypeHeader = 'Content-Type';
    private static final string XmlContentType = 'text/xml';
    public static final string defaultEPMUrl = 'https://epm.pbs.gsa.gov/proliance';
    public static final string paramNameUrl = 'url';
    public static final string paramNameOrg = 'org';
    public static final string paramNameProjectId = 'projectId';
    public static final string paramNameEpmAccountName = 'ean';
    public static final string paramNameEpmAccountNameForced = 'eanForced';
    public static final string paramNameNoAccessContactName = 'noAccessContactName';
    public static final string paramNameShowEpmFileManager = 'efm';
    public static final string paramNameEnsureTopLevelEpmFolders = 'tlf';
    public static final string paramNameFolder = 'folder';
    public static final string paramNameAllowChangeFolder = 'acf';
    public static final string paramNameTags = 'tags';
    public static final string paramNameDescription = 'desc';
    public static final string paramNameContextualTitle = 'ctitle';
    public static final string paramNameCatalog = 'cat';
    public static final string paramNameIntro = 'intro';
    public static final string paramNameDeveloperName = 'dn';
    public static final string paramNameDeveloperNameRandomFormat = 'dnrf';
    private static final string nsXmlSchemaInstance = 'http://www.w3.org/2001/XMLSchema-instance';
    private static final string prefixXmlSchemaInstance = 'xsi';
    private static final string nsSoap = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static final string nsEpmGatewayService = 'http://www.mps.com/Proliance/webservices/GatewayService';
    private static final string nsProliance = 'http://www.mps.com/Proliance/webservices';
    private static final string nsMsDiffgram = 'urn:schemas-microsoft-com:xml-diffgram-v1';
    private static final string siteConfigUri = 'webservices/gateway/documentdataservice.asmx';
    private static final string siteConfigAction = 'http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/GetSiteConfiguration';
    private static final string listProjectsUri = 'WebServices/Platform/ProjectSystem/Org/OrgProjectService.asmx';
    private static final string listProjectsAction = 'http://www.mps.com/Proliance/webservices/ListAccessibleOrgProjects';
    private static final string listDocumentsUri = 'webservices/gateway/documentdataservice.asmx';
    private static final string listDocumentsAction = 'http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/ListDocumentDataSet';
    private static final string getDocSubTypesUri = 'WebServices/Platform/Core/Template/TemplateService.asmx';
    private static final string getDocSubTypesAction = 'http://www.mps.com/Proliance/webservices/GetDocSubTypeNamesByType';
    private static final string getLookupItemsUri = 'webservices/platform/core/lookup/LookupService.asmx';
    private static final string getLookupItemsAction = 'http://www.mps.com/Proliance/webservices/GetLookupVersionBySystemType';
    private static final string saveLookupVersionAction = 'http://www.mps.com/Proliance/webservices/SaveLookupVersion';
    private static final string saveLookupVersionUri = 'webservices/platform/core/lookup/LookupService.asmx';
    private static final string createDocumentUri = 'webservices/gateway/documentdataservice.asmx';
    private static final string createDocumentAction = 'http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/CreateDocument';
    private static final string saveDocumentUri = 'webservices/gateway/documentdataservice.asmx';
    private static final string saveDocumentAction = 'http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/SaveDocument';
    private static final string beginUploadChunkUri = 'webservices/gateway/documentdataservice.asmx';
    private static final string beginUploadChunkAction = 'http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/BeginUploadChunk';
    private static final string uploadFileChunkUri = 'webservices/gateway/documentdataservice.asmx';
    private static final string uploadFileChunkAction = 'http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/UploadFileChunk';
    private static final string attachBinaryAttachmentUri = 'webservices/gateway/documentdataservice.asmx';
    private static final string attachBinaryAttachmentAction = 'http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/AttachBinaryAttachmentChunk';


    private getLookupItemsResult folderLookupResult;
    private string ePMUrl { get; set; }
    public string username { get; set; }
    public string password { get; set; }
    public string org { get; set; }
    public string intro { get; private set; }    
    public string noAccessContactName { get; private set; }    
    private string developerName { get; set; }
    private string developerNameRandomFormat { get; set; }
    public boolean orgDisabled { get; set; }
    public boolean loginMode { get; private set; }
    public boolean projectsMode { get; private set; }
    public boolean treeMode { get; private set; }
    public boolean uploadedMode { get; private set; }
    public boolean showEpmFileManager { get; private set; }
    public integer maxPageSize { get; private set; }
    public integer maxUploadDownloadFileChunkLength { get; private set; }
    public string prolianceVersion { get; private set; }
    public transient List<EpmProject> epmProjects { get; private set; }
    public List<EpmDocument> epmDocuments { get; private set; }
    public List<DocSubTypeTemplate> docSubTypes { get; private set; }
    public List<SelectOption> documentAreas { get; private set; }
    public string documentAreaGuid {get; set; }
    public boolean documentAreaDisabled { get; private set; }
    public string actionId { get; set; }
    public string epmAccountName { get; private set; }
    private boolean epmAccountNameForced { get; set; }
    public Document file { get; set; }
    public string subtitle { get; private set; }
    private string defaultCatalogName { get; set; }
    private string defaultFolderName { get; set; }
    public string folderName { get; set; }
    private boolean ensureTopLevelEpmFolders { get; set; }
    public boolean allowChangeFolder { get; private set; }
    public string attachmentGuid { get; private set; }
    public string sessionGuid { get; private set; }
    public string documentGuid { get; set; }
    public string seriesGuid { get; private set; }
    public string tags { get; set; }
    private string defaultTags { get; set; }
    private static final List<FolderLookupItemConfig> epmTopLevelFolderConfigs;

    static
    {
        epmTopLevelFolderConfigs = new List<FolderLookupItemConfig>();
        epmTopLevelFolderConfigs.add(new FolderLookupItemConfig('Design Document', 'MPS.Prolog.Business.Packages.DrawingService.Documents.DrawingDocument', 1));
        epmTopLevelFolderConfigs.add(new FolderLookupItemConfig('Submittal', 'MPS.Prolog.Business.Packages.SubmittalService.Documents.SubmittalDocument', 2));
        epmTopLevelFolderConfigs.add(new FolderLookupItemConfig('1.0 Initiation', 'MPS.Prolog.Shared.FileManagement.Documents.CatalogCard', 3));
        epmTopLevelFolderConfigs.add(new FolderLookupItemConfig('2.0 Planning', 'MPS.Prolog.Shared.FileManagement.Documents.CatalogCard', 4));
        epmTopLevelFolderConfigs.add(new FolderLookupItemConfig('2.1 CILP', 'MPS.Prolog.Shared.FileManagement.Documents.CatalogCard', 5));
        epmTopLevelFolderConfigs.add(new FolderLookupItemConfig('3.0 Execution', 'MPS.Prolog.Shared.FileManagement.Documents.CatalogCard', 6));
        epmTopLevelFolderConfigs.add(new FolderLookupItemConfig('3.1 Photos', 'MPS.Prolog.Shared.FileManagement.Documents.CatalogCard', 7));
        epmTopLevelFolderConfigs.add(new FolderLookupItemConfig('4.0 Close-out', 'MPS.Prolog.Shared.FileManagement.Documents.CatalogCard', 8));
    }

    public PBS_ePM_FileManagerController()
    {
        try
        {
            doTopLevelEpmFoldersCalled = false;
            Map<string, string> p = ApexPages.currentPage().getParameters();
            subtitle = p.get(paramNameContextualTitle);
            epmAccountName = p.get(paramNameEpmAccountName);            
            epmAccountNameForced = PBS_gBUILD_Utility.parseBool(p.get(paramNameEpmAccountNameForced), false);
            showEpmFileManager = PBS_gBUILD_Utility.parseBool(p.get(paramNameShowEpmFileManager), true);
            defaultCatalogName = p.get(paramNameCatalog);
            defaultFolderName = p.get(paramNameFolder);
            allowChangeFolder = PBS_gBUILD_Utility.parseBool(p.get(paramNameAllowChangeFolder), true);
            ensureTopLevelEpmFolders = PBS_gBUILD_Utility.parseBool(p.get(paramNameEnsureTopLevelEpmFolders), true);
            org =  p.get(paramNameOrg);
            orgDisabled = org!=null && org!='';            
            noAccessContactName = p.get(paramNameNoAccessContactName);                        
            developerName = p.get(paramNameDeveloperName);
            developerNameRandomFormat = p.get(paramNameDeveloperNameRandomFormat);
            intro = p.get(paramNameIntro);
            ePMUrl = p.get(paramNameUrl);
            defaultTags = p.get(paramNameTags);
            if (ePMUrl==null || ePMUrl=='') ePMUrl = defaultEPMUrl;
            reset();
            modesOff();
            loginMode = true;

            PBS_gBUILD_Utility.showDebugMessage(string.Format('epmAccountName: {0} forced={1}', new string[]{epmAccountName, epmAccountNameForced?'t':'f'}));
            PBS_gBUILD_Utility.showDebugMessage(string.Format('noAccessContactName: {0}', new string[]{noAccessContactName}));
            PBS_gBUILD_Utility.showDebugMessage('ePM URL: '+ePMUrl);
            PBS_gBUILD_Utility.showDebugMessage('folderId: '+PBS_gBUILD_Utility.ProjectDocsFolderId);
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);                
        }
    }

    private void modesOff()
    {
        loginMode = false;
        projectsMode = false;
        treeMode = false;        
        uploadedMode = false;
    }

    private void reset()
    {
        Map<string, string> p = ApexPages.currentPage().getParameters();
        file = new Document();
        file.description = p.get(paramNameDescription);
        attachmentGuid = null;
        sessionGuid = null;
        documentGuid = null;
        seriesGuid = null;
        tags = defaultTags;
        folderName = defaultFolderName;
    }

    public PageReference logout()
    {
        username = null;
        password = null;
        modesOff();
        loginMode = true;    
        return null;
    }

    public PageReference selectProject()
    {
        try
        {
            PBS_gBUILD_Utility.showDebugMessage('selected project: '+actionId);
            epmAccountName = actionId;
            modesOff();
            treeMode = true;
            epmProjects = null;
            getDocuments();            
        }
        catch (SoapFaultException sfex)
        {
            showSoapFaultExceptionMessage(sfex);
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);
        }
        return null;
    }

    public PageReference selectDocument()
    {
        modesOff();
        return null;
    }

    public PageReference uploadAgain()
    {
        reset();
        actionId = epmAccountName;
        return selectProject();
    }

    public string createUrl(string docGuid)
    {
        /*
        pgmprj://pbs/r11pgm/dcwashingtondhsnocosttp
        https://epm.pbs.gsa.gov/Proliance/WebUI/platform/filemanagement/common/FileDownloadWindow.aspx?prj=dcwashingtondhsnocosttp&pgm=r11pgm&o=pbs&FileID=20c1a60f-8a9b-480b-a169-f86e2f82c9e9             
        https://epm.pbs.gsa.gov/Proliance/WebUI/Popup/DocWindow.aspx?prj=dcwashingtondhsnocosttp&pgm=r11pgm&man=&o=pbs&csoc=True&InitialMode=1&InitialActionTypeOverride=&DocGuid=e511b378-17a5-479d-ab1b-962b13af7bcb&DocTitle=&DocVisualId=&NoticeID=0&NoticeType=0&ParentGuid=&ParentDocTitle=&SubTypeGuid=&InitialTargetState=&DocType=&IsNoticeOutOfDate=False&IsToCloneDoc=False&InnerPage=/Proliance/WebUI/platform/filemanagement/project/CatalogCardGeneral.aspx
        https://epm.pbs.gsa.gov/Proliance/WebUI/Popup/DocWindow.aspx?prj=dcwashingtondhsnocosttp&pgm=r11pgm&o=pbs&DocGuid=e511b378-17a5-479d-ab1b-962b13af7bcb&InnerPage=/Proliance/WebUI/platform/filemanagement/project/CatalogCardGeneral.aspx
        https://epm.pbs.gsa.gov/Proliance/WebUI/Popup/DocWindow.aspx?prj=dcwashingtondhsnocosttp&pgm=r11pgm&man=&o=pbs&DocGuid=e511b378-17a5-479d-ab1b-962b13af7bcb
            */

        List<string> epmAccountParts = epmAccountName.split('/');
        Integer epmAccountPartCount = epmAccountParts.size();
        string epmAccountOrg = epmAccountParts[epmAccountPartCount-3];
        string epmAccountProgram = epmAccountParts[epmAccountPartCount-2];
        string epmAccountProject= epmAccountParts[epmAccountPartCount-1];
        return string.format(
            '{0}/WebUI/Popup/DocWindow.aspx?prj={1}&pgm={2}&o={3}&DocGuid={4}&InnerPage=/Proliance/WebUI/platform/filemanagement/project/CatalogCardGeneral.aspx',
            new string[]{defaultEPMUrl, epmAccountProject, epmAccountProgram, epmAccountOrg, docGuid});    
    }
    
    public PageReference upload()
    {
        try
        {
            List<string> parts;
            Integer partCount;

            Map<string, string> p = ApexPages.currentPage().getParameters();
            if (file.body!=null && file.BodyLength>0)
            {
                Integer fileSize = file.BodyLength;

                PBS_gBUILD_Utility.showDebugMessage('vvvvvvvvvvv');
                PBS_gBUILD_Utility.showDebugMessage('file.name');
                try{
                PBS_gBUILD_Utility.showDebugMessage(file.name);
                } catch (exception ex){PBS_gBUILD_Utility.showDebugMessage(ex);}
                PBS_gBUILD_Utility.showDebugMessage('file.contenttype');
                try{
                PBS_gBUILD_Utility.showDebugMessage(file.contenttype);
                } catch (exception ex){PBS_gBUILD_Utility.showDebugMessage(ex);}
                PBS_gBUILD_Utility.showDebugMessage('fileSize.format()');
                try{
                PBS_gBUILD_Utility.showDebugMessage(fileSize.format());
                } catch (exception ex){PBS_gBUILD_Utility.showDebugMessage(ex);}
                PBS_gBUILD_Utility.showDebugMessage('^^^^^^^^^^^');


                PBS_gBUILD_Utility.showDebugMessage('File name:['+file.name+'] size:'+fileSize.format());

              
                string documentTypeName = null;
                for (DocSubTypeTemplate dst : docSubTypes)
                {
                    if (dst.guid==documentAreaGuid)
                    {
                        documentTypeName = dst.documentTypeName;
                        break;
                    }
                }

                PBS_gBUILD_Utility.showDebugMessage('documentAreaGuid=['+documentAreaGuid+'] documentTypeName=['+documentTypeName+']');

                string folderFullCode = null;
                if (folderName!=null && folderName!='')
                {
                    for (SelectOption so : documentAreas)
                    {
                        if (so.getValue()==documentAreaGuid)
                        {
                            folderFullCode = so.getLabel();
                            break;
                        }
                    }
                    folderFullCode = folderFullCode + '/' + folderName;
                    FolderLookupItemConfig lookupConfig = new FolderLookupItemConfig(folderFullCode, 'MPS.Prolog.Shared.FileManagement.Documents.CatalogCard', 0);
                    List<FolderLookupItemConfig> lookupConfigs = new List<FolderLookupItemConfig>();
                    lookupConfigs.add(lookupConfig);
                    conditionallyAddFolderLookupConfigs(lookupConfigs);
                }

                string message = createSoapMessage(createDocumentUri, createDocumentAction, 
        '    <DocumentTypeName xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+documentTypeName+'</DocumentTypeName>'+
        '    <DocumentSubTypeGuid xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+documentAreaGuid+'</DocumentSubTypeGuid>'+
        '    <ParentDocumentGuid xmlns="http://www.mps.com/Proliance/webservices/GatewayService" />'+
        '    <SkipMetadataElement xmlns="http://www.mps.com/Proliance/webservices/GatewayService">true</SkipMetadataElement>');
                dom.XmlNode root = getSoapResponseRootNode(createDocumentUri, createDocumentAction, message);    
                seriesGuid = PBS_gBUILD_Utility.findNode(root, 'SeriesGUID').getText();

                PBS_gBUILD_Utility.showDebugMessage('seriesGuid='+seriesGuid);

                dom.XmlNode el = PBS_gBUILD_Utility.findNode(root, 'DocumentData');
                string xml = '';
                for (dom.XmlNode z : el.getChildElements())
                {
                    xml += string.format('<{0} xmlns="{1}">{2}</{0}>\n', new string[]{z.getName(), el.getNamespace(), z.getText()});
                }
                xml += string.format('<SeriesIdentifier>{0}</SeriesIdentifier><IsAutoPopulateTitle>1</IsAutoPopulateTitle>', new string[]{file.name});

                if (folderFullCode!=null)
                {
PBS_gBUILD_Utility.showDebugMessage(string.format('folderFullCode=[{0}] folderLookupResult?{1}', new string[]{folderFullCode, folderLookupResult==null?'0':'1'}));
                    LookupItem folderLookupItem = folderLookupResult.lookupItemByFullCode.get(folderFullCode);
                    xml += string.format(
                        '<DocUDFLookup2_Code>{0}</DocUDFLookup2_Code>'+
                        '<DocUDFLookup2_FullCode>{1}</DocUDFLookup2_FullCode>'+
                        '<DocUDFLookup2_Level>{2}</DocUDFLookup2_Level>',
                        new string[] {folderLookupItem.code, folderLookupItem.fullCode, string.valueOf(folderLookupItem.level)});
                }

                message = createSoapMessage(saveDocumentUri, saveDocumentAction, 
        '    <SaveDocumentArgument xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+
        '      <ProlianceDocument xmlns="http://www.MeridianSystems.com/Schemas/Proliance/2004/09/Platform/Business/Document">'+
        '        <DocumentData xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" State="Added" xmlns="http://www.MeridianSystems.com/Schemas/Proliance/2004/09/Platform/FileManagementService/CatalogCard">'+
        xml+
        '        </DocumentData>'+
        '      </ProlianceDocument>'+
        '    </SaveDocumentArgument>'+
        '    <SkipMetadataElement xmlns="http://www.mps.com/Proliance/webservices/GatewayService">true</SkipMetadataElement>');
                root = getSoapResponseRootNode(saveDocumentUri, saveDocumentAction, message);    
                documentGuid = PBS_gBUILD_Utility.findNode(root, 'LatestRevision_DocumentGuid').getText();
                PBS_gBUILD_Utility.showDebugMessage('documentGuid='+documentGuid);

                message = createSoapMessage(beginUploadChunkUri, beginUploadChunkAction, 
        '    <TotalFileSize xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+string.valueOf(fileSize)+'</TotalFileSize>'+
        '    <Attachment xmlns="http://www.mps.com/Proliance/webservices/GatewayService" />'+
        '    <Index xmlns="http://www.mps.com/Proliance/webservices/GatewayService">0</Index>'
        );
                root = getSoapResponseRootNode(beginUploadChunkUri, beginUploadChunkAction, message);    
                sessionGuid = PBS_gBUILD_Utility.findNode(root, 'SessionGUID').getText();
                PBS_gBUILD_Utility.showDebugMessage('sessionGuid='+sessionGuid);

                string file64 = EncodingUtil.base64Encode(file.Body);
                Integer z;
                for (z=0;z<fileSize;z+=maxUploadDownloadFileChunkLength)
                {
                    integer chunkSize = Math.min(maxUploadDownloadFileChunkLength, fileSize-z);
                    PBS_gBUILD_Utility.showDebugMessage('chunk start='+z.format()+' size='+chunkSize.format());
                    string chunk64 = file64.substring(z*4,Math.min(z*4+chunkSize*4,file64.length()));
                    message = createSoapMessage(uploadFileChunkUri, uploadFileChunkAction, 
    '    <SessionGUID xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+sessionGuid+'</SessionGUID>'+
    '    <Attachment xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+chunk64+'</Attachment>'+
    '    <Index xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+string.valueOf(z)+'</Index>'
                    );
                    root = getSoapResponseRootNode(uploadFileChunkUri, uploadFileChunkAction, message);    
                }

                message = createSoapMessage(attachBinaryAttachmentUri, attachBinaryAttachmentAction, 
    '    <DocumentGUID xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+documentGuid+'</DocumentGUID>'+
    '    <AttachmentName xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+file.name+'</AttachmentName>'+
    '    <AttachmentType xmlns="http://www.mps.com/Proliance/webservices/GatewayService">SourceFile</AttachmentType>'+
    '    <SessionGUID xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+sessionGuid+'</SessionGUID>'
                );
                root = getSoapResponseRootNode(attachBinaryAttachmentUri, attachBinaryAttachmentAction, message);    
                attachmentGuid = PBS_gBUILD_Utility.findNode(root, 'AttachmentGUID').getText();
                PBS_gBUILD_Utility.showDebugMessage('attachmentGuid='+attachmentGuid);
            }
            else if (documentGuid!=null && documentGuid.trim().length()>4)
            {
                documentGuid = documentGuid.trim();
                PBS_gBUILD_Utility.showDebugMessage(string.Format('selectedDocument: [{0}] len={1}', new string[]{documentGuid, documentGuid.length().format()}));
                for (EpmDocument d : epmDocuments)
                {
                    if (d.documentGuid==documentGuid)
                    {
                        file.name = d.documentTitle.substringBeforeLast('-').trim();
                        break;
                    }                
                }
            }
            else 
            {
                PBS_gBUILD_Utility.showWarningMessage('You did not select an existing file AND you did not select a file from your desktop.  Please try again.');
                return null;
            }

            //store the document
            if (developerName!=null && developerName.length()>0)
            {
                file.DeveloperName = developerName;
                if (developerNameRandomFormat!=null && developerNameRandomFormat!='')
                {
                    string rnd = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0,8);
                    file.DeveloperName = string.Format(developerNameRandomFormat, new string[]{file.DeveloperName, rnd});
                }
            }
/*
            file.Url = createUrl(documentGuid);
            file.Type = file.name.substringAfterLast('.');
            file.contenttype = 'text/html';
            file.body = null;
            file.BodyLength = 0;
            file.AuthorId = UserInfo.getUserId();
            file.FolderId = PBS_gBUILD_Utility.ProjectDocsFolderId;
*/
            file = new Document(
                DeveloperName = file.DeveloperName,
                Description  = file.Description,
                Url = createUrl(documentGuid),
                Name = file.name,
                Type = file.name.substringAfterLast('.'),
                Contenttype = 'text/html',
                AuthorId = UserInfo.getUserId(),
                FolderId = PBS_gBUILD_Utility.ProjectDocsFolderId
            );
            PBS_gBUILD_Utility.showDebugMessage(string.Format(
                'file: name=[{0}] url=[{1}] folderId=[{2}] developerName=[{3}] contentType=[{4}] type=[{5}]',
                new string[]{file.name, file.url, file.FolderId, file.DeveloperName, file.contenttype, file.type}));
            insert file;

            modesOff();
            uploadedMode = true;
        }
        catch (SoapFaultException sfex)
        {
            showSoapFaultExceptionMessage(sfex);
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);
        }
        file = new Document();
        return null;
    }

    private HttpRequest createSoapRequest(string uri, string action, string body)
    {
        HttpRequest req = new HttpRequest();
        req.setTimeout(integer.valueOf(PBS_gBUILD_Utility.AppConfig.EpmFileManagerRequestTimeout__c*1000));
        string ep = ePMUrl+'/'+uri;
//        ep += '?wsdl';
        req.setEndpoint(ep);
//        PBS_gBUILD_Utility.showDebugMessage('CreateSoapRequest url:['+ep+'] body:['+body+']');
  //      req.setMethod('GET');
        req.setMethod(POSTMethod);
        req.setHeader(SoapActionHeader, action);
        req.setHeader(ContentTypeHeader,XmlContentType);
        req.setBody(body);
        return req;    
    }

    private string DbgSetNextResponse = null;
    private dom.XmlNode getSoapResponseRootNode(string uri, string action, string body)
    {
        PBS_gBUILD_Utility.showDebugMessage(string.format('HTTP({1}).OUTBOUND: [{2}]', new string[]{uri, action, body}));
        HttpRequest req = createSoapRequest(uri, action, body);
        Http http = new Http();
        string xml;
        if (DbgSetNextResponse==null)
        {
            HTTPResponse res = http.send(req);
            xml = res.getBody();
        }
        else
        {
            xml = DbgSetNextResponse;
            DbgSetNextResponse = null;
        }
        PBS_gBUILD_Utility.showDebugMessage(string.format('HTTP({1}).INBOUND: [{2}]', new string[]{uri, action, xml}));
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        dom.XmlNode el = doc.getRootElement(); 
        string faultMessage= 'There was a problem with the action: '+action.substringAfterLast('/');
        validateNoFault(el, faultMessage);   
        return el;
    }

    private static string formatAsIso8601(Datetime dt)
    {
        return dt.format('yyyy-MM-dd') + 'T' + dt.format('HH:mm:ss') + 'Z';
    }

    private static blob computePasswordDigest(string nonceHex, DateTime created, string password)
    {
        blob bPassword = Blob.valueOf(password);
        string secret = EncodingUtil.base64encode(Crypto.generateDigest('SHA1', bPassword));

        blob bCreated = Blob.valueOf(formatAsIso8601(created));
        blob bSecret = Blob.valueOf(secret);
        blob bNonce = EncodingUtil.base64Decode(PBS_gBUILD_Utility.convertHexString2Base64String(nonceHex));

        string hex =             
            EncodingUtil.convertToHex(bNonce) + 
            EncodingUtil.convertToHex(bCreated) + 
            EncodingUtil.convertToHex(bSecret);

        string b64 = PBS_gBUILD_Utility.convertHexString2Base64String(hex);

        blob big = EncodingUtil.base64Decode(b64);

        return Crypto.generateDigest('SHA1', big);        
    }

    private class soapHeaderData
    {
        public DateTime now { get; private set; }
        public string createdAt { get; private set; }
        public string expiresAt { get; private set; }
        public string nonce { get; private set; }
        public string nonceBase64 { get; private set; }
        public blob passwordDigest { get; private set; }
        public string passwordDigest64 { get; private set; }

        public soapHeaderData(string password)
        {
            this.now = datetime.now().addMinutes(integer.valueOf(PBS_gBUILD_Utility.AppConfig.EpmFileManagerClockTimeDelta__c));
            this.createdAt = formatAsIso8601(now);
            this.expiresAt = formatAsIso8601(now.addHours(6));
            this.nonce = PBS_gBUILD_Utility.createRandomHexString(16);
            this.nonceBase64 = PBS_gBUILD_Utility.convertHexString2Base64String(nonce);        
            PBS_gBUILD_Utility.showDebugMessage('soapHeaderData now=['+now.format()+'] createdAt==['+createdAt+'] expiresAt==['+expiresAt+'] nonce==['+nonce+'] nonceBase64==['+nonceBase64+']');
            passwordDigest = computePasswordDigest(nonce, now, password);
            passwordDigest64 = EncodingUtil.base64Encode(passwordDigest);
        }
    }

    private void getSiteConfiguration()
    {
        soapHeaderData shd = new soapHeaderData(password);

        string body = string.Format(
            '<?xml version="1.0" encoding="utf-8"?>'+
        '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
        '<soap:Header><wsa:Action>http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/GetSiteConfiguration</wsa:Action>'+
        '<wsa:MessageID>uuid:{0}</wsa:MessageID>'+
        '<wsa:ReplyTo><wsa:Address>http://schemas.xmlsoap.org/ws/2004/03/addressing/role/anonymous</wsa:Address></wsa:ReplyTo>'+
        '<wsa:To>{1}/webservices/gateway/documentdataservice.asmx</wsa:To>'+
        '<MPS:ToAccount xmlns:MPS="http://www.mps.com/Proliance/webservices">org://pbs</MPS:ToAccount>'+
        '<wsse:Security soap:mustUnderstand="1"><wsu:Timestamp wsu:Id="Timestamp-{2}">'+
        '<wsu:Created>{3}</wsu:Created><wsu:Expires>{4}</wsu:Expires></wsu:Timestamp>'+
        '<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="SecurityToken-{5}">'+
        '<wsse:Username>usr://{6}/{7}</wsse:Username>'+
        '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">{9}</wsse:Password>'+
        '<wsse:Nonce>{8}</wsse:Nonce><wsu:Created>{3}</wsu:Created></wsse:UsernameToken></wsse:Security></soap:Header><soap:Body /></soap:Envelope>',
            new string[]{
                PBS_gBUILD_Utility.createGuid(), 
                ePMUrl, 
                PBS_gBUILD_Utility.createGuid(), 
                shd.createdAt, 
                shd.expiresAt, 
                PBS_gBUILD_Utility.createGuid(), 
                org, 
                username, 
                shd.nonceBase64, 
                shd.passwordDigest64});

        dom.XmlNode el = getSoapResponseRootNode(siteConfigUri, siteConfigAction, body);
        el = el.getChildElement('Body', nsSoap).getChildElement('GetSiteConfigurationResult', nsEpmGatewayService);
        prolianceVersion = el.getChildElement('ProlianceVersion', nsEpmGatewayService).getText();
        maxPageSize = integer.ValueOf(el.getChildElement('MaxPageSize', nsEpmGatewayService).getText());
        maxUploadDownloadFileChunkLength = integer.ValueOf(el.getChildElement('MaxUploadDownloadFileChunkLength', nsEpmGatewayService).getText());
        PBS_gBUILD_Utility.showDebugMessage('GetSiteConfigurationResult prolianceVersion='+prolianceVersion+' maxPageSize='+maxPageSize.format()+' maxUploadDownloadFileChunkLength='+maxUploadDownloadFileChunkLength.format());
    }

    private void getProjects()
    {
        soapHeaderData shd = new soapHeaderData(password);

        string body = 
'<?xml version="1.0" encoding="utf-8"?>'+
'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
'  <soap:Header>'+
'    <wsa:Action>http://www.mps.com/Proliance/webservices/ListAccessibleOrgProjects</wsa:Action>'+
'    <wsa:MessageID>uuid:{0}</wsa:MessageID>'+
'    <wsa:ReplyTo>'+
'      <wsa:Address>http://schemas.xmlsoap.org/ws/2004/03/addressing/role/anonymous</wsa:Address>'+
'    </wsa:ReplyTo>'+
'    <wsa:To>{1}/WebServices/Platform/ProjectSystem/Org/OrgProjectService.asmx</wsa:To>'+
'    <MPS:ToAccount xmlns:MPS="http://www.mps.com/Proliance/webservices">org://pbs</MPS:ToAccount>'+
'    <wsse:Security soap:mustUnderstand="1">'+
'      <wsu:Timestamp wsu:Id="Timestamp-{2}">'+
'        <wsu:Created>{3}</wsu:Created>'+
'        <wsu:Expires>{4}</wsu:Expires>'+
'      </wsu:Timestamp>'+
'      <wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="SecurityToken-{5}">'+
'        <wsse:Username>usr://{6}/{7}</wsse:Username>'+
'        <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">{9}</wsse:Password>'+
'        <wsse:Nonce>{8}</wsse:Nonce>'+
'        <wsu:Created>{3}</wsu:Created>'+
'      </wsse:UsernameToken>'+
'    </wsse:Security>'+
'  </soap:Header>'+
'  <soap:Body>'+
'    <ListAccessibleOrgProjects xmlns="http://www.mps.com/Proliance/webservices">'+
'      <thePageInfo>'+
'        <TotalEntries>0</TotalEntries>'+
'        <PageSize>0</PageSize>'+
'        <PageDirection>Forward</PageDirection>'+
'        <RestrictSelectFieldsForGrouping>false</RestrictSelectFieldsForGrouping>'+
'        <PagedOrderFields>'+
'          <Reverse>false</Reverse>'+
'        </PagedOrderFields>'+
'        <SelectFields>'+
'          <OutputField>'+
'            <Name>OrgProjectDocument.DocVisualID</Name>'+
'            <Type>DataField</Type>'+
'            <GroupAttribute>None</GroupAttribute>'+
'          </OutputField>'+
'          <OutputField>'+
'            <Name>OrgProjectDocument.DocTitle</Name>'+
'            <Type>DataField</Type>'+
'            <GroupAttribute>None</GroupAttribute>'+
'          </OutputField>'+
'          <OutputField>'+
'            <Name>OrgProjectDocument.ProjectAccountName</Name>'+
'            <Type>DataField</Type>'+
'            <GroupAttribute>None</GroupAttribute>'+
'          </OutputField>'+
'          <OutputField>'+
'            <Name>OrgProjectDocument.DocTitle</Name>'+
'            <Type>DataField</Type>'+
'            <GroupAttribute>None</GroupAttribute>'+
'          </OutputField>'+
'          <OutputField>'+
'            <Name>OrgProjectDocument.IsTemplate</Name>'+
'            <Type>DataField</Type>'+
'            <GroupAttribute>None</GroupAttribute>'+
'          </OutputField>'+
'          <OutputField>'+
'            <Name>OrgProjectDocument.DocumentProcessState</Name>'+
'            <Type>DataField</Type>'+
'            <GroupAttribute>None</GroupAttribute>'+
'          </OutputField>'+
'        </SelectFields>'+
'        <Filters>'+
'          <EmptyIsNull>false</EmptyIsNull>'+
'          <IgnoreCase>false</IgnoreCase>'+
'        </Filters>'+
'        <IsDistinct>false</IsDistinct>'+
'      </thePageInfo>'+
'      <isGetTotalCount>true</isGetTotalCount>'+
'    </ListAccessibleOrgProjects>'+
'  </soap:Body>'+
'</soap:Envelope>';

        body = string.Format(body, new string[]{
                PBS_gBUILD_Utility.createGuid(), 
                ePMUrl, 
                PBS_gBUILD_Utility.createGuid(), 
                shd.createdAt, 
                shd.expiresAt, 
                PBS_gBUILD_Utility.createGuid(), 
                org, 
                username, 
                shd.nonceBase64, 
                shd.passwordDigest64});

        dom.XmlNode el = getSoapResponseRootNode(listProjectsUri, listProjectsAction, body);
        epmProjects = new List<EpmProject>();
        try
        {
            el = el.getChildElement('Body', nsSoap).getChildElement('ListAccessibleOrgProjectsResponse', nsProliance).getChildElement('ListAccessibleOrgProjectsResult', nsProliance).getChildElement('List', nsProliance).getChildElement('diffgram', nsMsDiffgram).getChildElement('NewDataSet', '');
            for (dom.XmlNode p : el.getChildElements())
            {
                epmProjects.add(new EpmProject(p));
            }
        }
        catch (SoapFaultException sfex)
        {
            showSoapFaultExceptionMessage(sfex);
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);
        }
    }

    public void getDocuments()
    {
        getFolders();

        soapHeaderData shd = new soapHeaderData(password);

        string body = 
'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
'  <soap:Header>'+
'    <wsa:Action>http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/ListDocumentDataSet</wsa:Action>'+
'    <wsa:MessageID>uuid:{0}</wsa:MessageID>'+
'    <wsa:ReplyTo>'+
'      <wsa:Address>http://schemas.xmlsoap.org/ws/2004/03/addressing/role/anonymous</wsa:Address>'+
'    </wsa:ReplyTo>'+
'    <wsa:To>{1}/webservices/gateway/documentdataservice.asmx</wsa:To>'+
'    <MPS:ToAccount xmlns:MPS="http://www.mps.com/Proliance/webservices">{10}</MPS:ToAccount>'+
'    <wsse:Security soap:mustUnderstand="1">'+
'      <wsu:Timestamp wsu:Id="Timestamp-{2}">'+
'        <wsu:Created>{3}</wsu:Created>'+
'        <wsu:Expires>{4}</wsu:Expires>'+
'      </wsu:Timestamp>'+
'      <wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="SecurityToken-{5}">'+
'        <wsse:Username>usr://{6}/{7}</wsse:Username>'+
'        <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">{9}</wsse:Password>'+
'        <wsse:Nonce>{8}</wsse:Nonce>'+
'        <wsu:Created>{3}</wsu:Created>'+
'      </wsse:UsernameToken>'+
'    </wsse:Security>'+
'  </soap:Header>'+
'  <soap:Body>'+
'    <DocumentTypeName xmlns="http://www.mps.com/Proliance/webservices/GatewayService">MPS.Prolog.Shared.FileManagement.Documents.CatalogCard</DocumentTypeName>'+
'    <PageInfo xmlns="http://www.mps.com/Proliance/webservices/GatewayService">'+
'      <TotalEntries>0</TotalEntries>'+
'      <PageSize>5000</PageSize>'+
'      <PageDirection>Forward</PageDirection>'+
'      <RestrictSelectFieldsForGrouping>false</RestrictSelectFieldsForGrouping>'+
'      <PagedOrderFields>'+
'        <Reverse>false</Reverse>'+
'        <OrderField>'+
'          <Name>CatalogCard_DocVisualID</Name>'+
'          <Type>DataField</Type>'+
'          <Attribute>Ascending</Attribute>'+
'        </OrderField>'+
'      </PagedOrderFields>'+
'      <SelectFields>'+
'        <OutputField>'+
'          <Name>CatalogCard_DocumentGuid</Name>'+
'          <Type>DataField</Type>'+
'          <GroupAttribute>None</GroupAttribute>'+
'        </OutputField>'+
'        <OutputField>'+
'          <Name>CatalogCard_DocTitle</Name>'+
'          <Type>DataField</Type>'+
'          <GroupAttribute>None</GroupAttribute>'+
'        </OutputField>'+
'        <OutputField>'+
'          <Name>CatalogCard_DocUDFLookup2_FullCode</Name>'+
'          <Type>DataField</Type>'+
'          <GroupAttribute>None</GroupAttribute>'+
'        </OutputField>'+
'        <OutputField>'+
'          <Name>CatalogCard_DocumentProcessState</Name>'+
'          <Type>DataField</Type>'+
'          <GroupAttribute>None</GroupAttribute>'+
'        </OutputField>'+
'        <OutputField>'+
'          <Name>CatalogCard_DocVisualID</Name>'+
'          <Type>DataField</Type>'+
'          <GroupAttribute>None</GroupAttribute>'+
'        </OutputField>'+
'      </SelectFields>'+
'      <Filters>'+
'        <EmptyIsNull>false</EmptyIsNull>'+
'        <IgnoreCase>false</IgnoreCase>'+
'      </Filters>'+
'      <IsDistinct>false</IsDistinct>'+
'    </PageInfo>'+
'  </soap:Body>'+
'</soap:Envelope>';        

        body = string.Format(body, new string[]{
                PBS_gBUILD_Utility.createGuid(), 
                ePMUrl, 
                PBS_gBUILD_Utility.createGuid(), 
                shd.createdAt, 
                shd.expiresAt, 
                PBS_gBUILD_Utility.createGuid(), 
                org, 
                username, 
                shd.nonceBase64, 
                shd.passwordDigest64,
                epmAccountName});

        dom.XmlNode el = getSoapResponseRootNode(listDocumentsUri, listDocumentsAction, body);    
        el = el.getChildElement('Body', nsSoap).getChildElement('ListDocumentDataSetResult', nsEpmGatewayService).getChildElement('diffgram', nsMsDiffgram).getChildElement('NewDataSet', '');
        epmDocuments = new List<EpmDocument>();
        for (dom.XmlNode p : el.getChildElements())
        {
            epmDocuments.add(new EpmDocument(this, p));
        }
        file = new Document();

        getDocumentSubTypes();
    }

    private string createSoapMessage(string toFragment, string actionUrl, string soapBody)
    {
        soapHeaderData shd = new soapHeaderData(password);    
    
        string x = 
'<?xml version="1.0" encoding="utf-8"?>'+
'<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/03/addressing" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
'  <soap:Header>'+
'    <wsa:Action>{12}</wsa:Action>'+
'    <wsa:MessageID>uuid:{0}</wsa:MessageID>'+
'    <wsa:ReplyTo>'+
'      <wsa:Address>http://schemas.xmlsoap.org/ws/2004/03/addressing/role/anonymous</wsa:Address>'+
'    </wsa:ReplyTo>'+
'    <wsa:To>{1}/{11}</wsa:To>'+
'    <MPS:ToAccount xmlns:MPS="http://www.mps.com/Proliance/webservices">{10}</MPS:ToAccount>'+
'    <wsse:Security soap:mustUnderstand="1">'+
'      <wsu:Timestamp wsu:Id="Timestamp-{2}">'+
'        <wsu:Created>{3}</wsu:Created>'+
'        <wsu:Expires>{4}</wsu:Expires>'+
'      </wsu:Timestamp>'+
'      <wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="SecurityToken-{5}">'+
'        <wsse:Username>usr://{6}/{7}</wsse:Username>'+
'        <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">{9}</wsse:Password>'+
'        <wsse:Nonce>{8}</wsse:Nonce>'+
'        <wsu:Created>{3}</wsu:Created>'+
'      </wsse:UsernameToken>'+
'    </wsse:Security>'+
'  </soap:Header>'+
'  <soap:Body>'+
'{13}' +
'  </soap:Body>'+
'</soap:Envelope>';    
    
        x = string.Format(x, new string[]{
                PBS_gBUILD_Utility.createGuid(), 
                ePMUrl, 
                PBS_gBUILD_Utility.createGuid(), 
                shd.createdAt, 
                shd.expiresAt, 
                PBS_gBUILD_Utility.createGuid(), 
                org, 
                username, 
                shd.nonceBase64, 
                shd.passwordDigest64,
                epmAccountName,
                toFragment,
                actionUrl,
                soapBody});

        return x;
    }

    private void getDocumentSubTypes()
    {
        string message = createSoapMessage(getDocSubTypesUri, getDocSubTypesAction, 
'    <GetDocSubTypeNamesByType xmlns="http://www.mps.com/Proliance/webservices">'+
'      <documentTypeName>MPS.Prolog.Shared.FileManagement.Documents.CatalogCard</documentTypeName>'+
'      <isManaged>true</isManaged>'+
'    </GetDocSubTypeNamesByType>');
        dom.XmlNode el = getSoapResponseRootNode(getDocSubTypesUri, getDocSubTypesAction, message);    
        el = PBS_gBUILD_Utility.findNode(el, 'GetDocSubTypeNamesByTypeResult');
        docSubTypes = new List<DocSubTypeTemplate>();
        documentAreaGuid = '';
        documentAreaDisabled = false;
        documentAreas = new List<SelectOption>();
        for (dom.XmlNode p : el.getChildElements())
        {
            DocSubTypeTemplate st = new DocSubTypeTemplate(p);
            docSubTypes.add(st);
            documentAreas.add(new SelectOption(st.guid,st.name));
            if (st.name.equalsIgnoreCase(defaultCatalogName))
            {
                documentAreaGuid = st.guid;
                documentAreaDisabled = true;
            }
        }
    }

    private class EchoElement
    {
        public string elementName { get; private set; }
        public map<string, string> valByName { get; private set; }
        
        public void Write(XmlStreamWriter w, string state)
        {
            w.writeStartElement(null, elementName, null);
            if (state!=null)
            {
                w.writeAttribute(null, null, 'State', state);
            }
            for (string name : valByName.keySet())
            {
                string val = valByName.get(name);
                PBS_gBUILD_Utility.WriteFullElement(w,null,name,null, val);
            }
            w.writeEndElement(); //elementName
        }

        public EchoElement(dom.XmlNode n)
        {
            this.elementName = n.getName();
            this.valByName = new map<string, string>();
            for (dom.XmlNode c : n.getChildElements())
            {
                this.valByName.put(c.getName(), c.getText());
            }
        }
    }

    private class LookupItem implements Comparable
    {
        public string code { get; private set; }
        public string fullCode  { get; private set; }
        public string description  { get; private set; }
        public string lookupVersionGuid  { get; private set; }
        public string parentFullCode  { get; private set; }
        public integer sortValue { get; private set; }
        public integer level { get; private set; }
        public string typeName { get; private set; }
        public string id { get; private set; }
        public string recordVersion { get; private set; }
        public map<string, string> attrValByAttrName { get; private set; }

        public Integer compareTo(Object compareTo) 
        {
            LookupItem that = (LookupItem)compareTo;
            integer ret = this.level - that.level;
            if (ret==0)
            {
                ret = this.fullCode.compareTo(that.fullCode);
                if (ret==0 && level==0)
                {
                }
            }
            return ret;
        }
        
        private string get(dom.XmlNode el, string name)
        {
            el = el.getChildElement(name, el.getNamespace());
            if (el==null) return null;
            return el.getText();
        }

        public void Write(XmlStreamWriter w, string state)
        {
            w.writeStartElement(null, 'LookupItem', null);
            if (state!=null)
            {
                w.writeAttribute(null, null, 'State', state);
            }
            PBS_gBUILD_Utility.WriteFullElement(w,null,'Code',null, this.code);
            PBS_gBUILD_Utility.WriteFullElement(w,null,'Description',null, this.description);
            PBS_gBUILD_Utility.WriteFullElement(w,null,'SortValue',null, string.valueOf(this.sortValue));
            PBS_gBUILD_Utility.WriteFullElement(w,null,'TypeName',null, this.typeName);
            PBS_gBUILD_Utility.WriteFullElement(w,null,'Level',null, string.valueOf(this.level));            
            PBS_gBUILD_Utility.WriteFullElement(w,null,'ParentFullCode',null, this.parentFullCode);
            PBS_gBUILD_Utility.WriteFullElement(w,null,'FullCode',null, this.fullCode);
            if (this.id!=null) PBS_gBUILD_Utility.WriteFullElement(w,null,'ID',null, this.id);
            if (this.recordVersion!=null) PBS_gBUILD_Utility.WriteFullElement(w,null,'RecordVersion',null, this.recordVersion);
            PBS_gBUILD_Utility.WriteFullElement(w,null,'LookupVersionGuid',null, this.lookupVersionGuid);
            w.writeStartElement(null, 'Attributes', null);
            for (string name : attrValByAttrName.keySet())
            {
                string val = attrValByAttrName.get(name);
                w.writeStartElement(null, 'LookupAttribute', null);
                PBS_gBUILD_Utility.WriteFullElement(w,null,'Name',null, name);
                w.writeStartElement(null, 'Value', null);
                w.writeAttribute(prefixXmlSchemaInstance, nsXmlSchemaInstance, 'type', 'xsd:string');
                if (val!=null)
                {
                    w.writeCharacters(val);
                }
                w.writeEndElement(); //Value
                w.writeEndElement(); //LookupAttribute
            }
            w.writeEndElement(); //Attributes
            w.writeEndElement(); //LookupItem
        }

        public LookupItem(dom.XmlNode n)
        {
            this.code = get(n, 'Code');
            this.fullCode = get(n, 'FullCode');
            this.description = get(n, 'Description');
            this.lookupVersionGuid = get(n, 'LookupVersionGuid');
            this.parentFullCode = get(n, 'ParentFullCode');
            this.typeName = get(n, 'TypeName');
            this.id = get(n, 'ID');
            this.recordVersion = get(n, 'RecordVersion');
            this.sortValue = integer.valueOf(get(n, 'SortValue'));
            this.level = integer.valueOf(get(n, 'Level'));
            this.attrValByAttrName = new map<string, string>();
            n = n.getChildElement('Attributes', n.getNamespace());
            for (dom.XmlNode lookupAttribute : n.getChildElements())
            {
                string name = get(lookupAttribute, 'Name');
                string val = get(lookupAttribute, 'Value');
                attrValByAttrName.put(name, val);
            }            
        }

        public LookupItem(FolderLookupItemConfig config, string lookupVersionGuid)
        {
            this.code = config.code;
            this.fullCode = config.fullCode;
            this.description = 'created by PBS_ePM_FileManagerController';
            this.lookupVersionGuid = lookupVersionGuid;
            this.parentFullCode = config.parentFullCode;
            this.typeName = 'DocUDFLookup2';
            this.sortValue = config.sortValue;
            this.level = config.level;
            this.attrValByAttrName = new map<string, string>();
            this.attrValByAttrName.put('Attribute1', config.documentType);
            this.attrValByAttrName.put('Attribute2', PBS_gBUILD_Utility.createGuid());
            this.attrValByAttrName.put('Attribute3', null);
            this.attrValByAttrName.put('Attribute4', null);
            this.attrValByAttrName.put('Attribute5', null);
            this.attrValByAttrName.put('Attribute6', null);
        }
    }

    private class getLookupItemsResult
    {
        public EchoElement type { get; private set; }
        public List<EchoElement> attributes { get; private set; }
        public List<EchoElement> lookupLevels { get; private set; }
        public Map<string, LookupItem> lookupItemByFullCode { get; private set; }
        public boolean isManaged { get; private set; }

        public string CreateVersionXmlString()
        {
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument(null, '1.0');            
            WriteVersion(w);
            w.writeEndDocument();
            string xml = w.getXmlString();
            w.close();
            string left = xml.substringBefore('<version');
            xml = xml.substringAfter(left);
            return xml;
        }

        private void WriteVersion(XmlStreamWriter w)
        {
            w.writeStartElement(null, 'version', null);
            type.write(w, null);
            w.writeStartElement(null, 'Attributes', null);
            for (EchoElement ee : attributes)
            {
                ee.write(w, null);//'Unchanged');
            }
            w.writeEndElement(); //Attributes
            w.writeStartElement(null, 'Levels', null);
            for (EchoElement ee : lookupLevels)
            {
                ee.write(w, null);//'Unchanged');
            }
            w.writeEndElement(); //Levels
            w.writeStartElement(null, 'Items', null);

            List<LookupItem> items = new List<LookupItem>();
            for (string key : lookupItemByFullCode.keySet())
            {
                items.add(lookupItemByFullCode.get(key));
            }
            items.sort();
            integer z = 0;
            for (LookupItem item : items)
            {
                item.sortValue = ++z;
                item.write(w, null);//'Unchanged');
            }
            w.writeEndElement(); //Items
            PBS_gBUILD_Utility.WriteFullElement(w,null,'IsManaged',null, isManaged?'true':'false');
            w.writeEndElement(); //version
        }

        public getLookupItemsResult(dom.XmlNode n)
        {
            type = new EchoElement(PBS_gBUILD_Utility.findNode(n, 'Type'));
            attributes = new List<EchoElement>();
            for (dom.XmlNode z : PBS_gBUILD_Utility.findNode(n, 'Attributes').getChildElements())
            {
                attributes.add(new EchoElement(z));
            }
            lookupLevels = new List<EchoElement>();
            for (dom.XmlNode z : PBS_gBUILD_Utility.findNode(n, 'Levels').getChildElements())
            {
                lookupLevels.add(new EchoElement(z));
            }
            lookupItemByFullCode = new Map<string, LookupItem>();
            for (dom.XmlNode z : PBS_gBUILD_Utility.findNode(n, 'Items').getChildElements())
            {
                LookupItem li = new LookupItem(z);
                lookupItemByFullCode.put(li.fullCode, li);
            }
            IsManaged = PBS_gBUILD_Utility.parseBool(PBS_gBUILD_Utility.findNode(n, 'IsManaged').getText(), true);
        }
    }
    

    private void getFolders()
    {
        string message = createSoapMessage(getLookupItemsUri, getLookupItemsAction, 
'<GetLookupVersionBySystemType xmlns="http://www.mps.com/Proliance/webservices">'+
'  <systemType>'+
'    <Guid>00000000-0000-0000-0000-000000000000</Guid>'+
'    <Name>DocUDFLookup2</Name>'+
'    <AccountType>Project</AccountType>'+
'    <DefinedBy>Application</DefinedBy>'+
'    <IsSynchronized>false</IsSynchronized>'+
'  </systemType>'+
'  <isIncludeAllItems>true</isIncludeAllItems>'+
'</GetLookupVersionBySystemType>');
        dom.XmlNode el = getSoapResponseRootNode(getLookupItemsUri, getLookupItemsAction, message);    
        el = PBS_gBUILD_Utility.findNode(el, 'GetLookupVersionBySystemTypeResult');
        folderLookupResult = new getLookupItemsResult(el);
        if (ensureTopLevelEpmFolders)
        {
            doTopLevelEpmFolders();
        }
    }

    private class FolderLookupItemConfig
    {
        public string code {get; private set; }
        public string fullCode {get; private set; }
        public string parentFullCode { get; private set; }
        public string documentType {get; private set; }
        public integer sortValue {get; private set; }
        public integer level { get; private set; }

        public FolderLookupItemConfig(string fullCode, string documentType, integer sortValue)
        {
            integer n;
            this.fullCode = fullCode;
            this.code = fullCode;
            n = this.code.lastIndexOf('/');
            if (n>-1)
            {
                this.code = this.fullCode.substringAfterLast('/');
                this.parentFullCode = this.fullCode.substringBeforeLast('/');
            }
            this.level = this.fullcode.split('/').size()-1;
            this.code = code;
            this.documentType = documentType;
            this.sortValue = sortValue;
        }
    }

    private boolean doTopLevelEpmFoldersCalled { get; set; }
    private void doTopLevelEpmFolders()
    {
        if (doTopLevelEpmFoldersCalled) return;
        doTopLevelEpmFoldersCalled = true;
        conditionallyAddFolderLookupConfigs(epmTopLevelFolderConfigs);
    }

    private void conditionallyAddFolderLookupConfigs(List<FolderLookupItemConfig> lookupConfigs)
    {
        integer changeCount = 0;
        for (FolderLookupItemConfig c : lookupConfigs)
        {
            if (folderLookupResult.lookupItemByFullCode.containsKey(c.code)) continue;
            LookupItem li = new LookupItem(c, folderLookupResult.type.valByName.get('LookupVersionGuid'));
            folderLookupResult.lookupItemByFullCode.put(li.fullCode, li);
            ++changeCount;
            PBS_gBUILD_Utility.showInfoMessage(string.Format('Adding folder [{0}]', new string[]{li.fullCode}));            
        }
        if (0==changeCount) return;
        string versionXml = folderLookupResult.CreateVersionXmlString();
        string message = createSoapMessage(saveLookupVersionUri, saveLookupVersionAction, 
'<SaveLookupVersion xmlns="http://www.mps.com/Proliance/webservices">'+
versionXml +
'</SaveLookupVersion>');
        getSoapResponseRootNode(saveLookupVersionUri, saveLookupVersionAction, message);    
        getFolders();
    }

    public PageReference login()
    {
        PBS_gBUILD_Utility.showDebugMessage('Logging in');
        try
        {
            modesOff();
            getSiteConfiguration();
            getProjects();
            if (epmProjects.size()==0)
            {
                PBS_gBUILD_Utility.showWarningMessage(string.Format('The ePM account [{0}] does not have access to any projects', new string[]{username}));
                loginMode = true;
                return null;
            }
            boolean found = false;
            for (EpmProject p : epmProjects)
            {
                if (p.projectAccountName!=null && p.projectAccountName.equalsIgnoreCase(epmAccountName))
                {
                    epmAccountName = p.projectAccountName;
                    found = true;
                    break;
                }
            }
            if (found)
            {
                treeMode = true;
                epmProjects = null;
                getDocuments();
            }
            else
            {
                if (epmAccountNameForced)
                {
                    loginMode = true;
                    string msg = 'You are required to upload to the ePM Project ['+epmAccountName+'] but do not appear to have permissions.  Please try to log into another account or have someone else upload the document for you.';
                    if (noAccessContactName!=null && noAccessContactName.length()>0)
                    {
                        msg += '  Or you can reach out to '+noAccessContactName+' and ask for access to that project';
                    }
                    PBS_gBUILD_Utility.showWarningMessage(msg);
                }
                else
                {
                    projectsMode = true;
                    if (epmAccountName!=null && epmAccountName!='')
                    {
                        string msg = 'Could not find specified ePM Project ['+epmAccountName+'].  Please select one.';
                        if (noAccessContactName!=null && noAccessContactName.length()>0)
                        {
                            msg += '  Or you can reach out to '+noAccessContactName+' and ask for access to that project';
                        }
                        PBS_gBUILD_Utility.showWarningMessage(msg);
                    }
                    else
                    {
                        PBS_gBUILD_Utility.showInfoMessage('Please select the destination ePM Project.');
                    }                
                }
            }
        }
        catch (SoapFaultException sfex)
        {
            showSoapFaultExceptionMessage(sfex);
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex);
        }
        return null;
    }

    public class EpmDocument
    {
        public string documentGuid { get; private set; }
        public string documentTitle { get; private set; }
        public string documentProcessState { get; private set; }
        public string docVisualID { get; private set; }
        public string documentType { get; private set; }
        public string mpsAccountName { get; private set; }
        public string url { get; private set; }
        public LookupItem folderLookupItem { get; private set; }
        public string folderFullCode { get; private set; }

        private string get(dom.XmlNode el, string name)
        {
            el = el.getChildElement('CatalogCard_'+name, el.getNamespace());
            if (el==null) return null;
            return el.getText();
        }

        public EpmDocument(PBS_ePM_FileManagerController c, dom.XmlNode p)
        {
            PBS_gBUILD_Utility.showDebugMessage(p.getName());
            this.documentGuid = get(p,'DocumentGuid');
            this.documentTitle = get(p,'DocTitle');
            this.documentProcessState = get(p,'DocumentProcessState');
            this.docVisualID = get(p,'DocVisualID');
            this.documentType = get(p,'DocumentType');
            this.mpsAccountName = get(p,'MPSAccountName');
            this.folderFullCode = get(p, 'DocUDFLookup2_FullCode');
            if (c.folderLookupResult.lookupItemByFullCode.containsKey(this.folderFullCode))
            {
                folderLookupItem = c.folderLookupResult.lookupItemByFullCode.get(this.folderFullCode);
            }
            this.url = c.createUrl(documentGuid);
        }
    }

    public class EpmProject
    {
        public string docVisualID {get; private set; }
        public string docTitle {get; private set; }
        public string projectAccountName {get; private set; }
        public Boolean isTemplate {get; private set; }
        public string documentProcessState {get; private set; }
        public string documentGuid {get; private set; }
        public string docDescription {get; private set; }
        public string mpsAccountName {get; private set; }
        public string documentType {get; private set; }

        private string get(dom.XmlNode el, string name)
        {
            el = el.getChildElement('OrgProjectDocument.'+name, el.getNamespace());
            if (el==null) return null;
            return el.getText();
        }

        public EpmProject(dom.XmlNode p)
        {
            PBS_gBUILD_Utility.showDebugMessage(p.getName());
            this.docVisualID = get(p,'DocVisualID');
            this.docTitle = get(p,'DocTitle');
            this.projectAccountName = get(p,'ProjectAccountName');
            this.isTemplate = get(p,'IsTemplate') <> '0';
            this.documentProcessState = get(p,'DocumentProcessState');
            this.documentGuid = get(p,'DocumentGuid');
            this.docDescription = get(p,'DocDescription');
            this.mpsAccountName = get(p,'MPSAccountName');
            this.documentType = get(p,'DocumentType');
        }
    }

    private class DocSubTypeTemplate
    {
        public string name { get; private set; }
        public string description { get; private set; }
        public string status { get; private set; }
        public string documentTypeName { get; private set; }
        public string guid { get; private set; }

        private string get(dom.XmlNode el, string name)
        {
            el = el.getChildElement(name, el.getNamespace());
            if (el==null) return null;
            return el.getText();
        }

        public DocSubTypeTemplate(dom.XmlNode p)
        {
            PBS_gBUILD_Utility.showDebugMessage(p.getName());
            this.name = get(p, 'Name');
            this.description = get(p, 'Description');
            this.status = get(p, 'Status');
            this.documentTypeName = get(p, 'DocumentTypeName');
            this.guid = get(p, 'Guid');
        }
    }

    private void showSoapFaultExceptionMessage(SoapFaultException sfex)
    {
        PBS_gBUILD_Utility.showErrorMessage(sfex.getMessage());
        PBS_gBUILD_Utility.showErrorMessage(string.format(
            '{0} ({1})',
            new string[]{sfex.fault.FaultString, sfex.fault.FaultCode}
        ));
    }

    public static void validateNoFault(dom.XmlNode root, string heading)
    {
        SoapFault f = new SoapFault(root);
        if (f==null||!f.IsFault) return;
        throw new SoapFaultException(f, heading);
    }

    public class SoapFaultException extends Exception 
    {
        public SoapFault fault { get; private set; }
        public SoapFaultException(SoapFault f, string msg)
        {
            this.setMessage(msg);
            this.fault = f;
        }
    }

    public class SoapFault
    {
        public string FaultCode { get; private set; }
        public string FaultString { get; private set; }
        public boolean IsFault { get; private set; }

        public SoapFault(dom.XmlNode root)
        {
            IsFault = false;
            try            
            {
                dom.XmlNode el;
                el = root.getChildElement('Body', PBS_ePM_FileManagerController.nsSoap);
                if (el==null) return;
                el = el.getChildElement('Fault', PBS_ePM_FileManagerController.nsSoap);
                if (el==null) return;
                FaultCode = PBS_gBUILD_Utility.findNode(el, 'faultcode').getText();
                FaultString = PBS_gBUILD_Utility.findNode(el, 'faultstring').getText();
                IsFault = true;
            }
            catch (Exception ex)
            {
                PBS_gBUILD_Utility.showDebugMessage(ex);
            }
        }        
    }

    private static testMethod PBS_ePM_FileManagerController GetTestController()
    {
        TestPBS_gBUILD_Utility.setup();
        PBS_gBUILD_Utility.AppConfig.EpmFileManagerClockTimeDelta__c = 0;
        PBS_gBUILD_Utility.AppConfig.EpmFileManagerRequestTimeout__c = 60;
        system.assert(true);
        PBS_ePM_FileManagerController ctrl = new PBS_ePM_FileManagerController();
        ctrl.username = 'USER';
        ctrl.password = 'PASS';
        ctrl.org = 'ORG';
        return ctrl;
    }

    public static testMethod void testGetSiteConfiguration()
    {
        string xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"><soap:Header><wsa:Action>http://www.mps.com/Proliance/webservices/GatewayService/DocumentDataService/GetSiteConfigurationResponse</wsa:Action><wsa:MessageID>urn:uuid:85caabc0-70b7-409d-a127-378561d58045</wsa:MessageID><wsa:RelatesTo>urn:uuid:19a64fc7-04f7-416c-b0bc-8ec336fa4fed</wsa:RelatesTo><wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To></soap:Header><soap:Body><GetSiteConfigurationResult xmlns="http://www.mps.com/Proliance/webservices/GatewayService"><ProlianceVersion>4.1.5322.0</ProlianceVersion><MaxPageSize>5000</MaxPageSize><MaxUploadDownloadFileChunkLength>33550336</MaxUploadDownloadFileChunkLength></GetSiteConfigurationResult></soap:Body></soap:Envelope>';
        PBS_ePM_FileManagerController ctrl = GetTestController();
        ctrl.DbgSetNextResponse = xml;
        ctrl.getSiteConfiguration();
        system.assertEquals('4.1.5322.0', ctrl.prolianceVersion);
        system.assertEquals(5000, ctrl.maxPageSize);
        system.assertEquals(33550336, ctrl.maxUploadDownloadFileChunkLength);
    }

    public static testMethod void testGetDocumentSubTypes()
    {
        string xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"><soap:Header><wsa:Action>http://www.mps.com/Proliance/webservices/GetDocSubTypeNamesByTypeResponse</wsa:Action><wsa:MessageID>urn:uuid:bb0713d3-bf39-4acc-8c36-1c0e484335d7</wsa:MessageID><wsa:RelatesTo>urn:uuid:c8858505-c6e4-4d65-8098-7479de105673</wsa:RelatesTo><wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To></soap:Header><soap:Body><GetDocSubTypeNamesByTypeResponse xmlns="http://www.mps.com/Proliance/webservices"><GetDocSubTypeNamesByTypeResult><DocSubTypeTemplateStruct><Name>Design Document</Name><Description /><DefaultType>CustomDefault</DefaultType><Status>Active</Status><DocumentTypeName>MPS.Prolog.Business.Packages.DrawingService.Documents.DrawingDocument</DocumentTypeName><Guid>7f84daad-1e00-4c8a-89a4-5f4cd3a8124f</Guid><IsManaged>true</IsManaged><RecordVersion>6</RecordVersion><CustomUI><ButtonTextForExisting /><IsEnabledForExisting>false</IsEnabledForExisting><IsEnabledForNew>false</IsEnabledForNew><RolesForNew /><RolesForExisting /><TooltipForExisting /><UriTemplate /></CustomUI><WebUI><DisabledEditTooltip /><EditRoles /><IsWorkflowRestrictedByEditRoles>false</IsWorkflowRestrictedByEditRoles></WebUI></DocSubTypeTemplateStruct><DocSubTypeTemplateStruct><Name>Drawing (All Fields)</Name><Description /><DefaultType>NoDefault</DefaultType><Status>Inactive</Status><DocumentTypeName>MPS.Prolog.Business.Packages.DrawingService.Documents.DrawingDocument</DocumentTypeName><Guid>628325f5-2d84-4b77-9f0b-d177499a52c2</Guid><IsManaged>true</IsManaged><RecordVersion>5</RecordVersion><CustomUI><ButtonTextForExisting /><IsEnabledForExisting>false</IsEnabledForExisting><IsEnabledForNew>false</IsEnabledForNew><RolesForNew /><RolesForExisting /><TooltipForExisting /><UriTemplate /></CustomUI><WebUI><DisabledEditTooltip /><EditRoles /><IsWorkflowRestrictedByEditRoles>false</IsWorkflowRestrictedByEditRoles></WebUI></DocSubTypeTemplateStruct><DocSubTypeTemplateStruct><Name>Drawing Default</Name><Description /><DefaultType>NoDefault</DefaultType><Status>Inactive</Status><DocumentTypeName>MPS.Prolog.Business.Packages.DrawingService.Documents.DrawingDocument</DocumentTypeName><Guid>00d47e4a-8fc2-4c6d-a54d-d8e690830234</Guid><IsManaged>true</IsManaged><RecordVersion>5</RecordVersion><CustomUI><ButtonTextForExisting /><IsEnabledForExisting>false</IsEnabledForExisting><IsEnabledForNew>false</IsEnabledForNew><RolesForNew /><RolesForExisting /><TooltipForExisting /><UriTemplate /></CustomUI><WebUI><DisabledEditTooltip /><EditRoles /><IsWorkflowRestrictedByEditRoles>false</IsWorkflowRestrictedByEditRoles></WebUI></DocSubTypeTemplateStruct></GetDocSubTypeNamesByTypeResult></GetDocSubTypeNamesByTypeResponse></soap:Body></soap:Envelope>';
        PBS_ePM_FileManagerController ctrl = GetTestController();
        ctrl.DbgSetNextResponse = xml;
        ctrl.getDocumentSubTypes();
        system.assertEquals(3, ctrl.docSubTypes.size());
    }

    public static testMethod void testGetFolders()
    {
        string xml = '<?xml version="1.0" encoding="utf-8"?><GetLookupVersionBySystemTypeResult><version><Type>type</Type><Attributes><attr>a1</attr><attr>a2</attr><attr>a3</attr></Attributes><Levels><level>l1</level><level>l2</level><level>l3</level></Levels><Items><LookupItem State="state"><Code>code</Code><FullCode>fullCode</FullCode><Description>description</Description><LookupVersionGuid>lookupVersionGuid</LookupVersionGuid><ParentFullCode>parentFullCode</ParentFullCode><TypeName>typeName</TypeName><ID>id</ID><RecordVersion>recordVersion</RecordVersion><SortValue>1</SortValue><Level>1</Level><Attributes><LookupAttribute><Name>name1</Name><Value type="xsd:string">val1</Value></LookupAttribute><LookupAttribute><Name>name2</Name><Value type="xsd:string">val2</Value></LookupAttribute></Attributes></LookupItem></Items><IsManaged>true</IsManaged></version></GetLookupVersionBySystemTypeResult>';
        PBS_ePM_FileManagerController ctrl = GetTestController();
        ctrl.DbgSetNextResponse = xml;
        ctrl.doTopLevelEpmFoldersCalled = true;
        ctrl.getFolders();
        system.assertEquals(true, ctrl.folderLookupResult.isManaged);
        ctrl.folderLookupResult.CreateVersionXmlString();
    }
    
    public static testMethod void testGetProjects()
    {
        string xml = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsa="http://schemas.xmlsoap.org/ws/2004/08/addressing"><soap:Header><wsa:Action>http://www.mps.com/Proliance/webservices/ListAccessibleOrgProjectsResponse</wsa:Action><wsa:MessageID>urn:uuid:e1109ed2-1466-441e-bfa5-a7a844687d57</wsa:MessageID><wsa:RelatesTo>urn:uuid:841a07d4-d1db-4801-afe9-19277eb3de86</wsa:RelatesTo><wsa:To>http://schemas.xmlsoap.org/ws/2004/08/addressing/role/anonymous</wsa:To></soap:Header><soap:Body><ListAccessibleOrgProjectsResponse xmlns="http://www.mps.com/Proliance/webservices"><ListAccessibleOrgProjectsResult><TotalCount>5</TotalCount><List><xs:schema id="NewDataSet" xmlns="" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:msprop="urn:schemas-microsoft-com:xml-msprop"><xs:element name="NewDataSet" msdata:IsDataSet="true" msdata:UseCurrentLocale="true"><xs:complexType><xs:choice minOccurs="0" maxOccurs="unbounded"><xs:element name="Business.OrgProject.Main"><xs:complexType><xs:sequence><xs:element name="OrgProjectDocument.DocVisualID" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.Program.DocTitle" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.ProjectAccountName" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.DocTitle" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.IsTemplate" msprop:DatagroupFieldType="BooleanField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.Boolean&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:decimal" minOccurs="0" /><xs:element name="OrgProjectDocument.DocumentProcessState" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;DocumentState&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.DocumentGuid" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.DocTitle.1" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.DocDescription" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.DocVisualID.1" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.MPSAccountName" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;None&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="OrgProjectDocument.DocumentType" msprop:DatagroupFieldType="StringField" msprop:DatagroupFieldIsCLOB="False" msprop:DatagroupFieldMPSType="&lt;MPSFieldType&gt;&lt;TypeHint&gt;DocumentType&lt;/TypeHint&gt;&lt;ValueTypeName&gt;System.String&lt;/ValueTypeName&gt;&lt;/MPSFieldType&gt;" type="xs:string" minOccurs="0" /><xs:element name="KeyColumnValue" msprop:KeyFieldName="OrgProjectDocument.DocumentGuid" type="xs:string" minOccurs="0" /></xs:sequence></xs:complexType></xs:element></xs:choice></xs:complexType></xs:element></xs:schema><diffgr:diffgram xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" xmlns:diffgr="urn:schemas-microsoft-com:xml-diffgram-v1"><NewDataSet xmlns=""><Business.OrgProject.Main diffgr:id="Business.OrgProject.Main1" msdata:rowOrder="0"><OrgProjectDocument.DocVisualID>1002</OrgProjectDocument.DocVisualID><OrgProjectDocument.Program.DocTitle>Region 03 - Mid-Atlantic Region Capital Project Program</OrgProjectDocument.Program.DocTitle><OrgProjectDocument.ProjectAccountName>pgmprj://pbs/r3pgm/arrapofffbctenergymod</OrgProjectDocument.ProjectAccountName><OrgProjectDocument.DocTitle>VA-Roanoke-Poff Federal Building-R&amp;A</OrgProjectDocument.DocTitle><OrgProjectDocument.IsTemplate>0</OrgProjectDocument.IsTemplate><OrgProjectDocument.DocumentProcessState>Active</OrgProjectDocument.DocumentProcessState><OrgProjectDocument.DocumentGuid>7b3f10f9-c3a0-44ed-8551-1fe7df010797</OrgProjectDocument.DocumentGuid><OrgProjectDocument.DocTitle.1>VA-Roanoke-Poff Federal Building-R&amp;A</OrgProjectDocument.DocTitle.1><OrgProjectDocument.DocVisualID.1>1002</OrgProjectDocument.DocVisualID.1><OrgProjectDocument.MPSAccountName>org://pbs</OrgProjectDocument.MPSAccountName><OrgProjectDocument.DocumentType>MPS.Prolog.Business.OrgProject.Documents.OrgProjectDocument</OrgProjectDocument.DocumentType><KeyColumnValue>7b3f10f9-c3a0-44ed-8551-1fe7df010797</KeyColumnValue></Business.OrgProject.Main><Business.OrgProject.Main diffgr:id="Business.OrgProject.Main2" msdata:rowOrder="1"><OrgProjectDocument.DocVisualID>1034</OrgProjectDocument.DocVisualID><OrgProjectDocument.Program.DocTitle>Region 06 - Heartland Region Capital Project Program</OrgProjectDocument.Program.DocTitle><OrgProjectDocument.ProjectAccountName>pgmprj://pbs/r6pgm/arra_robertayoungfederalbuilding</OrgProjectDocument.ProjectAccountName><OrgProjectDocument.DocTitle>MO-St. Louis-RAY FB-Energy Upgrades and Modernization</OrgProjectDocument.DocTitle><OrgProjectDocument.IsTemplate>0</OrgProjectDocument.IsTemplate><OrgProjectDocument.DocumentProcessState>Active</OrgProjectDocument.DocumentProcessState><OrgProjectDocument.DocumentGuid>bc2a06c7-1dbb-4cfe-98a2-4d65a1085bfb</OrgProjectDocument.DocumentGuid><OrgProjectDocument.DocTitle.1>MO-St. Louis-RAY FB-Energy Upgrades and Modernization</OrgProjectDocument.DocTitle.1><OrgProjectDocument.DocVisualID.1>1034</OrgProjectDocument.DocVisualID.1><OrgProjectDocument.MPSAccountName>org://pbs</OrgProjectDocument.MPSAccountName><OrgProjectDocument.DocumentType>MPS.Prolog.Business.OrgProject.Documents.OrgProjectDocument</OrgProjectDocument.DocumentType><KeyColumnValue>bc2a06c7-1dbb-4cfe-98a2-4d65a1085bfb</KeyColumnValue></Business.OrgProject.Main><Business.OrgProject.Main diffgr:id="Business.OrgProject.Main3" msdata:rowOrder="2"><OrgProjectDocument.DocVisualID>1073</OrgProjectDocument.DocVisualID><OrgProjectDocument.Program.DocTitle>Region 03 - Mid-Atlantic Region Capital Project Program</OrgProjectDocument.Program.DocTitle><OrgProjectDocument.ProjectAccountName>pgmprj://pbs/r3pgm/arrassansc</OrgProjectDocument.ProjectAccountName><OrgProjectDocument.DocTitle>ARRA SSA NSC</OrgProjectDocument.DocTitle><OrgProjectDocument.IsTemplate>0</OrgProjectDocument.IsTemplate><OrgProjectDocument.DocumentProcessState>Active</OrgProjectDocument.DocumentProcessState><OrgProjectDocument.DocumentGuid>525912de-4991-44d1-9c00-c66208170000</OrgProjectDocument.DocumentGuid><OrgProjectDocument.DocTitle.1>ARRA SSA NSC</OrgProjectDocument.DocTitle.1><OrgProjectDocument.DocVisualID.1>1073</OrgProjectDocument.DocVisualID.1><OrgProjectDocument.MPSAccountName>org://pbs</OrgProjectDocument.MPSAccountName><OrgProjectDocument.DocumentType>MPS.Prolog.Business.OrgProject.Documents.OrgProjectDocument</OrgProjectDocument.DocumentType><KeyColumnValue>525912de-4991-44d1-9c00-c66208170000</KeyColumnValue></Business.OrgProject.Main><Business.OrgProject.Main diffgr:id="Business.OrgProject.Main4" msdata:rowOrder="3"><OrgProjectDocument.DocVisualID>1099</OrgProjectDocument.DocVisualID><OrgProjectDocument.Program.DocTitle>Region 01 - New England Region Capital Project Program</OrgProjectDocument.Program.DocTitle><OrgProjectDocument.ProjectAccountName>pgmprj://pbs/region1-newenglandregionprogram/jfkwindowreplacement</OrgProjectDocument.ProjectAccountName><OrgProjectDocument.DocTitle>MA, Boston JFK FB R&amp;A Window Replacement</OrgProjectDocument.DocTitle><OrgProjectDocument.IsTemplate>0</OrgProjectDocument.IsTemplate><OrgProjectDocument.DocumentProcessState>Active</OrgProjectDocument.DocumentProcessState><OrgProjectDocument.DocumentGuid>cf796998-712c-4e4b-8cdf-69be3099857b</OrgProjectDocument.DocumentGuid><OrgProjectDocument.DocTitle.1>MA, Boston JFK FB R&amp;A Window Replacement</OrgProjectDocument.DocTitle.1><OrgProjectDocument.DocVisualID.1>1099</OrgProjectDocument.DocVisualID.1><OrgProjectDocument.MPSAccountName>org://pbs</OrgProjectDocument.MPSAccountName><OrgProjectDocument.DocumentType>MPS.Prolog.Business.OrgProject.Documents.OrgProjectDocument</OrgProjectDocument.DocumentType><KeyColumnValue>cf796998-712c-4e4b-8cdf-69be3099857b</KeyColumnValue></Business.OrgProject.Main><Business.OrgProject.Main diffgr:id="Business.OrgProject.Main5" msdata:rowOrder="4"><OrgProjectDocument.DocVisualID>1202</OrgProjectDocument.DocVisualID><OrgProjectDocument.Program.DocTitle>Region 03 - Mid-Atlantic Region Capital Project Program</OrgProjectDocument.Program.DocTitle><OrgProjectDocument.ProjectAccountName>pgmprj://pbs/r3pgm/arrabyrnegreencomplex</OrgProjectDocument.ProjectAccountName><OrgProjectDocument.DocTitle>PA-Philadelphia-Byrne Green Complex </OrgProjectDocument.DocTitle><OrgProjectDocument.IsTemplate>0</OrgProjectDocument.IsTemplate><OrgProjectDocument.DocumentProcessState>Active</OrgProjectDocument.DocumentProcessState><OrgProjectDocument.DocumentGuid>34945728-7a7a-47a9-96cc-9bc42a97e35f</OrgProjectDocument.DocumentGuid><OrgProjectDocument.DocTitle.1>PA-Philadelphia-Byrne Green Complex </OrgProjectDocument.DocTitle.1><OrgProjectDocument.DocVisualID.1>1202</OrgProjectDocument.DocVisualID.1><OrgProjectDocument.MPSAccountName>org://pbs</OrgProjectDocument.MPSAccountName><OrgProjectDocument.DocumentType>MPS.Prolog.Business.OrgProject.Documents.OrgProjectDocument</OrgProjectDocument.DocumentType><KeyColumnValue>34945728-7a7a-47a9-96cc-9bc42a97e35f</KeyColumnValue></Business.OrgProject.Main></NewDataSet></diffgr:diffgram></List></ListAccessibleOrgProjectsResult></ListAccessibleOrgProjectsResponse></soap:Body></soap:Envelope>';
        PBS_ePM_FileManagerController ctrl = GetTestController();
        ctrl.DbgSetNextResponse = xml;
        ctrl.getProjects();
        system.assertEquals(5, ctrl.epmProjects.size());
    }    
}