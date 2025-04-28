public with sharing class PBS_gBUILD_Utility
{
    public static boolean debugMode = true;

    //Sharing Reasons
    public static final string SharingReasonWfRoleDataEntry = 'WfRoleDataEntry';
    public static final string SharingReasonWfRoleDesignReviewer = 'WfRoleDesignReviewer';
    public static final string SharingReasonWfRoleProjectAdmin = 'WfRoleProjectAdmin';
    public static final string SharingReasonWfRoleViewer = 'WfRoleViewer';
    public static final string[] sharingReasonNames = new string[]{SharingReasonWfRoleDataEntry, SharingReasonWfRoleDesignReviewer, SharingReasonWfRoleProjectAdmin, SharingReasonWfRoleViewer};

    //Modified Reasons
    public static final string ModifyReasonApproved = 'Approved';
    public static final string ModifyReasonUpdated = 'Updated';
    public static final string ModifyReasonDeleted = 'Deleted';
    public static final string ModifyReasonCreated = 'Created';
    public static final string ModifyReasonCreatedOrUpdated = 'Created/Updated';

    //ProjectDocs folder
    private static final string HelpDocsFolderDeveloperName = 'PBS_gBUILD_HelpDocs';
    private static final string ProjectDocsFolderDeveloperName = 'PBS_gBUILD_ProjectDocs';
    private static string ProjectDocsFolderId_p = null;
    private static string HelpDocsFolderId_p = null;
    public static string ProjectDocsFolderId
    {
        get
        {
            if (ProjectDocsFolderId_p==null)
            {
                ProjectDocsFolderId_p = AppConfig.CustPortalProjectDocsFolderId__c;
                try
                {
                    Folder[] folders = [select id from folder where developername=:ProjectDocsFolderDeveloperName limit 1];
                    if (folders.size()==1) ProjectDocsFolderId_p = folders[0].id;
                    else showDebugMessage('Using AppConfig.CustPortalProjectDocsFolderId__c='+ProjectDocsFolderId_p);
                }
                catch (Exception ex)
                {
                    showDebugMessage(ex);
                }
            }
            return ProjectDocsFolderId_p;
        }
    }
    public static string HelpDocsFolderId
    {
        get
        {
            if (HelpDocsFolderId_p==null)
            {
                HelpDocsFolderId_p = AppConfig.CustPortalHelpFolderId__c;
                try
                {
                    Folder[] folders = [select id from folder where developername=:HelpDocsFolderDeveloperName limit 1];
                    if (folders.size()==1) HelpDocsFolderId_p = folders[0].id;
                    else showDebugMessage('Using AppConfig.CustPortalHelpFolderId__c='+HelpDocsFolderId_p);
                }
                catch (Exception ex)
                {
                    showDebugMessage(ex);
                }
            }
            return HelpDocsFolderId_p;
        }
    }

    //Random enumeration values
    public static final string projectStateFormative = 'Formative';

    //PBS_gBUILD_Project__c.ProjectTypes
    public static final string projectTypeNewConstruction = 'NewConstruction';
    public static final string projectTypeFullModernization = 'FullModernization';
    public static final string projectTypePartialModernizations = 'PartialModernizations';
    public static final string projectTypeLimitScope = 'LimitedScope';
    public static final string projectTypeSmallProject = 'SmallProject';

    //PBS_gBUILD_ProjectPerformancePeriodCashflow__c.ProjectPerformancePaymentMethods
    public static final string projectPerformancePaymentMethodAnnually = 'Annually';
    public static final string projectPerformancePaymentMethodMonthly = 'Monthly';
    public static final string projectPerformancePaymentMethodQuarterly = 'Quarterly';

    //ePM File Uploader settings
    public static final string epmDefaultOrg = 'pbs';
    public static final string epmCatalogExecution = '3.0 Execution';
    public static final string epmCatalogPhotos = '3.1 Photos';
    public static final string epmCatalogCloseout = '4.0 Close-out';

    //mpc record type ids
    public static final string mpcUpdateRecordTypeIdDR;
    public static final string mpcUpdateRecordTypeIdMPC;

    //application config record type ids
    public static final string appConfigRecordTypeIdChatterRoot;
    public static final string appConfigRecordTypeIdMpcInfo;
    public static final string appConfigRecordTypeIdAppBasics;
    public static final string appConfigRecordTypeIdScopeInfo;
    public static final string appConfigRecordTypeIdChangeLog;
    public static final string appConfigRecordTypeIdWfMachine;
    public static final string appConfigRecordTypeIdWfState;
    public static final string appConfigRecordTypeIdWfTransition;
    public static final string appConfigRecordTypeIdLinkList;
    public static final string appConfigRecordTypeIdLink;

    //project history record type ids
    public static final string workflowHistoryRecordTypeIdFormSignoff;
    public static final string workflowHistoryRecordTypeIdLastModifiedReason;
    public static final string workflowHistoryRecordTypeIdWorkflowStateTransition;

    //scope system record type names
    public static final string scopeSystemRecordTypeEcm = 'ARRA_ECM';

    //workflow record type names
    public static final string workflowRecordTypeMachine = 'WfMachine';
    public static final string workflowRecordTypeState = 'WfState';
    public static final string workflowRecordTypeTransition = 'WfTransition';

    //utility Savings phases
    public static final string utilitySavingsPhaseActual = 'Actual';
    public static final string utilitySavingsPhaseAnticipated = 'Anticipated';

    //project role names
    public static final string roleProjectAdmin = 'ProjectAdministrator';
    public static final string roleDataEntry = 'DataEntry';
    public static final string roleViewer = 'Viewer';
    public static final string roleEcoeApprover = 'EcoeApprover';
    public static final string roleDesignReviewer = 'DesignReviewer';
    public static final string roleSuperUser = 'SuperUser';
    public static final string roleNone = 'None';
    public static final string[] roleNames = new string[]{roleProjectAdmin, roleDataEntry, roleViewer, roleEcoeApprover, roleDesignReviewer};

    //permission set names
    public static final string permissionSetNameAppConfig = 'PBS_gBUILD_Config';
    public static final string permissionSetNameApplication = 'PBS_gBUILD_Application';
    public static final string permissionSetNameProjectProposeEcoe = 'PBS_gBUILD_ProjectProposeEcoe';
    public static final string permissionSetNameProjectCreateGb = 'PBS_gBUILD_ProjectCreateGb';
    public static final string permissionSetNameProjectCreateEpm = 'PBS_gBUILD_ProjectCreateEpm';
    public static final string permissionSetNameDesignReviewer = 'PBS_gBUILD_DesignReview';
    public static final string permissionSetNameGlobalAdmin = 'PBS_gBUILD_GlobalAdmin';
    public static final string permissionSetNameGlobalView = 'PBS_gBUILD_GlobalView';
    public static final string permissionSetNameEcoeApprover = 'PBS_gBUILD_EcoeApprover';
    public static final string[] permissionSetNamesWithGlobalProjectAccess = new string []{permissionSetNameDesignReviewer, permissionSetNameGlobalAdmin, permissionSetNameGlobalView, permissionSetNameEcoeApprover};
    public static final string[] permissionSetNames = new string[]{permissionSetNameAppConfig, permissionSetNameApplication, permissionSetNameProjectProposeEcoe, permissionSetNameProjectCreateGb, permissionSetNameProjectCreateEpm, permissionSetNameDesignReviewer, permissionSetNameGlobalAdmin, permissionSetNameGlobalView, permissionSetNameEcoeApprover};

    //passing of salesforce object ids
    public static final String queryStringProjectId = 'id';//'projectId';
    public static final String queryStringPBuildingId = 'pbuildingId';
    public static final String queryStringScopeSystemId = 'scopeSystemId';
    public static final String queryStringScopeDetailId = 'scopeDetailId';
    public static final String queryStringPFundingId = 'pfundingId';
    public static final String queryStringPInnovationId = 'innovationId';
    public static final String queryStringUtilitySavingsId = 'utilitySavingsId';
    public static final String queryStringUtilitySavingsContext = 'utilitySavingsContext';
    public static final String queryStringPerformanceCashflowId = 'cashflowId';
    public static final String queryStringMpcUpdateId = 'mpcUpdateId';

    //access levels
    public static final String accessLevelRead = 'Read';
    public static final String accessLevelEdit = 'Edit';
    public static final String accessLevelAll = 'All';

    //Posted form field names
    public static final String formFieldApproveReason = 'approveReason';

    //Items that aren't salesforce object ids
    public static final String queryStringRecordTypeId = 'recordTypeId';
    public static final String queryStringBuildingId = 'buildingId';
    public static final string queryStringPageMode = 'mode';
    public static final string queryStringMpcNum = 'mpcNum';

    public static final String commonProjCreatorEpm = 'ePM';
    public static final String commonProjCreatorGbuild = 'gBUILD';
    //public static final String commonProjCreatorSopt = 'SOPT';
    public static final String commonProjCreatorGpgis = 'GPGIS';
    public static final string[] allowedBaseProjectCreators = new string[]{commonProjCreatorEpm};

    public static final Integer soqlLimit = 2000;
    public static final Integer MAX_SCOPE_SYSTEMS = 100;

    public static final String mpcCategoryIntegratedDesign = 'Integrated Design (1-5)';
    public static final String mpcCategoryEnergyPerformance = 'Energy (6-10)';
    public static final String mpcCategoryWater = 'Water (11-14)';
    public static final String mpcCategoryIndoorEnvironmentalQuality = 'Indoor Environmental Quality (15-18)';
    public static final String mpcCategoryMaterials = 'Materials (19-21)';

    public static final string mpcUpdateDrRecordType = 'DR';
    public static final string mpcUpdateMpcRecordType = 'MPC';

    public static final string utilitySavingsTypeImpactScope = 'ImpactScopeLevel';
    public static final string utilitySavingsTypeImpactBuilding = 'ImpactBuildingLevel';
    public static final string utilitySavingsTypePerformanceBuilding = 'PerformanceBuildingLevel';

    public static final string yesNoNaTypeYes = 'Yes';
    public static final string yesNoNaTypeNo = 'No';
    public static final string yesNoNaTypeNA = 'N/A';

    public static final string pageModeEdit = 'edit';
    public static final string pageModeView = 'view';

    public static final gBUILD_ApplicationConfig__c AppConfig;

    private static final map<string, string> recordTypeIdByFullname;

    public static string getRecordTypeId(string sobjectName, string recordTypeName)
    {
        string key = string.format('{0}.{1}', new string[]{sobjectName.toLowerCase(), recordTypeName.toLowerCase()});
        return recordTypeIdByFullname.get(key);
    }

    public static string getScopeRecordTypeId(string recordTypeName)
    {
        return getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c', recordTypeName);
    }

    static
    {
        string[] sobjectTypeNames = new string[]{'gBUILD_ApplicationConfig__c', 'PBS_gBUILD_PBuildingScopeSystem__c', 'PBS_EuasPerformance__c', 'PBS_gBUILD_WorkflowHistory__c', 'PBS_gBUILD_PBuildingScopeSystemDetail__c', 'PBS_gBUILD_PBuildingMPCUpdate__c'};
        RecordType[] recordTypes = [
            select id, developername, sobjecttype
            from RecordType
            where sobjecttype in :sobjectTypeNames];
        recordTypeIdByFullname = new map<string, string>();
        for (RecordType z : recordTypes)
        {
            recordTypeIdByFullname.put(string.format('{0}.{1}', new string[]{z.sobjecttype.toLowerCase(), z.developername.toLowerCase()}), z.id);
            recordTypeIdByFullname.put(z.id, z.developerName);
        }
        mpcUpdateRecordTypeIdDR = getRecordTypeId('PBS_gBUILD_PBuildingMPCUpdate__c', 'DR');
        mpcUpdateRecordTypeIdMPC = getRecordTypeId('PBS_gBUILD_PBuildingMPCUpdate__c', 'MPC');
        appConfigRecordTypeIdChatterRoot = getRecordTypeId('gBUILD_ApplicationConfig__c', 'ChatterRoot');
        appConfigRecordTypeIdMpcInfo = getRecordTypeId('gBUILD_ApplicationConfig__c', 'MpcInfo');
        appConfigRecordTypeIdAppBasics = getRecordTypeId('gBUILD_ApplicationConfig__c', 'AppBasics');
        appConfigRecordTypeIdScopeInfo = getRecordTypeId('gBUILD_ApplicationConfig__c', 'ScopeInfo');
        appConfigRecordTypeIdChangeLog = getRecordTypeId('gBUILD_ApplicationConfig__c', 'Changelog');
        appConfigRecordTypeIdWfMachine = getRecordTypeId('gBUILD_ApplicationConfig__c', workflowRecordTypeMachine);
        appConfigRecordTypeIdWfState = getRecordTypeId('gBUILD_ApplicationConfig__c', workflowRecordTypeState);
        appConfigRecordTypeIdWfTransition = getRecordTypeId('gBUILD_ApplicationConfig__c', workflowRecordTypeTransition);
        appConfigRecordTypeIdLinkList = getRecordTypeId('gBUILD_ApplicationConfig__c', 'LinkList');
        appConfigRecordTypeIdLink = getRecordTypeId('gBUILD_ApplicationConfig__c', 'Link');
        workflowHistoryRecordTypeIdFormSignoff = getRecordTypeId('PBS_gBUILD_WorkflowHistory__c', 'FormSignoff');
        workflowHistoryRecordTypeIdLastModifiedReason = getRecordTypeId('PBS_gBUILD_WorkflowHistory__c', 'LastModifiedReason');
        workflowHistoryRecordTypeIdWorkflowStateTransition = getRecordTypeId('PBS_gBUILD_WorkflowHistory__c', 'WorkflowStateTransition');

        gBUILD_ApplicationConfig__c[] acs =
        [
            select
                DebugMode__c,
                HelpDeskEmail__c,
                TrainingFeedEntityId__c,
                PageHomeDashboardId__c,
                PageHomeDashboardHeight__c,
                ViewAllProjectsCustomerPortalAccount__c,
                MpcPreviewCompleteHistory__c,
                PageHomeIntro__c,
                PageProjectsIntro__c,
                PageTrainingIntro__c,
                PageCreateGbIntro__c,
                PageCreateEpmIntro__c,
                PageProposeEcoeIntro__c,
                PageProjectBasicsIntro__c,
                PageFundingSourcesIntro__c,
                PageFundingSourcesItemIntro__c,
                PageFinancialsIntro__c,
                PageContactsIntro__c,
                PageContactsItemIntro__c,
                PageWorkflowIntro__c,
                PageManageBuildingsIntro__c,
                PageBuildingBasicsIntro__c,
                PageScopeIntro__c,
                PageKpmIntro__c,
                TabKpmPerfProjIntro__c,
                TabKpmLEEDIntro__c,
                TabKpmEnergyStarIntro__c,
                TabKpmWmIntro__c,
                TabKpmWmApgIntro__c,
                TabKpmMvIntro__c,
                TabKpmActualImpactScopeIntro__c,
                TabKpmActualImpactBuildingIntro__c,
                TabKpmActualPerformanceBuildingIntro__c,
                TabKpmAnticImpactScopeIntro__c,
                TabKpmAnticImpactBuildingIntro__c,
                TabKpmAnticPerformanceBuildingIntro__c,
                TabKpmEcmIntro__c,
                PageComplianceIntro__c,
                PageMpcIntro__c,
                TabMpcIntDsgnIntro__c,
                TabMpcEnergyPerfIntro__c,
                TabMpcWaterIntro__c,
                TabMpcIeqIntro__c,
                TabMpcMaterialsIntro__c,
                PageBuildingCloseoutIntro__c,
                PageInnovationIntro__c,
                PageInnovationItemIntro__c,
                WorkflowGraphDisplayMode__c,
                SendApplicationEmails__c,
                SendWorkflowEmails__c,
                SendContactEmails__c,
                EpmFileManagerClockTimeDelta__c,
                EpmFileManagerRequestTimeout__c,
                CustPortalHelpFolderId__c,
                CustPortalProjectDocsFolderId__c
            from gBUILD_ApplicationConfig__c
            where RecordTypeId=:appConfigRecordTypeIdAppBasics
            order by createddate
            limit 1
        ];
        if (acs.size()==1)
        {
            AppConfig = acs[0];
            debugMode = AppConfig.DebugMode__c;
        }
        else
        {
            showErrorMessage('App Config is missing');
        }
    }

    public enum WfStateMachineTypes { Large, Small, Proposed }
    public static string findInitialWfStateId(WfStateMachineTypes type)
    {
        string name=null;
        if (type==WfStateMachineTypes.Large) name = 'WFS_LargeProject_Initiated';
        else if (type==WfStateMachineTypes.Small) name = 'WFS_SmallProject_Initiated';
        else if (type==WfStateMachineTypes.Proposed) name = 'WFS_EcoeProject_Initiated';
        gBUILD_ApplicationConfig__c ac = [select id from gBUILD_ApplicationConfig__c where RecordTypeId=:appConfigRecordTypeIdWfState and Name=:name];
        return ac.id;
    }

    public static List<SelectOption> createYesNoSelectOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(yesNoNaTypeYes,'Yes'));
        options.add(new SelectOption(yesNoNaTypeNo,'No'));
        return options;
    }

    public static void syncPBuildings(String projectId, String pbsProjectId)
    {
        Set<string> buildingIds = new Set<string>();
        for (PBS_gBUILD_ProjectBuilding__c z :
                [
                    select BldgId__c
                    from PBS_gBUILD_ProjectBuilding__c
                    where Rahd_ProjectParentId__c=:projectId
                ])
        {
            buildingIds.add(z.BldgId__c);
        }
        List<PBS_BuildingProjectAssociation__c> pbas = [
            select rluBuilding__c
            from PBS_BuildingProjectAssociation__c
            where rluProject__c=:pbsProjectId
        ];
        List<PBS_gBUILD_ProjectBuilding__c> projectBuildings = new List<PBS_gBUILD_ProjectBuilding__c>();
        for (PBS_BuildingProjectAssociation__c pba : pbas)
        {
            if (buildingIds.contains(pba.rluBuilding__c)) continue;
            buildingIds.add(pba.rluBuilding__c);
            PBS_gBUILD_ProjectBuilding__c z = new PBS_gBUILD_ProjectBuilding__c();
            z.Rahd_ProjectParentId__c=projectId;
            z.BldgId__c=pba.rluBuilding__c;
            projectBuildings.add(z);
        }
        if (projectBuildings.size()==0) return;
        insert projectBuildings;
    }

    public virtual class FieldInfo
    {
        public string Label { get; private set; }
        public string Help { get; private set; }
        public FieldInfo(Schema.DescribeFieldResult f)
        {
            this(f.getLabel(), f.getInlineHelpText());
        }
        public FieldInfo(string label, string help)
        {
            this.Label = label;
            this.Help = help;
        }
    }

    public class LinkedObjectFieldInfo extends PBS_gBUILD_Utility.FieldInfo
    {
        public string Url { get; private set; }
        public string Name { get; private set; }

        public LinkedObjectFieldInfo(Schema.DescribeFieldResult f, string objectId, string objectName)
        {
            super(f);
            Url = '/'+objectId;
            Name = objectName;
        }
        public LinkedObjectFieldInfo(string label, string help, string objectId, string objectName)
        {
            super(label, help);
            Url = '/'+objectId;
            Name = objectName;
        }
    }

    public class MpcInfo implements Comparable
    {
        public string cat {get; private set; }
        public string description { get; private set;}
        public Integer num { get; private set; }
        public string helpNC { get; private set; }
        public String helpPM { get; private set; }

        public Integer compareTo(Object compareTo)
        {
            MpcInfo that = (MpcInfo)compareTo;
            return this.num-that.num;
        }

        public MpcInfo(gBUILD_ApplicationConfig__c c)
        {
            this(integer.valueOf(c.MpcInfoNum__c), c.MpcInfoCategory__c, c.Label__c, c.MpcInfoHelpNewConstruction__c, c.MpcInfoHelpPartialModernization__c);
        }

        private MpcInfo(Integer num, String cat, String description, String helpNC, String helpPM)
        {
            this.num = num;
            this.cat = cat;
            this.description = description;
            this.helpNC = helpNC;
            this.helpPM = helpPM;
        }
    }

    private static List<MpcInfo> mpcInfos_p;
    public static List<MpcInfo> mpcInfos
    {
        get
        {
            if (mpcInfos_p==null)
            {
                String appConRTIdMpcInfoEscapeSingleQuotes = String.isNotBlank(appConfigRecordTypeIdMpcInfo)?string.escapeSingleQuotes(appConfigRecordTypeIdMpcInfo):appConfigRecordTypeIdMpcInfo;
                String strQuery = 'select ';
                strQuery += 'id,Name,MpcInfoNum__c,MpcInfoCategory__c,Label__c,';
                strQuery += 'MpcInfoHelpNewConstruction__c,MpcInfoHelpPartialModernization__c';
                strQuery += ' from gBUILD_ApplicationConfig__c';
                strQuery += ' where RecordTypeId =: appConRTIdMpcInfoEscapeSingleQuotes';
                gBUILD_ApplicationConfig__c[] acs = Database.query(strQuery);
                /*
                gBUILD_ApplicationConfig__c[] acs =
                    [
                        select
                            id,
                            Name,
                            MpcInfoNum__c,
                            MpcInfoCategory__c,
                            Label__c,
                            MpcInfoHelpNewConstruction__c,
                            MpcInfoHelpPartialModernization__c
                        from gBUILD_ApplicationConfig__c
                        where RecordTypeId=:appConfigRecordTypeIdMpcInfo
                    ];
                */

                mpcInfos_p = new List<MpcInfo>();
                for (gBUILD_ApplicationConfig__c z : acs)
                {
                    mpcInfos_p.add(new MpcInfo(z));
                }
                mpcInfos_p.sort();
            }
            return mpcInfos_p;
        }
    }

    @testVisible static String createScopeInfoSectionTitle(String l1Val, String l2Val, String l3Val)
    {
        ScopeInfo si;
        si = getScopeInfo(1, l1Val);
        String s = '';
        s += si==null ? l1Val : si.businessName;
        if (l2Val!=null)
        {
            s += ' -> ';
            si = getScopeInfo(2, l2Val);
            s += si==null ? l2Val : si.businessName;
            if (l3Val!=null)
            {
                s += ' -> ';
                si = getScopeInfo(3, l3Val);
                s += si==null ? l3Val : si.businessName;
            }
        }
        return s;
    }

    public static List<SelectOption> convertScopeInfos2Options(Integer level, string parentValue)
    {
        List<SelectOption> options = new List<SelectOption>();
        for(ScopeInfo si : scopeInfos)
        {
            if (si.level==level)
            {
                //ShowDebugMessage(string.format('convertScopeInfos2Options level={0} parentValue={1} si.value={2} si.parentValue={3}', new string[]{level.format(), parentValue, si.value, si.parentValue}));
                if (parentValue==null || parentValue==si.parentValue)
                {
                    options.add(new SelectOption(si.value, si.businessName));
                }
            }
        }
        options.sort();
        return options;
    }

    public class ScopeInfo
    {
        public string id, parentId;
        public Integer level { get; private set; }
        public String businessName { get; private set; }
        public String value { get; private set; }
        public String parentValue { get; private set; }
        public Integer minSystems { get; private set; }
        public Integer maxSystems { get; private set; }
        public Boolean allowWarranty { get; private set; }
        public Boolean allowArraWarranty { get; private set; }
        public Boolean allowManufacturer { get; private set; }
        public Boolean allowExtendedLED { get; private set; }
        public string labelFormat { get; set; }
        public string detailPageIntro { get; private set; }
        public string detailPageDetailTitle { get; private set; }
        public string detailPageDetailIntro { get; private set; }
        public string detailPageSystemTitle { get; private set; }
        public string detailPageSystemIntro { get; private set; }
        public string systemsPageIntro { get; private set; }
        public string systemsPageSystemIntro { get; private set; }
        public string recordType { get; private set; }

        public ScopeInfo(gBUILD_ApplicationConfig__c c)
        {
            this.id = c.id;
            this.parentId = c.Parent__c;
            this.value = c.Name;
            this.level = integer.valueof(c.ScopeInfoLevel__c);
            if (level==3)
            {
                this.recordType = c.Name;
            }
            this.maxSystems = integer.valueof(c.ScopeInfoSystemMaximumCnt__c);
            this.minSystems = integer.valueof(c.ScopeInfoSystemMinimumCnt__c);
            this.systemsPageSystemIntro = c.ScopeInfoSystemPageIntroduction__c;
            this.detailPageSystemTitle = c.ScopeInfoSystemPageTitle__c;
            this.detailPageIntro = c.ScopeInfoDetailPageIntroduction__c;
            this.detailPageDetailTitle = c.ScopeInfoDetailPageDetailSectionTitle__c;
            this.detailPageDetailIntro = c.ScopeInfoDetailPageDetailSectionIntro__c;
            this.detailPageSystemTitle = c.ScopeInfoDetailPageSystemSectionTitle__c;
            this.detailPageSystemIntro = c.ScopeInfoDetailPageSystemSectionIntro__c;
            this.allowWarranty = c.ScopeInfoSystemWarrantyAllow__c;
            this.allowArraWarranty = c.ScopeInfoSystemWarrantyArraAllow__c;
            this.allowManufacturer = c.ScopeInfoSystemManufacturerAllow__c;
            this.allowExtendedLED = c.ScopeInfoSystemExtendedLedAllow__c;
            this.labelFormat = c.ScopeInfoSystemLabelFormat__c;
            this.businessName = c.ScopeInfoDetailLabelFormat__c;
        }

        public string createSectionTitle()
        {
            system.assertEquals(3, level);
            string l1Val = getScopeInfo(2, parentValue).parentValue;
            return createScopeInfoSectionTitle(l1Val, parentValue, value);
        }
    }

    public static ScopeInfo getScopeInfoById(string scopeInfoId)
    {
        if (scopeInfoByKey.containsKey(scopeInfoId))
        {
            return scopeInfoByKey.get(scopeInfoId);
        }
        return null;
    }

    public static ScopeInfo getScopeInfoByRecordTypeDeveloperName(string recordTypeDeveloperName)
    {
        if (scopeInfoByKey.containsKey(recordTypeDeveloperName))
        {
            return scopeInfoByKey.get(recordTypeDeveloperName);
        }
        return null;
    }

    public static ScopeInfo getScopeInfo(Integer level, String value)
    {
        for (ScopeInfo si : scopeInfos)
        {
            if (si.level==level && si.value==value) return si;
        }
        return null;
    }

    private static map<string, ScopeInfo> scopeInfoByKey_p;
    private static map<string, ScopeInfo> scopeInfoByKey
    {
        get
        {
            if (scopeInfoByKey_p==null)
            {
                scopeInfoByKey_p = new map<string, ScopeInfo>();
                for (ScopeInfo si : scopeInfos)
                {
                    scopeInfoByKey_p.put(si.id, si);
                    scopeInfoByKey_p.put(si.recordType, si);
                }
            }
            return scopeInfoByKey_p;
        }
    }

    public static List<ScopeInfo> scopeInfos
    {
        get
        {
            if (scopeInfos_p==null)
            {
                scopeInfos_p = new List<ScopeInfo>();

                String appCoRTIdSInfoEscapeSingleQuotes = String.isNotBlank(appConfigRecordTypeIdScopeInfo)?string.escapeSingleQuotes(appConfigRecordTypeIdScopeInfo):appConfigRecordTypeIdScopeInfo;
                String strQuery = 'select ';
                strQuery+='Name,Id,ScopeInfoDetailLabelFormat__c,ScopeInfoDetailPageDetailSectionIntro__c,ScopeInfoDetailPageDetailSectionTitle__c,';
                strQuery+='ScopeInfoDetailPageIntroduction__c,ScopeInfoDetailPageSystemSectionIntro__c,ScopeInfoDetailPageSystemSectionTitle__c,';
                strQuery+='ScopeInfoLevel__c,Parent__c,ScopeInfoSystemExtendedLedAllow__c,ScopeInfoSystemLabelFormat__c,ScopeInfoSystemManufacturerAllow__c,';
                strQuery+='ScopeInfoSystemMaximumCnt__c,ScopeInfoSystemMinimumCnt__c,ScopeInfoSystemPageIntroduction__c,';
                strQuery+='ScopeInfoSystemPageTitle__c,ScopeInfoSystemWarrantyAllow__c,ScopeInfoSystemWarrantyArraAllow__c';
                strQuery+=' from gBUILD_ApplicationConfig__c';
                strQuery+=' where RecordTypeId =: appCoRTIdSInfoEscapeSingleQuotes';
                gBUILD_ApplicationConfig__c[] items = Database.query(strQuery);

                /*
                gBUILD_ApplicationConfig__c[] items =
                [
                    select
                        Name,
                        Id,
                        ScopeInfoDetailLabelFormat__c,
                        ScopeInfoDetailPageDetailSectionIntro__c,
                        ScopeInfoDetailPageDetailSectionTitle__c,
                        ScopeInfoDetailPageIntroduction__c,
                        ScopeInfoDetailPageSystemSectionIntro__c,
                        ScopeInfoDetailPageSystemSectionTitle__c,
                        ScopeInfoLevel__c,
                        Parent__c,
                        ScopeInfoSystemExtendedLedAllow__c,
                        ScopeInfoSystemLabelFormat__c,
                        ScopeInfoSystemManufacturerAllow__c,
                        ScopeInfoSystemMaximumCnt__c,
                        ScopeInfoSystemMinimumCnt__c,
                        ScopeInfoSystemPageIntroduction__c,
                        ScopeInfoSystemPageTitle__c,
                        ScopeInfoSystemWarrantyAllow__c,
                        ScopeInfoSystemWarrantyArraAllow__c
                    from gBUILD_ApplicationConfig__c
                    where RecordTypeId=:appConfigRecordTypeIdScopeInfo
                ];
                */

                ShowDebugMessage(string.format('Loaded {0} gBUILD_ApplicationConfig__c\'s of RecordTypeId={1}', new string[]{items.size().format(), appConfigRecordTypeIdScopeInfo}));
                Map<string, string> valueById = new Map<string, string>();
                for (gBUILD_ApplicationConfig__c ac : items)
                {
                    scopeInfos_p.add(new ScopeInfo(ac));
                    valueById.put(ac.id, ac.name);
                }
                for (ScopeInfo so : scopeInfos_p)
                {
                    if (so.parentId!=null)
                    {
                        so.parentValue = valueById.get(so.parentId);
                    }
                    //showDebugMessage(string.format('ScopeInfo level={4} id={0} parentId={1} value={2} parentValue={3}', new string[]{so.id, so.parentid, so.value, so.parentValue, so.level.format()}));
                }
            }
            return scopeInfos_p;
        }
    }
    private static List<ScopeInfo> scopeInfos_p;

    public static List<PBS_gBUILD_PBuildingMPCUpdate__c> getMpcUpdates(string pbuildingId)
    {
        return
        [
            select
                id,
                RecordTypeId,
                RecordType.DeveloperName,
                Question__c,
                Status__c,
                DesignReviewStatus__c,
                Comments__c,
                IsCurrent__c,
                Rahd_ProjectBldgParentId__c,
                Recommendations__c,
                CreatedDate,
                CreatedById,
                LastModifiedDate,
                LastModifiedById
            from
                PBS_gBUILD_PBuildingMPCUpdate__c
            where
                Rahd_ProjectBldgParentId__c = :pbuildingId
        ];
    }

    public static PBS_gBUILD_ProjectBuilding__c loadProjectBuilding(string pbuildingId)
    {
        PBS_gBUILD_ProjectBuilding__c pb= null;
        list<PBS_gBUILD_ProjectBuilding__c> pbList = [
            select
                //Building Stuff
                BldgId__r.id,
                BldgId__r.Region_Code__c,
                BldgId__r.Location_Code_Plus__c,
                FacilityCode__c,
                //Project Building Stuff
                id,
                LastModifiedById,
                LastModifiedDate,
                ModifiedReason__c,
                SqFtOfApplication__c,
                EuasBaselinePerformanceYear__c,
                EuasBaselinePerformanceYear__r.FiscalYear__c,
                Rahd_ProjectParentId__r.ProjectId__r.numDesignPlanYear__c,
                Rahd_ProjectParentId__r.SubstantiallyCompleteDate__c,
                //KPM: Eperf
                EperfCoolingHeatingPlantsLccfigsPckPd__c,
                EperfCoolingHeatingPlantsLccfigsSir__c,
                EperfCoolingHeatingPlantsNarr__c,
                EperfEnvelopeDesignNarr__c,
                EperfMVAdvmtrsNarr__c,
                EperfMVAdvmtrsSubMeteringNarr__c,
                EperfOnrenSlrHoth2oLifecPbckpd__c,
                EperfOnrenSlrHoth2oLifecSir__c,
                EperfOnrenSlrHoth2oMeet30PctGoal__c,
                EperfOnrenSlrHoth2oMeet30PctGoalExpln__c,
                EperfOnrenSlrHoth2oProdTarget__c,
                EperfProperGlazingNarr__c,
                EperfRenergyLccfigsPybkpdBiogas__c,
                EperfRenergyLccfigsPybkpdBiomass__c,
                EperfRenergyLccfigsPybkpdGeothermal__c,
                EperfRenergyLccfigsPybkpdPv__c,
                EperfRenergyLccfigsPybkpdSolarEnergy__c,
                EperfRenergyLccfigsPybkpdWind__c,
                EperfRenergyLccfigsSIRBiogas__c,
                EperfRenergyLccfigsSIRBiomass__c,
                EperfRenergyLccfigsSIRGeothermal__c,
                EperfRenergyLccfigsSIRPv__c,
                EperfRenergyLccfigsSIRSolarEnergy__c,
                EperfRenergyLccfigsSIRWind__c,
                EperfRenergyLeedEaCredit__c,
                EperfRenergyLeedEaCreditExpln__c,
                EperfSolarHeatGainNarr__c,
                //???
                EstarAnticipatedCntPcs__c,
                EstarAnticipatedWeeklyOperatingHours__c,
                EstarAnticipatedWorkersOnMainShift__c,
                EstarBaselineCntPcs__c,
                EstarBaselineWeeklyOperatingHours__c,
                EstarBaselineWorkersOnMainShift__c,
                EstarPersuingEnergyStarCertification__c,
                EstarTargetRating__c,
                //KPM Performance Analysis and Assessment
                PerfAnalReportedPerfNarr__c,
                PerfAnalOperationalChangesNarr__c,
                PerfAnalImpactNewStuffNarr__c,
                PerfAnalBehavioralChangesNarr__c,
                //KPM: IEQ
                IEQDmdCntrPressNarr__c,
                IEQDmdCntrVentlNarr__c,
                IEQLemChklstAdhesivesSealants__c,
                IEQLemChklstCarpetSys__c,
                IEQLemChklstCompositeWoodProducts__c,
                IEQLemChklstFurnishings__c,
                IEQLemChklstIndoorPaints__c,
                IEQLemChklstOther__c,
                IEQLemNarr__c,
                IEQLghtCtrlLccfigsPbckpd__c,
                IEQLghtCtrlLccfigsSir__c,
                IEQLghtCtrlNarr__c,
                IEQMoistureControlNarr__c,
                //KPM: Intdsgn
                IntdsgnIntSustAverageMeetingFrequency__c,
                IntdsgnComishagtIndContractHolder__c,
                IntdsgnComishagtIndContractHldrOther__c,
                IntdsgnComishagtIndDateHired__c,
                IntdsgnComishagtIndDateStarted__c,
                IntdsgnComishagtIndDsgnComplBeforeCA__c,
                IntdsgnComishagtIndStageAtComish__c,
                IntdsgnIntSustAcousticsEngineer__c,
                IntdsgnIntSustArchitect__c,
                IntdsgnIntSustBldgOperationsNarr__c,
                IntdsgnIntSustBldgUsersFacilityMngr__c,
                IntdsgnIntSustCertLightingDsgnrEng__c,
                IntdsgnIntSustCivilEngineer__c,
                IntdsgnIntSustClientOwnersRep__c,
                IntdsgnIntSustComishAgent__c,
                IntdsgnIntSustConstructionMngr__c,
                IntdsgnIntSustElectricalEngineer__c,
                IntdsgnIntSustElectricUtilityRep__c,
                IntdsgnIntSustEnergyCnsltnt__c,
                IntdsgnIntSustEnvtlBldgCnsltnt__c,
                IntdsgnIntSustGeneralContractor__c,
                IntdsgnIntSustGsaHpgbTeamMember__c,
                IntdsgnIntSustIeqCnsltnt__c,
                IntdsgnIntSustIntegratedDesignNarr__c,
                IntdsgnIntSustInteriorDesigner__c,
                IntdsgnIntSustLandscapeArchitect__c,
                IntdsgnIntSustLeedAccreditedProf__c,
                IntdsgnIntSustMechanicalEngineer__c,
                IntdsgnIntSustOther__c,
                IntdsgnIntSustOtherSpecialized__c,
                IntdsgnIntSustPlumbingEngineer__c,
                IntdsgnIntSustSiteOperatorsBldgMngr__c,
                IntdsgnIntSustStructuralEngineer__c,
                IntdsgnIntSustSubcontractors__c,
                IntdsgnIntSustSustainabilityCnsltnt__c,
                IntdsgnIntSustWasteMgmtCnsltnt__c,
                //???
                LEEDGoal__c,
                LEEDRatingSys__c,
                LEEDExamptionCnt__c,
                LEEDExemptionDate__c,
                LEEDVersion__c,
                LEEDWasCertified__c,
                LEEDExemptionNumber__c,
                LEEDComments__c,
                LEEDRegisteredWithUSGBC__c,
                LEEDRegistrationNumber__c,
                LEEDRegistrationDate__c,
                LEEDCertificationDate__c,
                //LEEDCertificationLevel__c,
                LEEDCertificationLvl__c,
                //???
                LsnsBestpracLesson1__c,
                LsnsBestpracLesson2__c,
                LsnsBestpracLesson3__c,
                LsnsHumanisticStoriesStory1__c,
                LsnsHumanisticStoriesStory2__c,
                LsnsHumanisticStoriesStory3__c,
                LsnsPublicityProjectHasRep__c,
                LsnsSuccessStoriesStory1__c,
                LsnsSuccessStoriesStory2__c,
                LsnsSuccessStoriesStory3__c,
                LsnsPublicityContact__c,
                //KPM: Materiaals
                MaterialsEnvPreferredProductsNarr__c,
                //???
                MVContractorName__c,
                MVNarr__c,
                //???
                PerffutModelType__c,
                PerffutCalculatedSimplePayback__c,
                PerffutChilledWater__c,
                PerffutComments__c,
                PerffutEcmTotCost__c,
                PerffutElectric__c,
                PerffutEnergyUsageIntensityGoal__c,
                PerffutEuasReferenceYear__c,
                PerffutFinanceContractorMarkup__c,
                PerffutGas__c,
                PerffutGsf__c,
                PerffutGsfDirectionalChange__c,
                PerffutGsfAnticipated__c,
                PerffutGsfComments__c,
                PerffutImplementationPrice__c,
                PerffutIsEuasDataAccurate__c,
                PerffutOil__c,
                PerffutOtherRelatedCostSav__c,
                PerffutSourceOtherRelatedSav__c,
                PerffutSteam__c,
                PerffutTotAnnualCostSav__c,
                PerffutTotEnergy__c,
                PerffutWater__c,
                PerffutEnergyUsageIntensity__c,
                PerffutUtilitySavContextType__c,
                PerffutUtilitySav__c,
                PerffutIsEuasReferenceYearRep__c,
                //anticipated
                PerffutAnticChilledWater__c,
                PerffutAnticElectric__c,
                PerffutAnticGas__c,
                PerffutAnticOil__c,
                PerffutAnticSteam__c,
                PerffutAnticTotAnnualEnergyCalculated__c,
                PerffutAnticWater__c,
                PerffutAnticAnnualEnergyCalculated__c,
                PerffutAnticAnnualWaterCalculated__c,
                PerffutAnticEnergyConsumptionNarr__c,
                PerffutAnticEnergyConsumptionReduction__c,
                PerffutAnticCWaterConsumptionReduction__c,
                PerffutAnticElectricConsumptionReduction__c,
                PerffutAnticGasConsumptionReduction__c,
                PerffutAnticOilConsumptionReduction__c,
                PerffutAnticSteamConsumptionReduction__c,
                PerffutAnticWaterConsumptionReduction__c,
                //energy costs per unit
                PerffutCostsChilledWater__c,
                PerffutCostsElectric__c,
                PerffutCostsGas__c,
                PerffutCostsOil__c,
                PerffutCostsSteam__c,
                PerffutCostsWater__c,
                //actual
                ActualUtilitySav__c,
                PerffutActualChilledWater__c,
                PerffutActualElectric__c,
                PerffutActualGas__c,
                PerffutActualOil__c,
                PerffutActualSteam__c,
                PerffutActualWater__c,
                //???
                ProjturnBlineGreenProdsEasyProcNexpln__c,
                ProjturnBlineGreenProductsEasyProcure__c,
                ProjturnBlineIsBimInContract__c,
               ProjturnBlineKpmAntEnergyIntnstyCnfrm__c,
                ProjturnBlineKpmOccSpaceUseComments__c,
                ProjturnComishAllSysWork__c,
                ProjturnComishAllSysWorkNoExpln__c,
                ProjturnComishIsMvPlanComplete__c,
                ProjturnComishIsMvPlanCompleteNoExpln__c,
                ProjturnComishPlannedCertification__c,
                ProjturnComishPlannedStart__c,
                ProjturnComishSysManual__c,
                ProjturnDsgnIntBlineEnvelopeNarr__c,
                ProjturnDsgnIntBlineHvacNarr__c,
                ProjturnDsgnIntBlineLightingNarr__c,
                ProjturnDsgnIntBlineRenergyNarr__c,
                ProjturnDsgnIntBlineWaterNarr__c,
                ProjturnKpmAnticipatedEnergyIntensity__c,
                ProjturnOtherReceivedMaterials__c,
                ProjturnOtherReceivedMaterialsLoc__c,
                ProjturnOtherTrainingVideotaped__c,
                ProjturnOtherTrainingVideotapedLoc__c,
                ProjturnP100AeFinalRecordDrawings__c,
                ProjturnP100AeFinalRecordDrawingsLoc__c,
                ProjturnP100DocsRedlineUpdated__c,
                ProjturnP100DocsRedlineUpdatedLoc__c,
                ProjturnP100EqpMaintVideosHard__c,
                ProjturnP100EqpMaintVideosHardLoc__c,
                ProjturnP100EqpMaintVideosSoft__c,
                ProjturnP100EqpMaintVideosSoftLoc__c,
                ProjturnP100OperationsManual__c,
                ProjturnP100OperationsManualLoc__c,
                ProjturnP100ReceivedRedline__c,
                ProjturnP100ReceivedRedlineLoc__c,
                ProjturnP100TrainingMaterials__c,
                ProjturnP100TrainingMaterialsLoc__c,
                //KPM: Transp
                TranspSubmReqBikeFacilitiesBikePath__c,
                TranspSubmReqBikeFacilitiesIndoor__c,
                TranspSubmReqBikeFacilitiesOutdoor__c,
                TranspSubmReqBikeFacilitiesProvided__c,
                TranspSubmReqCommutingAltConsidered__c,
                TranspSubmReqExistingTransportNtwk__c,
                TranspSubmReqGsaParkingPolicy__c,
                TranspSubmReqMsrsAltFuelParkSpots__c,
                TranspSubmReqMsrsAltFuelParkSpotsCrtd__c,
                TranspSubmReqMsrsBicycleParking__c,
                TranspSubmReqMsrsCarpoolSpots__c,
                TranspSubmReqMsrsCarpoolSpotsCrtd__c,
                TranspSubmReqMsrsHybridRefuelStations__c,
                TranspSubmReqMsrsHybridRefuelStnsCrtd__c,
                TranspSubmReqMsrsLockersShowers__c,
                TranspSubmReqMsrsPublicTransp__c,
                TranspSubmReqMsrsShuttleService__c,
                TranspSubmReqNewSitesCommuterFriendly__c,
                //???
                WasteMaterialsCDWasteWeight__c,
                WasteMaterialsCDWasteDivertedWeight__c,
                WasteHaulerContact__c,
                WasteMaterialsBldgReuseAchievedDate__c,
                WasteMaterialsComment__c,
                WasteMaterialsProjectValueRecycledPct__c,
                WasteMaterialsRecycledInstldDatePct__c,
                WasteWasteLeedComments__c,
                WasteWasteLeedOnTrackMeetRequirements__c,
                WasteWasteMaterialsMgmt__c,
                WasteWstdivAt50PctConstruction__c,
                WasteWstdivAtCloseout__c,
                WasteWstdivAverageMonthly__c,
                WasteWstdivDate__c,
                WasteWstdivMethodComments__c,
                WasteWstdivMethodDonation__c,
                WasteWstdivMethodOtherText__c,
                WasteWstdivMethodRecyclingSalvageYard__c,
                WasteWstdivMethodReuseForProjectUse__c,
                WasteWstdivTarget__c,
                //KPM: Water
                WaterCaprainLccfigsPbckpd__c,
                WaterCaprainLccfigsSir__c,
                WaterCaprainNarr__c,
                WaterCoolingTowerPoth20LccfigsPbckpd__c,
                WaterCoolingTowerPoth20LccfigsSir__c,
                WaterCoolingTowerPoth20Narr__c,
                WaterIndoorPoth2oLccfigsPbckpd__c,
                WaterIndoorPoth2oLccfigsSir__c,
                WaterIndoorPoth2oNarr__c,
                WaterMeterCoolingTowerScopeBleed__c,
                WaterMeterCoolingTowerScopeMeterFeed__c,
                WaterOutdoorPoth2oLccfigsPbckpd__c,
                WaterOutdoorPoth2oLccfigsSir__c,
                WaterOutdoorPoth2oNarr__c,
                //???
                BldgId__c,
                Rahd_ProjectParentId__c,
                //SITES INFORMATION
                SITESBeingPursued__c,
                SITESVersion__c,
                SITESRegistrationNumber__c,
                SITESGoal__c,
                SITESCertificationLvl__c,
                SITESCertificationDate__c,
                SITESComments__c
                //SITES INFORMATION
        from PBS_gBUILD_ProjectBuilding__c where id=:pbuildingId limit 1];
        if(pbList.size()>0)
        pb=pbList.get(0);
        return pb;
    }

    public static MpcInfo getMpcInfo(integer mpcNum)
    {
        return mpcInfos[mpcNum-1];
    }

    public static string convertNumToMpcQuestion(Integer mpcNum)
    {
        return 'Mpc.'+mpcNum.format();
    }

    public static Integer convertMpcQuestionToNum(string mpcQuestion)
    {
        Integer i;
        mpcQuestion = mpcQuestion.trim();
        try
        {
            i = integer.valueOf(mpcQuestion);
            return i;
        }
        catch (Exception ex)
        {
            i = mpcQuestion.indexOf('.');
            mpcQuestion = mpcQuestion.substring(i+1);
            mpcQuestion = mpcQuestion.trim();
            i = integer.valueOf(mpcQuestion);
            return i;
        }
    }

    public static Map<Integer, PBS_gBUILD_PBuildingMPCUpdate__c> mapLatestMpcByMpcNum(List<PBS_gBUILD_PBuildingMPCUpdate__c> mpcs, Boolean isDR)
    {
        Map<Integer, PBS_gBUILD_PBuildingMPCUpdate__c> m = new Map<Integer, PBS_gBUILD_PBuildingMPCUpdate__c>();
        for (PBS_gBUILD_PBuildingMPCUpdate__c z: mpcs)
        {
            if (!z.IsCurrent__c) continue;
            if (z.RecordTypeId==mpcUpdateRecordTypeIdDR&&isDR || z.RecordTypeId==mpcUpdateRecordTypeIdMpc&&!isDR)
            {
                Integer num = convertMpcQuestionToNum(z.Question__c);
                m.put(num, z);
            }
        }
        return m;
    }

    public static string convertExceptionToString(Exception ex)
    {
        string s = '';
        s += 'msg=['+ex.getMessage()+']; \n';
        s +='st=['+ex.getStackTraceString()+']; ';
        return s;
    }

    public static void showErrorMessage(string msg)
    {
        if (msg==null || msg=='') return;
        system.debug('ERROR: '+msg);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, msg));
    }

    public static void showWarningMessage(string msg)
    {
        if (msg==null || msg=='') return;
        system.debug('WARN: '+msg);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning, msg));
    }

    public static void showInfoMessage(string msg)
    {
        if (msg==null || msg=='') return;
        system.debug('INFO: '+msg);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, msg));
    }

    public static void showDebugMessage(Exception ex)
    {
        if (!debugMode || ex==null) return;
        string msg = convertExceptionToString(ex);
        system.debug(msg);
        if(ApexPages.currentPage() != null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,msg));
        }
    }

    public static void showDebugMessage(string msg)
    {
        if (!debugMode || msg==null || msg=='') return;
        msg = 'DEBUG: '+msg;
        system.debug(msg);
        if(ApexPages.currentPage() != null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,msg));
        }
    }

    public static string shorten(string s)
    {
        return shorten(s, 100);
    }

    public static string shorten(string s, integer maxLen)
    {
        if (s==null||s.length()<=maxLen) return s;
        s = s.substring(0, maxLen-3);
        s += '...';
        return s;
    }

    public static string createRandomHexString(integer byteCount)
    {
        string hex = '0123456789abcdef';
        string ret = '';
        Integer i;
        for (integer z=0;z<byteCount;++z)
        {
            i = (Math.random()*16).intValue();
            ret += hex.substring(i,i+1);
            i = (Math.random()*16).intValue();
            ret += hex.substring(i,i+1);
        }
        return ret;
    }

    private static string guidS4()
    {
        string hex = '0123456789abcdef';
        string ret = '';
        Integer i;
        i = (Math.random()*16).intValue();
        ret += hex.substring(i,i+1);
        i = (Math.random()*16).intValue();
        ret += hex.substring(i,i+1);
        i = (Math.random()*16).intValue();
        ret += hex.substring(i,i+1);
        i = (Math.random()*16).intValue();
        ret += hex.substring(i,i+1);
        return ret;
    }

    public static string createGuid()
    {
        return (
                guidS4() + guidS4() + '-' +
                guidS4() + '-' +
                guidS4() + '-' +
                guidS4() + '-' +
                guidS4() + guidS4() + guidS4()
            );
    }

    private static map<string, Integer> valByHexChar;

    private static Integer convertHexCharToNum(string hexChar)
    {
        if (valByHexChar==null)
        {
            valByHexChar = new map<string,Integer>();
            valByHexChar.put('0',0);
            valByHexChar.put('1',1);
            valByHexChar.put('2',2);
            valByHexChar.put('3',3);
            valByHexChar.put('4',4);
            valByHexChar.put('5',5);
            valByHexChar.put('6',6);
            valByHexChar.put('7',7);
            valByHexChar.put('8',8);
            valByHexChar.put('9',9);
            valByHexChar.put('a',10);
            valByHexChar.put('b',11);
            valByHexChar.put('c',12);
            valByHexChar.put('d',13);
            valByHexChar.put('e',14);
            valByHexChar.put('f',15);
            valByHexChar.put('A',10);
            valByHexChar.put('B',11);
            valByHexChar.put('C',12);
            valByHexChar.put('D',13);
            valByHexChar.put('E',14);
            valByHexChar.put('F',15);
        }
        Integer ret = valByHexChar.get(hexChar);
        //showDebugMessage('H2N '+hexChar+'='+ret.format());
        return ret;
    }

    private static Integer charCodeAt(string hex, integer pos)
    {
        string sa, sb;
        sa = hex.Substring(pos, pos+1);
        sb = hex.Substring(pos+1, pos+2);
        Integer a, b;
        a = convertHexCharToNum(sa);
        b = convertHexCharToNum(sb);
        Integer ret = a*16+b;
        //showDebugMessage('charCodeAt pos: '+pos.format()+' a='+a+' b='+b+' => '+ret.format());
        return ret;
    }

    public static string convertHexString2Base64String(string hex)
    {
        string keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
        string output = '';
        Integer len = hex.length();
        Integer chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        for (integer i=0;i<len;)
        {
            Boolean bad2 = false;
            Boolean bad3 = false;
            chr1 = charCodeAt(hex, i);
            i += 2;
            if (i>=len)
            {
                chr2 = 0;
                bad2 = true;
            }
            else
            {
                chr2 = charCodeAt(hex, i);
            }
            i += 2;
            if (i>=len)
            {
                chr3 = 0;
                bad3 = true;
            }
            else
            {
                chr3 = charCodeAt(hex, i);
            }
            i += 2;

            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;

            if (bad2) {
                enc3 = enc4 = 64;
            } else if (bad3) {
                enc4 = 64;
            }

            //showDebugMessage('CHR: '+chr1.format()+', '+chr2.format()+', '+chr3.format());
            //showDebugMessage('ENC: '+enc1.format()+', '+enc2.format()+', '+enc3.format()+', '+enc4.format());

            output = output +
            keyStr.substring(enc1, enc1+1) + keyStr.substring(enc2, enc2+1) +
            keyStr.substring(enc3, enc3+1) + keyStr.substring(enc4, enc4+1);
        }
        return output;
    }

    private static double mult(decimal a, decimal b)
    {
        if (a==null || b==null) return 0;
        return a*b;
    }

    private static double firstWithValue(decimal a, decimal b, decimal c)
    {
        if (a!=null&&a!=0) return a;
        if (b!=null&&b!=0) return b;
        return c;
    }

    public static integer convert2DigitTo4DigitYear(integer y2)
    {
        if (y2==null) return null;
        if (y2<65) return y2+2000;
        if (y2<100) return y2+1900;
        return y2;
    }

    public class DocInfo
    {
        public Document Document { get; private set; }
        public string projectId { get; private set; }
        public string pbuildingId { get; private set; }
        public string key { get; private set; }

        public DocInfo(string projectId, string pbuildingId, string key)
        {
            this.projectId = projectId;
            this.pbuildingId = pbuildingId;
            this.key = key;
        }

        public DocInfo(Document d)
        {
            this.document = d;
            string[] parts = d.developername.split('_');
            projectId = parts[0].Substring(1);
            pbuildingId = parts[1].Substring(1);
            key = parts[2].Substring(1);
        }
    }

    public static boolean contains(List<string> items, string item)
    {
        Set<string> s = new Set<string>();
        s.addAll(items);
        return s.contains(item);
    }

    public static list<string> toList(set<string> items)
    {
        List<string> ret = new List<string>();
        if (items!=null)
        {
            ret.addAll(items);
        }
        return ret;
    }

    public static dom.XmlNode findNode(dom.XmlNode el, string localName)
    {
        if (el.getName()==localName) return el;
        for (dom.XmlNode z : el.getChildElements())
        {
            dom.XmlNode ret = findNode(z, localName);
            if (ret!=null) return ret;
        }
        return null;
    }

    public static void WriteFullElement(XmlStreamWriter w, string prefix, string localName, string namespaceUri, string val)
    {
        if (val==null)
        {
            w.writeEmptyElement(prefix, localName, namespaceUri);
        }
        else
        {
            w.writeStartElement(prefix, localName, namespaceUri);
            w.writeCharacters(val);
            w.writeEndElement();
        }
    }

    public static boolean parseBool(string s, boolean defaultVal)
    {
        if (s==null) return defaultVal;
        s = s.trim().toLowerCase();
        if (s=='true'||s=='1') return true;
        if (s=='false'||s=='0') return false;
        return defaultVal;
    }

    public static string format(List<string> strings, string sep)
    {
        return format(strings, sep, '{0}');
    }

    public static string format(List<string> strings, string sep, string format)
    {
        return format(strings, sep, format, false);
    }

    public static string format(List<string> strings, string sep, string format, boolean soqlQuote)
    {
        string ret = '';
        if (strings!=null)
        {
            integer index = 0;
            for (string s : strings)
            {
                if (index>0)
                {
                    ret += sep;
                }
                string val;
                if (soqlQuote)
                {
                    if (s==null)
                    {
                        val = 'null';
                    }
                    else
                    {
                        val = '\'' + string.escapeSingleQuotes(s) + '\'';
                    }
                }
                else
                {
                    val = s;
                }
                ret += string.format(format, new string[]{val, String.valueOf(index)});
                ++index;
            }
        }
        return ret;
    }

    public static PBS_gBUILD_WorkflowHistory__c RecordWorkflowHistory(string recordTypeId, string reason, string comments, string gBuildProjectId, string projectBuildingId, string scopeSystemId, string scopeSystemDetailId, string context)
    {
        PBS_gBUILD_WorkflowHistory__c z = new PBS_gBUILD_WorkflowHistory__c();
        z.RecordTypeId = recordTypeId;
        z.Action__c = reason;
        z.Comments__c = comments;
        z.Rahd_ProjectParentId__c = gBuildProjectId;
        z.ParentProjectBuilding__c = projectBuildingId;
        z.ParentScopeSystem__c = scopeSystemId;
        z.ParentScopeSystemDetail__c = scopeSystemDetailId;
        z.Context__c = context;
        insert z;
        showDebugMessage(string.format('WHF({0}) context="{1}" reason="{2}" comments="{3}"', new string[]{recordTypeIdByFullname.get(recordTypeId), context, reason, comments}));
        return z;
    }

    public static void RecordLastModifiedReason(string reason, string comments, string gBuildProjectId, string projectBuildingId, string scopeSystemId, string scopeSystemDetailId)
    {
        RecordWorkflowHistory(workflowHistoryRecordTypeIdLastModifiedReason, reason, comments, gBuildProjectId, projectBuildingId, scopeSystemId, scopeSystemDetailId, null);
   }

    public static void RecordProjectModifiedReason(string projectId, string reason)
    {
        RecordLastModifiedReason(reason, null, projectId, null, null, null);
    }

    public static void RecordProjectBuildingModifiedReason(string projectBuildingId, string reason)
    {
        PBS_gBUILD_ProjectBuilding__c[] ps = [select id, Rahd_ProjectParentId__c from PBS_gBUILD_ProjectBuilding__c where id=:projectBuildingId];
        if (ps.size()!=1) return;
        RecordLastModifiedReason(reason, null, ps[0].Rahd_ProjectParentId__c, projectBuildingId, null, null);
    }

    public static PageReference getScopeSystemDetailsPageRef(String scopeSystemId, String scopeDetailId, String recordTypeId, boolean edit)
    {
        String u = '/apex/PBS_gBUILD_PBuildingScopeDet'+
            '?'+queryStringScopeDetailId+'='+scopeDetailId+
            '&'+queryStringRecordTypeId+'='+recordTypeId+
            '&'+queryStringScopeSystemId+'='+scopeSystemId+
            '&'+queryStringPageMode+'='+(edit?pageModeEdit:pageModeView);
        PageReference pr = new PageReference(u);
        pr.setRedirect(true);
        return pr;
    }

    public static PageReference getScopePageRef(string scopeSystemId, string recordTypeId)
    {
        String u = '/apex/PBS_gBUILD_PBuildingScopeSys?' +
            queryStringScopeSystemId +
            '=' +
            scopeSystemId +
            '&' +
            queryStringRecordTypeId +
            '=' +
            recordTypeId;
        return new PageReference(u);
    }
    public static PageReference createLinkProjectBasics(string projectId)
    {
        return new PageReference('/apex/PBS_gBUILD_ProjectBasics?'+queryStringProjectId+'='+projectId);
    }
    public static PageReference createLinkPBuildingsManage(string projectId)
    {
        return new PageReference('/apex/PBS_gBUILD_PBuildingsManage?'+queryStringProjectId+'='+projectId);
    }
    public static PageReference createLinkProjects()
    {
        return new PageReference('/apex/PBS_gBUILD_Projects');
    }

    public static Group[] GetGroupMembership(string userOrGroupId, boolean directOnly)
    {
        set<string> userOrGroupIds = new set<string>();
        userOrGroupIds.add(userOrGroupId);
        for (integer lastSize=-1;lastSize<userOrGroupIds.size();)
        {
            lastSize = userOrGroupIds.size();
            for (groupmember gm :
            [
                select groupid
                from groupmember
                where UserOrGroupId in: toList(userOrGroupIds)
            ])
            {
                userOrGroupIds.add(gm.groupid);
            }
            if (directOnly) break;
        }
        return
        [
            select id, name, developername, type
            from group
            where id in:PBS_gBUILD_Utility.toList(userOrGroupIds)
            order by name, developername
        ];
    }

    //returns map of group id to user id list
    public static map<string, List<string>> GetGroupMemberIds(List<string> groupIds, boolean directOnly)
    {
        integer z=0;
        showDebugMessage(string.format('GetGroupMemberIds=[{0}]', new string[]{format(groupIds, ', ')}));
        map<string, list<string>> userIdsByGroupId = new map<string, list<string>>();
        set<string> query = new set<string>();
        query.addAll(groupIds);
        for (integer lastSize=-1;lastSize<userIdsByGroupId.size();)
        {
            lastSize = userIdsByGroupId.size();
            groupmember[] gms =
            [
                select groupId, UserOrGroupId
                from groupmember
                where GroupId in:ToList(query)
            ];
            query.clear();
            for (groupmember gm : gms)
            {
                if (!userIdsByGroupId.containsKey(gm.GroupId))
                {
                    userIdsByGroupId.put(gm.GroupId, new list<string>());
                }
                query.add(gm.UserOrGroupId);
                userIdsByGroupId.get(gm.GroupId).add(gm.UserOrGroupId);
                showDebugMessage(string.format('...{2}...GetGroupMemberIds(loop) groupId={0} userId={1}', new string[]{gm.groupId, gm.UserOrGroupId, z.format()}));
            }
            if (directOnly) break;
            ++z;
        }
        return userIdsByGroupId;
    }

    public static User[] GetGroupMembers(List<string> groupId, boolean directOnly)
    {
        set<string> ids = new set<string>();
        for (List<string> z : GetGroupMemberIds(groupId, directOnly).values())
        {
            ids.addAll(z);
        }
        return
        [
            select id, username, firstname, lastname, name, email, usertype
            from user
            where id in:ToList(ids)
            order by name
        ];
    }

    //Test methods for private items
    public static testMethod void testMult()
    {
        system.assertEquals(0, mult(0,-1));
        system.assertEquals(0, mult(-1,0));
        system.assertEquals(0, mult(0,1));
        system.assertEquals(0, mult(1,0));
        system.assertEquals(0, mult(0,0));
        system.assertEquals(0, mult(null,-1));
        system.assertEquals(0, mult(-1,null));
        system.assertEquals(0, mult(null,1));
        system.assertEquals(0, mult(1,null));
        system.assertEquals(0, mult(0,null));
        system.assertEquals(6, mult(2,3));
    }

    public static testMethod void testFirstWithValue()
    {
        decimal d1 = decimal.valueOf(1);
        decimal d2 = decimal.valueOf(2);
        decimal d3 = decimal.valueOf(3);
        system.assertEquals(d1, PBS_gBUILD_Utility.firstWithValue(d1,d2,d3));
        system.assertEquals(d2, PBS_gBUILD_Utility.firstWithValue(null,d2,d3));
        system.assertEquals(d3, PBS_gBUILD_Utility.firstWithValue(null,null,d3));
    }

/*
    public static List<string> GetGroupMemberIds(List<string> groupId, boolean directOnly)
    {
        integer z=0;
        showDebugMessage(string.format('GetGroupMemberIds=[{0}]', new string[]{format(groupId, ', ')}));
        set<string> userIds = new set<string>();
        userIds.addAll(groupId);
        for (integer lastSize=-1;lastSize<userIds.size();)
        {
            lastSize = userIds.size();
            for (groupmember gm :
            [
                select groupId, UserOrGroupId
                from groupmember
                where GroupId in: toList(userIds)
            ])
            {
                userIds.add(gm.UserOrGroupId);
                showDebugMessage(string.format('...{2}...GetGroupMemberIds(loop) groupId={0} userId={1}', new string[]{gm.groupId, gm.UserOrGroupId, z.format()}));
            }
            if (directOnly) break;
            ++z;
        }
        showDebugMessage(string.format('...GetGroupMemberIds(seek) userIds=[{0}]', new string[]{format(toList(userIds), ', ')}));
        return toList(userIds);
    }

    public static User[] GetGroupMembers(List<string> groupId, boolean directOnly)
    {
        return
        [
            select id, username, firstname, lastname, name, email, usertype
            from user
            where id in:GetGroupMemberIds(groupId, directOnly)
            order by name
        ];
    }
*/
}