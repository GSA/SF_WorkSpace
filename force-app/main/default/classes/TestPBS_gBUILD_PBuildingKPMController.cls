@isTest(SeeAllData=false)
public class TestPBS_gBUILD_PBuildingKPMController
{  
    private static final TestPBS_gBUILD_Utility.TestData td;

    static 
    {
        TestPBS_gBUILD_Utility.setup();
        td = new TestPBS_gBUILD_Utility.TestData();
    }

    private static void SetupPbsProject(PBS_gBUILD_ProjectBuilding__c pb)
    {
        PBS_gBUILD_Project__c gProject = [select Projectid__c, SubstantiallyCompleteDate__c from PBS_gBUILD_Project__c where id=:pb.Rahd_ProjectParentId__c];
        gProject.SubstantiallyCompleteDate__c = date.parse('11/1/2004');
        
        update gProject;
        PBS_Project__c pbsProject = [select id, numDesignPlanYear__c from PBS_Project__c where id=:gProject.Projectid__c];
        pbsProject.numDesignPlanYear__c = '03';
        update pbsProject;

        
        string rtAnnual = PBS_gBUILD_Utility.getRecordTypeId('PBS_EuasPerformance__c', 'Annual_Performance');
        string rtMonthly = PBS_gBUILD_Utility.getRecordTypeId('PBS_EuasPerformance__c', 'Monthly_Performance');

        insert new PBS_EuasPerformance__c[]
        {
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2002, WaterAmt__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2003, WaterAmt__c=2),
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2004, WaterAmt__c=3),
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2005, WaterAmt__c=4),
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2006, WaterAmt__c=5),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2002, WaterAmt__c=1, FiscalMonth__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2003, WaterAmt__c=2, FiscalMonth__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2004, WaterAmt__c=3, FiscalMonth__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2005, WaterAmt__c=4, FiscalMonth__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2006, WaterAmt__c=5, FiscalMonth__c=1)
        };

        test.startTest();
    }
    
    private static void SetupPbsProject2(PBS_gBUILD_ProjectBuilding__c pb)
    {
        PBS_gBUILD_Project__c gProject = [select Projectid__c, SubstantiallyCompleteDate__c from PBS_gBUILD_Project__c where id=:pb.Rahd_ProjectParentId__c];
        gProject.SubstantiallyCompleteDate__c = date.parse('10/1/2004');
        
        update gProject;
        PBS_Project__c pbsProject = [select id, numDesignPlanYear__c from PBS_Project__c where id=:gProject.Projectid__c];
        pbsProject.numDesignPlanYear__c = '03';
        update pbsProject;
        
        string rtAnnual = PBS_gBUILD_Utility.getRecordTypeId('PBS_EuasPerformance__c', 'Annual_Performance');
        string rtMonthly = PBS_gBUILD_Utility.getRecordTypeId('PBS_EuasPerformance__c', 'Monthly_Performance');

        insert new PBS_EuasPerformance__c[]
        {
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2002, WaterAmt__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2003, WaterAmt__c=2),
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2004, WaterAmt__c=3),
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2005, WaterAmt__c=4),
            new PBS_EuasPerformance__c(RecordTypeId=rtAnnual,  BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2006, WaterAmt__c=5),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2002, WaterAmt__c=1, FiscalMonth__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2003, WaterAmt__c=2, FiscalMonth__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2004, WaterAmt__c=3, FiscalMonth__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2005, WaterAmt__c=4, FiscalMonth__c=1),
            new PBS_EuasPerformance__c(RecordTypeId=rtMonthly, BuildingId__c=pb.BldgId__c, BuildingFacilityCode__c='123', FiscalYear__c=2006, WaterAmt__c=5, FiscalMonth__c=1)
        };

        test.startTest();
    }

    public static testMethod void testConstructor()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        SetupPbsProject(pb);

        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingKPMController ctrl = new PBS_gBUILD_PBuildingKPMController();
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        ctrl.save();

        ctrl.engagedInWasteWasteMaterialsMgmt=PBS_gBUILD_Utility.yesNoNaTypeYes;
        system.assertEquals(PBS_gBUILD_Utility.yesNoNaTypeYes, ctrl.engagedInWasteWasteMaterialsMgmt);
        ctrl.engagedInWasteWasteMaterialsMgmt=PBS_gBUILD_Utility.yesNoNaTypeNo;
        system.assertEquals(PBS_gBUILD_Utility.yesNoNaTypeNo, ctrl.engagedInWasteWasteMaterialsMgmt);

        ctrl.actionId = 'id';
        system.assert(ctrl.openEuasItem()!=null);

        ctrl.edit();
        ctrl.cancel();
    }

    public static testMethod void testConstructor2()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        SetupPbsProject(pb);

        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingKPMController ctrl = new PBS_gBUILD_PBuildingKPMController();
        ctrl.perffutIsEuasReferenceYearRep='Yes';
        ctrl.fiscalYearValue = '2006';
        pb.PerffutIsEuasReferenceYearRep__c = 'Yes';
        system.assert(ctrl!=null);
        system.assertEquals(null, ctrl.projectIdBaseControllerException);
        ctrl.save();

        ctrl.engagedInWasteWasteMaterialsMgmt=PBS_gBUILD_Utility.yesNoNaTypeYes;
        system.assertEquals(PBS_gBUILD_Utility.yesNoNaTypeYes, ctrl.engagedInWasteWasteMaterialsMgmt);
        ctrl.engagedInWasteWasteMaterialsMgmt=PBS_gBUILD_Utility.yesNoNaTypeNo;
        system.assertEquals(PBS_gBUILD_Utility.yesNoNaTypeNo, ctrl.engagedInWasteWasteMaterialsMgmt);

        ctrl.actionId = 'id';
        system.assert(ctrl.openEuasItem()!=null);

        ctrl.edit();
        ctrl.cancel();
    }
    
    public static testMethod void testUtilitySavingsTypeImpactBuilding()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        SetupPbsProject(pb);

        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingKPMController ctrl = new PBS_gBUILD_PBuildingKPMController();

        ctrl.utilitySavingsContext=PBS_gBUILD_Utility.utilitySavingsTypeImpactBuilding;
        system.assert(!ctrl.showUtilitySavingsTypeImpactScope);
        system.assert(ctrl.showUtilitySavingsTypeImpactBuilding);
        system.assert(!ctrl.showUtilitySavingsTypePerformanceBuilding);
        ctrl.savingsContextRadioChanged();
        system.assert(ctrl.utilitySavingsItems.size()>0);
    }
    public static testMethod void testUtilitySavingsTypeImpactBuilding2()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        SetupPbsProject2(pb);

        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingKPMController ctrl = new PBS_gBUILD_PBuildingKPMController();

        ctrl.utilitySavingsContext=PBS_gBUILD_Utility.utilitySavingsTypeImpactBuilding;
        system.assert(!ctrl.showUtilitySavingsTypeImpactScope);
        system.assert(ctrl.showUtilitySavingsTypeImpactBuilding);
        system.assert(!ctrl.showUtilitySavingsTypePerformanceBuilding);
        ctrl.savingsContextRadioChanged();
        system.assert(ctrl.utilitySavingsItems.size()>0);
    }

    public static testMethod void testUtilitySavingsTypePerformanceBuilding()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        SetupPbsProject(pb);

        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingKPMController ctrl = new PBS_gBUILD_PBuildingKPMController();

        ctrl.utilitySavingsContext=PBS_gBUILD_Utility.utilitySavingsTypePerformanceBuilding;
        system.assert(!ctrl.showUtilitySavingsTypeImpactScope);
        system.assert(!ctrl.showUtilitySavingsTypeImpactBuilding);
        system.assert(ctrl.showUtilitySavingsTypePerformanceBuilding);
        ctrl.savingsContextRadioChanged();
        system.assertEquals(0, ctrl.utilitySavingsItems.size());
    }
    
    public static testMethod void testUtilitySavingsTypeImpactScope()
    {
        PBS_gBUILD_ProjectBuilding__c pb = td.createGbProjectBuildingOnPbsProjectEpm1();
        SetupPbsProject(pb);

        TestPBS_gBUILD_Utility.setCurrentPageProjectBuildingReference(pb.id);

        PBS_gBUILD_PBuildingScopeSystem__c ss;
        ss = new PBS_gBUILD_PBuildingScopeSystem__c();
        ss.Rahd_ProjectBldgParentId__c = pb.id;
        ss.RecordTypeId = PBS_gBUILD_Utility.getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c', 'ARRA_ECM');
        insert ss;
        ss = new PBS_gBUILD_PBuildingScopeSystem__c();
        ss.Rahd_ProjectBldgParentId__c = pb.id;
        ss.RecordTypeId = PBS_gBUILD_Utility.getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c', 'Wind_NewInstallationOrTurbines');
        insert ss;
        ss = [select id, UtilitySav__c, ActualUtilitySav__c from PBS_gBUILD_PBuildingScopeSystem__c where id=:ss.id];
        system.assert(ss.UtilitySav__c!=null);
        system.assert(ss.ActualUtilitySav__c!=null);
        

        PBS_gBUILD_PBuildingKPMController ctrl = new PBS_gBUILD_PBuildingKPMController();

        ctrl.utilitySavingsContext=PBS_gBUILD_Utility.utilitySavingsTypeImpactScope;
        system.assert(ctrl.showUtilitySavingsTypeImpactScope);
        system.assert(!ctrl.showUtilitySavingsTypeImpactBuilding);
        system.assert(!ctrl.showUtilitySavingsTypePerformanceBuilding);
        ctrl.savingsContextRadioChanged();
        system.assert(ctrl.pb.PerffutUtilitySav__c!=null);
        system.assert(ctrl.pb.ActualUtilitySav__c!=null);
        system.assert(ctrl.utilitySavingsItems.size()>0);

        ctrl.actionId = ctrl.utilitySavingsItems.get(0).anticipated.id;
        ctrl.actionContextName = 'zzz';
        system.assert(ctrl.openUtilitySavingsItem()!=null);
    }
}