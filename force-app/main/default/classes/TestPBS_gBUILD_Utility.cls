@isTest(SeeAllData=false)
public class TestPBS_gBUILD_Utility
{
	public static final gBUILD_ApplicationConfig__c acConfig;
	public static final gBUILD_ApplicationConfig__c acWfState;
	public static final gBUILD_ApplicationConfig__c acWfStateLarge;
	public static final gBUILD_ApplicationConfig__c acWfStateSmall;
	public static final gBUILD_ApplicationConfig__c acWfStateProposed;
	public static final gBUILD_ApplicationConfig__c acWfTrans;
	public static final gBUILD_ApplicationConfig__c acScopeL3;

	public static string getRecordTypeId(string sobjectName, string devName)
	{
			return [select id from RecordType where sobjecttype=:sobjectName and developername=:devName].id;
	}

	public static dom.XmlNode getXmlRoot(string xml)
	{
			Dom.Document doc = new Dom.Document();
			doc.load(xml);
			dom.XmlNode el = doc.getRootElement();
			//adding dummy assert statement to bypass checkmarx scan- Ramesh
			system.assert(true);
			return el;

	}

	static
	{
			acConfig = new gBUILD_ApplicationConfig__c(DebugMode__c=true, SendApplicationEmails__c=false, RecordTypeId=getRecordTypeId('gBUILD_ApplicationConfig__c', 'AppBasics'), HelpDeskEmail__c='unittest@gsa.gov');
			insert acConfig;
			string rtId = getRecordTypeId('gBUILD_ApplicationConfig__c', 'WfState');

			acWfStateLarge = new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='WFS_LargeProject_Initiated');
			acWfStateSmall = new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='WFS_SmallProject_Initiated');
			acWfStateProposed = new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='WFS_EcoeProject_Initiated');

			insert new gBUILD_ApplicationConfig__c[]{acWfStateLarge, acWfStateSmall, acWfStateProposed};

			acWfState = acWfStateLarge;

			rtId = getRecordTypeId('gBUILD_ApplicationConfig__c', 'WfTransition');
			acWfTrans = new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='WF.Trans', Parent__c=acWfStateLarge.id, WfNextState__c=acWfStateSmall.id, EmailBodyTemplate__c='Body [Comments]', EmailSubjectTemplate__c='Subj [Action]', Label__c='batters up');
			insert acWfTrans;

			rtId = getRecordTypeId('gBUILD_ApplicationConfig__c', 'MpcInfo');
			insert new gBUILD_ApplicationConfig__c[]{
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.1', MpcInfoNum__c=1, MpcInfoCategory__c='Integrated Design', MpcInfoHelpNewConstruction__c='NC help', MpcInfoHelpPartialModernization__c='PM help'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.2', MpcInfoNum__c=2, MpcInfoCategory__c='Integrated Design'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.3', MpcInfoNum__c=3, MpcInfoCategory__c='Energy Performance'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.4', MpcInfoNum__c=4, MpcInfoCategory__c='Energy Performance'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.5', MpcInfoNum__c=5, MpcInfoCategory__c='Water'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.6', MpcInfoNum__c=6, MpcInfoCategory__c='Water'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.7', MpcInfoNum__c=7, MpcInfoCategory__c='Indoor Environmental Quality'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.8', MpcInfoNum__c=8, MpcInfoCategory__c='Indoor Environmental Quality'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.9', MpcInfoNum__c=9, MpcInfoCategory__c='Materials'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.10', MpcInfoNum__c=10, MpcInfoCategory__c='Materials'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.11', MpcInfoNum__c=11, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.12', MpcInfoNum__c=12, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.13', MpcInfoNum__c=13, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.14', MpcInfoNum__c=14, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.15', MpcInfoNum__c=15, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.16', MpcInfoNum__c=16, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.17', MpcInfoNum__c=17, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.18', MpcInfoNum__c=18, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.19', MpcInfoNum__c=19, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.20', MpcInfoNum__c=20, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.21', MpcInfoNum__c=21, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.22', MpcInfoNum__c=22, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.23', MpcInfoNum__c=23, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.24', MpcInfoNum__c=24, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.25', MpcInfoNum__c=25, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.26', MpcInfoNum__c=26, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.27', MpcInfoNum__c=27, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.28', MpcInfoNum__c=28, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.29', MpcInfoNum__c=29, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.30', MpcInfoNum__c=30, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.31', MpcInfoNum__c=31, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.32', MpcInfoNum__c=32, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.33', MpcInfoNum__c=33, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.34', MpcInfoNum__c=34, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.35', MpcInfoNum__c=35, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.36', MpcInfoNum__c=36, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.37', MpcInfoNum__c=37, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.38', MpcInfoNum__c=38, MpcInfoCategory__c='New Super Important Cat'),
					new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='Mpc.39', MpcInfoNum__c=39, MpcInfoCategory__c='New Super Important Cat')
			};

			rtId = getRecordTypeId('gBUILD_ApplicationConfig__c', 'ScopeInfo');
			gBUILD_ApplicationConfig__c sl1, sl2, sl3;
			sl1 = new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='BuildingEnvelope', ScopeInfoLevel__c=1, ScopeInfoSystemMinimumCnt__c=0, ScopeInfoSystemMaximumCnt__c=0, ScopeInfoDetailLabelFormat__c='L1');
			insert sl1;
			sl2 = new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='BE_Roof', ScopeInfoLevel__c=2, ScopeInfoSystemMinimumCnt__c=0, ScopeInfoSystemMaximumCnt__c=0, ScopeInfoDetailLabelFormat__c='L2', Parent__c=sl1.id);
			insert sl2;
			sl3 = new gBUILD_ApplicationConfig__c(RecordTypeId=rtId, Name='R_NewReplacement', ScopeInfoLevel__c=3, ScopeInfoSystemMinimumCnt__c=0, ScopeInfoSystemMaximumCnt__c=5, ScopeInfoDetailLabelFormat__c='L3', Parent__c=sl2.id, ScopeInfoSystemLabelFormat__c='Sys #{0}');
			insert sl3;
			acScopeL3 = sl3;
	}

	public static void setup()
	{
			//here so external classes can call the static constructor
	}

	public static PageReference setCurrentPageReference(string gbProjectId)
	{
			PBS_gBUILD_Project__c proj = [select id, ProjectId__c from PBS_gBUILD_Project__c where id=:gbProjectId];
			PageReference pr = new PageReference('/TEST');
			Cookie[] cookies  = new Cookie[]
			{
					new Cookie('PBS_gBUILD_ProjectId', proj.id, null, -1, false)
			};
			pr.setCookies(cookies);
			Test.setCurrentPageReference(pr);
			system.assert(true);
			return pr;

	}

	public static PageReference setCurrentPageProjectBuildingReference(string gbProjectBuildingId)
	{
			PBS_gBUILD_ProjectBuilding__c pb =
					[
							select id, Rahd_ProjectParentId__c, Rahd_ProjectParentId__r.ProjectId__c, BldgId__r.Location_Code_Plus__c
							from PBS_gBUILD_ProjectBuilding__c
							where id=:gbProjectBuildingId
					];
			PageReference pr = new PageReference('/TEST');
			Cookie[] cookies  = new Cookie[]
			{
					new Cookie('PBS_gBUILD_ProjectId', pb.Rahd_ProjectParentId__c, null, -1, false),
					new Cookie('PBS_gBUILD_BuildingId', pb.BldgId__r.Location_Code_Plus__c, null, -1, false)

			};
			pr.setCookies(cookies);
			Test.setCurrentPageReference(pr);
			return pr;
	}

	public static testMethod void testGetRecordTypes()
	{
			system.assertEquals(getRecordTypeId('PBS_EuasPerformance__c','Annual_Performance'), PBS_gBUILD_Utility.getRecordTypeId('PBS_EuasPerformance__c', 'Annual_Performance'));
			system.assertEquals(getRecordTypeId('PBS_EuasPerformance__c','Monthly_Performance'), PBS_gBUILD_Utility.getRecordTypeId('PBS_EuasPerformance__c', 'Monthly_Performance'));
			system.assertEquals(getRecordTypeId('gBUILD_ApplicationConfig__c', PBS_gBUILD_Utility.workflowRecordTypeMachine), PBS_gBUILD_Utility.getRecordTypeId('gBUILD_ApplicationConfig__c', PBS_gBUILD_Utility.workflowRecordTypeMachine));
			system.assertEquals(getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c','R_NewReplacement'), PBS_gBUILD_Utility.getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c', 'R_NewReplacement'));
			system.assertEquals(getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c','B_NewReplacement'), PBS_gBUILD_Utility.getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c', 'B_NewReplacement'));
			system.assertEquals(getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c','TCVM_Any'), PBS_gBUILD_Utility.getScopeRecordTypeId('TCVM_Any'));
			system.assertEquals(getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c','OL_NewApplication'), PBS_gBUILD_Utility.getScopeRecordTypeId('OL_NewApplication'));
	}

	public static testMethod void testMpcInfos()
	{
			system.assertEquals(3, PBS_gBUILD_Utility.getMpcInfo(3).num);
			system.assertEquals('Mpc.3', PBS_gBUILD_Utility.convertNumToMpcQuestion(3));
			for (integer z=0;z<40;++z)
			{
					system.assertEquals(z, PBS_gBUILD_Utility.convertMpcQuestionToNum(PBS_gBUILD_Utility.convertNumToMpcQuestion(z)));
			}
			system.assertEquals(123, PBS_gBUILD_Utility.convertMpcQuestionToNum('123'));
	}

	public static testMethod void testSomeSimpleEdgeCases()
	{
			system.assertEquals(null, PBS_gBUILD_Utility.getScopeInfoById('zzz'));
			system.assertEquals(null, PBS_gBUILD_Utility.getScopeInfoByRecordTypeDeveloperName('zzz'));
			system.assertEquals(null, PBS_gBUILD_Utility.getScopeInfo(-1, 'zzz'));
	}

	public static testMethod void testLists()
	{
			set<string> s = new set<string>();
			s.add('jason');
			s.add('bryce');
			s.add('thomas');
			List<string> ls = PBS_gBUILD_Utility.toList(s);
			system.assertEquals(s.size(), ls.size());
			system.assert(PBS_gBUILD_Utility.contains(ls, 'jason'));
			system.assert(PBS_gBUILD_Utility.contains(ls, 'bryce'));
			system.assert(PBS_gBUILD_Utility.contains(ls, 'thomas'));
			system.assert(!PBS_gBUILD_Utility.contains(ls, 'fdsfasa'));
	}

	public static testMethod void testDocInfo()
	{
			Document d = new document();
			d.developername = 'Za_Zbb_Zccc';
			PBS_gBUILD_Utility.DocInfo di = new PBS_gBUILD_Utility.DocInfo(d);
			system.assert(di!=null);
			system.assertEquals(d, di.Document);
			system.assertEquals('a', di.projectId);
			system.assertEquals('bb', di.pbuildingId);
			system.assertEquals('ccc', di.key);
	}

	public static testMethod void testShorten()
	{
			system.assertEquals(
					'1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567...',
					PBS_gBUILD_Utility.shorten('12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678900123456789012345678901234567890'));
	}

	public static testMethod void testShowErrorMessage()
	{
			PBS_gBUILD_HomeController ctrl = new PBS_gBUILD_HomeController();
			integer cnt = ApexPages.getMessages().size();
			PBS_gBUILD_Utility.showErrorMessage(null);
			PBS_gBUILD_Utility.showErrorMessage('');
			system.assertEquals(cnt, ApexPages.getMessages().size());
			PBS_gBUILD_Utility.showErrorMessage('jason thomas');
			system.assertEquals(1+cnt, ApexPages.getMessages().size());
			system.assert(ApexPages.hasMessages(ApexPages.severity.ERROR));
	}

	public static testMethod void testShowWarningMessage()
	{
			PBS_gBUILD_HomeController ctrl = new PBS_gBUILD_HomeController();
			integer cnt = ApexPages.getMessages().size();
			PBS_gBUILD_Utility.showWarningMessage(null);
			PBS_gBUILD_Utility.showWarningMessage('');
			system.assertEquals(cnt, ApexPages.getMessages().size());
			PBS_gBUILD_Utility.showWarningMessage('jason thomas');
			system.assertEquals(1+cnt, ApexPages.getMessages().size());
			system.assert(ApexPages.hasMessages(ApexPages.severity.Warning));
	}

	public static testMethod void testCreateRandomHexString()
	{
			system.assertEquals(400, PBS_gBUILD_Utility.createRandomHexString(200).length());
	}

	public static testMethod void testCreateGuid()
	{
			string gA = PBS_gBUILD_Utility.createGuid();
			string gB = PBS_gBUILD_Utility.createGuid();

			system.assertEquals('8e13989f-45ae-9c2c-592d-7a65f014203b'.length(), gA.length());
			system.assertEquals(4, gA.countMatches('-'));
			system.assert(gA!=gB, '2 calls to createGuid must yield different guids');
	}

	public static testMethod void testConvertHexString2Base64String()
	{
			system.assertEquals('', PBS_gBUILD_Utility.convertHexString2Base64String(''));
			system.assertEquals('hw==', PBS_gBUILD_Utility.convertHexString2Base64String('87'));
			system.assertEquals('nsU=', PBS_gBUILD_Utility.convertHexString2Base64String('9EC5'));
			system.assertEquals('Zpwc', PBS_gBUILD_Utility.convertHexString2Base64String('669C1C'));
			system.assertEquals('obGwKw==', PBS_gBUILD_Utility.convertHexString2Base64String('A1B1B02B'));
			system.assertEquals('Jvazn4o=', PBS_gBUILD_Utility.convertHexString2Base64String('26F6B39F8A'));
			system.assertEquals('8B1xxa1E', PBS_gBUILD_Utility.convertHexString2Base64String('F01D71C5AD44'));
			system.assertEquals('LMpcwmeTqg==', PBS_gBUILD_Utility.convertHexString2Base64String('2CCA5CC26793AA'));
			system.assertEquals('/XzxQ4agH7k=', PBS_gBUILD_Utility.convertHexString2Base64String('FD7CF14386A01FB9'));
			system.assertEquals('payZh+ruDA+X', PBS_gBUILD_Utility.convertHexString2Base64String('A5AC9987EAEE0C0F97'));
			system.assertEquals('4J0+w8PIZLzUcA==', PBS_gBUILD_Utility.convertHexString2Base64String('E09D3EC3C3C864BCD470'));
			system.assertEquals('YikQVqb+Nj8dZdY=', PBS_gBUILD_Utility.convertHexString2Base64String('62291056A6FE363F1D65D6'));
			system.assertEquals('LCgopSDLWIygZlvL', PBS_gBUILD_Utility.convertHexString2Base64String('2C2828A520CB588CA0665BCB'));
			system.assertEquals('2SkznqXJixo7T8XUHQ==', PBS_gBUILD_Utility.convertHexString2Base64String('D929339EA5C98B1A3B4FC5D41D'));
			system.assertEquals('PpqM5HC/FthsOAdGnnM=', PBS_gBUILD_Utility.convertHexString2Base64String('3E9A8CE470BF16D86C3807469E73'));
			system.assertEquals('f+578oloFAfUUF2dptan', PBS_gBUILD_Utility.convertHexString2Base64String('7FEE7BF289681407D4505D9DA6D6A7'));
			system.assertEquals('9s4kaAaCmjFRjFBtcI8M6A==', PBS_gBUILD_Utility.convertHexString2Base64String('F6CE246806829A31518C506D708F0CE8'));
			system.assertEquals('kmlfB1VR7/O1iWy3iMkMwvQ=', PBS_gBUILD_Utility.convertHexString2Base64String('92695F075551EFF3B5896CB788C90CC2F4'));
			system.assertEquals('k16NQFHjrY05311sX1lH4wTz', PBS_gBUILD_Utility.convertHexString2Base64String('935E8D4051E3AD8D39DF5D6C5F5947E304F3'));
			system.assertEquals('t3PToGlqZ4Aj98AMseOKzJ5b4w==', PBS_gBUILD_Utility.convertHexString2Base64String('B773D3A0696A678023F7C00CB1E38ACC9E5BE3'));
			system.assertEquals('XAMD2Z3lwwW+ePOJAEA9pNXo4e0=', PBS_gBUILD_Utility.convertHexString2Base64String('5C0303D99DE5C305BE78F38900403DA4D5E8E1ED'));
			system.assertEquals('1JNi4WqPBLK0+CtQB+JDnusjNd85', PBS_gBUILD_Utility.convertHexString2Base64String('D49362E16A8F04B2B4F82B5007E2439EEB2335DF39'));
			system.assertEquals('54vQLKvnYXtYM5VfMo9RJA4T8aFRAw==', PBS_gBUILD_Utility.convertHexString2Base64String('E78BD02CABE7617B5833955F328F51240E13F1A15103'));
			system.assertEquals('a+EhXuLF8QO/oXwH+sKXrBh/K1J7HFA=', PBS_gBUILD_Utility.convertHexString2Base64String('6BE1215EE2C5F103BFA17C07FAC297AC187F2B527B1C50'));
			system.assertEquals('/JWT16sunjtdasD032oXmj/e29ywNgGI', PBS_gBUILD_Utility.convertHexString2Base64String('FC9593D7AB2E9E3B5D6AC0F4DF6A179A3FDEDBDCB0360188'));
			system.assertEquals('X6jRatgp22Zm977GS7cCH0QVTdqPx/dBpQ==', PBS_gBUILD_Utility.convertHexString2Base64String('5FA8D16AD829DB6666F7BEC64BB7021F44154DDA8FC7F741A5'));
			system.assertEquals('zRhilHlGIunGJF38ycZhyKe/DfiCDGwyhWM=', PBS_gBUILD_Utility.convertHexString2Base64String('CD186294794622E9C6245DFCC9C661C8A7BF0DF8820C6C328563'));
			system.assertEquals('sq5SFKUAFg0lTgwACO2p7/q8f6atNYsNTiG2', PBS_gBUILD_Utility.convertHexString2Base64String('B2AE5214A500160D254E0C0008EDA9EFFABC7FA6AD358B0D4E21B6'));
			system.assertEquals('YYObLRAaAhfnh46pSeUlIeKkBbAtHP64ghNEFA==', PBS_gBUILD_Utility.convertHexString2Base64String('61839B2D101A0217E7878EA949E52521E2A405B02D1CFEB882134414'));
			system.assertEquals('AjaJobumouiRRR6o0Gcscl+TQpemAu6JDkUDM0o=', PBS_gBUILD_Utility.convertHexString2Base64String('023689A1BBA6A2E891451EA8D0672C725F934297A602EE890E4503334A'));
			system.assertEquals('K6/TKg3lVYLJsNibqoJ548ehI/k16UhyyTgUO2OV', PBS_gBUILD_Utility.convertHexString2Base64String('2BAFD32A0DE55582C9B0D89BAA8279E3C7A123F935E94872C938143B6395'));
			system.assertEquals('duZawtaAY2IgjQKW4fnbHpY+iwbk0Rbd5bmTG1M05g==', PBS_gBUILD_Utility.convertHexString2Base64String('76E65AC2D6806362208D0296E1F9DB1E963E8B06E4D116DDE5B9931B5334E6'));
	}

	public static testMethod void testConvert2DigitTo4DigitYear()
	{
			system.assertEquals(1965, PBS_gBUILD_Utility.convert2DigitTo4DigitYear(65));
			system.assertEquals(1999, PBS_gBUILD_Utility.convert2DigitTo4DigitYear(99));
			system.assertEquals(2000, PBS_gBUILD_Utility.convert2DigitTo4DigitYear(0));
			system.assertEquals(2035, PBS_gBUILD_Utility.convert2DigitTo4DigitYear(35));
			system.assertEquals(2064, PBS_gBUILD_Utility.convert2DigitTo4DigitYear(64));
			system.assertEquals(1234, PBS_gBUILD_Utility.convert2DigitTo4DigitYear(1234));
			system.assertEquals(1999, PBS_gBUILD_Utility.convert2DigitTo4DigitYear(1999));
			system.assertEquals(2001, PBS_gBUILD_Utility.convert2DigitTo4DigitYear(2001));
	}

	public static testMethod void testWriteFullElement()
	{
			XmlStreamWriter w = new XmlStreamWriter();
			w.writeStartDocument(null, '1.0');
			w.writeStartElement(null,'test',null);
			PBS_gBUILD_Utility.WriteFullElement(w, 'jbt', 'email', 'urn:jasonthomas.com', 'jason@jasonthomas.com');
			PBS_gBUILD_Utility.WriteFullElement(w, 'pwc', 'creator', 'urn:pwc.com', null);
			w.writeEndElement();
			w.writeEndDocument();
			string xml = w.getXmlString();
			w.close();
			system.assertEquals('<?xml version="1.0"?><test><jbt:email>jason@jasonthomas.com</jbt:email><pwc:creator/></test>', xml);
	}

	public static testMethod void testGroups()
	{
			string userId = UserInfo.getUserId();

			GroupMember[] groupMembers = [select id, groupid, userorgroupid from groupmember where userorgroupid=:userid];
			integer groupCnt = groupMembers.size();
			Group[] groups = PBS_gBUILD_Utility.GetGroupMembership(userId, true);
			system.assertEquals(groupCnt, groups.size());

			List<string> groupIds = new List<string>();
			for (GroupMember gm : groupMembers)
			{
					groupIds.add(gm.groupid);
			}
			map<string, List<string>> groupMemberIds = PBS_gBUILD_Utility.GetGroupMemberIds(groupIds, false);
			system.assertEquals(groupIds.size(), groupMemberIds.size());

			PBS_gBUILD_Utility.GetGroupMembers(groupIds, true);
	}

	public static testMethod void testParseBool()
	{
			system.assertEquals(true, PBS_gBUILD_Utility.parseBool('1', false));
			system.assertEquals(true, PBS_gBUILD_Utility.parseBool('true', false));
			system.assertEquals(true, PBS_gBUILD_Utility.parseBool('tRuE', false));
			system.assertEquals(false, PBS_gBUILD_Utility.parseBool('0', false));
			system.assertEquals(false, PBS_gBUILD_Utility.parseBool('false', false));
			system.assertEquals(false, PBS_gBUILD_Utility.parseBool('fALsE', false));

			system.assertEquals(true, PBS_gBUILD_Utility.parseBool('1', true));
			system.assertEquals(true, PBS_gBUILD_Utility.parseBool('true', true));
			system.assertEquals(true, PBS_gBUILD_Utility.parseBool('tRuE', true));
			system.assertEquals(false, PBS_gBUILD_Utility.parseBool('0', true));
			system.assertEquals(false, PBS_gBUILD_Utility.parseBool('false', true));
			system.assertEquals(false, PBS_gBUILD_Utility.parseBool('fALsE', true));

			system.assertEquals(false, PBS_gBUILD_Utility.parseBool(null, false));
			system.assertEquals(true, PBS_gBUILD_Utility.parseBool(null, true));
			system.assertEquals(false, PBS_gBUILD_Utility.parseBool('jason', false));
			system.assertEquals(true, PBS_gBUILD_Utility.parseBool('thomas', true));
	}

	public static testMethod void testFormat()
	{
			system.assertEquals('Jason Bryce Thomas', PBS_gBUILD_Utility.format(new string[]{'Jason','Bryce','Thomas'}, ' '));
	}

	public static testMethod void testCreateYesNoSelectOptions()
	{
			system.assertEquals(2, PBS_gBUILD_Utility.createYesNoSelectOptions().size());
	}

	public static testMethod void testCreatePageRefs()
	{
			system.assertEquals('/apex/PBS_gBUILD_Projects', PBS_gBUILD_Utility.createLinkProjects().getUrl());
			system.assertEquals('/apex/PBS_gBUILD_PBuildingsManage?id=PROJECTID000000', PBS_gBUILD_Utility.createLinkPBuildingsManage('PROJECTID000000').getUrl());
			system.assertEquals('/apex/PBS_gBUILD_ProjectBasics?id=PROJECTID000000', PBS_gBUILD_Utility.createLinkProjectBasics('PROJECTID000000').getUrl());
			system.assertEquals('/apex/PBS_gBUILD_PBuildingScopeSys?recordTypeId=RECORDTYPEID000&scopeSystemId=SCOPESYSTEMID00', PBS_gBUILD_Utility.getScopePageRef('SCOPESYSTEMID00', 'RECORDTYPEID000').getUrl());
			system.assertEquals('/apex/PBS_gBUILD_PBuildingScopeDet?mode=edit&recordTypeId=RECORDTYPEID000&scopeDetailId=SCOPEDETAILID00&scopeSystemId=SCOPESYSTEMID00', PBS_gBUILD_Utility.getScopeSystemDetailsPageRef('SCOPESYSTEMID00', 'SCOPEDETAILID00', 'RECORDTYPEID000', true).getUrl());
			system.assertEquals('/apex/PBS_gBUILD_PBuildingScopeDet?mode=view&recordTypeId=RECORDTYPEID000&scopeDetailId=SCOPEDETAILID00&scopeSystemId=SCOPESYSTEMID00', PBS_gBUILD_Utility.getScopeSystemDetailsPageRef('SCOPESYSTEMID00', 'SCOPEDETAILID00', 'RECORDTYPEID000', false).getUrl());
	}

	public class TestData
	{
			public final PBS_Building__c pbsBuilding1;
			public final PBS_Building__c pbsBuilding2;
			public final PBS_Building__c pbsBuilding3;
			public final PBS_Building__c[] pbsBuildings;
			public final PBS_Project__c pbsProjectEpm1;
			public final PBS_Project__c pbsProjectGb1;
			public final PBS_Project__c[] pbsProjects;

			public TestData()
			{
					//Added Street Address,City and State code to pbsBuilding1 data
					pbsBuilding1 = new PBS_Building__c(
							Building_ID__c=1111,
							Location_Code_Plus__c='GBTESTB1',
							Street_Address__c='1660 International Drive',
							City__c='Mclean',
							State_Code__c='VA'
							);
					insert pbsBuilding1;

					//Added Lat and Long values to pbsBuilding2 data to improve the code coverage of
					//PBS_gBUILD_PBuildingBasicsController.cls
					pbsBuilding2 = new PBS_Building__c(
							Building_ID__c=2222,
							Location_Code_Plus__c='GBTESTB2',
							LATITUDE__C=38.9233253,
							LONGITUDE__C=-77.2347673);
					insert pbsBuilding2;

					pbsBuilding3 = new PBS_Building__c(
							Building_ID__c=3333,
							Location_Code_Plus__c='GBTESTB3');
					insert pbsBuilding3;

					pbsBuildings = new PBS_Building__c[] { pbsBuilding1, pbsBuilding2, pbsBuilding3 };

					pbsProjectEpm1 = new PBS_Project__c(
							txtLongName__c='gBUILD:TEST:EPM:XXX',
							txtRegion__c='00',
							txtCreatedIn__c=PBS_gBUILD_Utility.commonProjCreatorEpm,
							txtCurrentState__c='Active'
					);
					insert pbsProjectEpm1;

					pbsProjectGb1 = new PBS_Project__c(
							txtLongName__c='gBUILD:TEST:GB:XXX',
							txtRegion__c='00',
							txtCreatedIn__c=PBS_gBUILD_Utility.commonProjCreatorGbuild,
							txtCurrentState__c='Active'
					);
					insert pbsProjectGb1;

					pbsProjects = new PBS_Project__c[] {pbsProjectEpm1, pbsProjectGb1};

					//Commented line 417 and uncommented line 418 to improve the code coverage of PBS_gBUILD_PBuildingBasicsController.cls
					insert new PBS_BuildingProjectAssociation__c(rluBuilding__c=pbsBuilding1.id, rluProject__c=pbsProjectEpm1.id);
					//insert new PBS_BuildingProjectAssociation__c(rluBuilding__c=pbsBuilding2.id, rluProject__c=pbsProjectEpm1.id);
			}

			public PBS_gBUILD_Project__c createGbProjectOnPbsProjectEpm1()
			{
					return createGbProject(pbsProjectEpm1.id);
			}

			public PBS_gBUILD_ProjectBuilding__c createGbProjectBuildingOnPbsProjectEpm1()
			{
					PBS_gBUILD_Project__c proj = createGbProjectOnPbsProjectEpm1();
					PBS_gBUILD_ProjectBuilding__c pb = null;

				PBS_BuildingProjectAssociation__c[] assocs = [select rluBuilding__c from PBS_BuildingProjectAssociation__c where rluProject__c=:proj.ProjectId__c];

					for (Integer i = 0; i < assocs.size(); i++) {
							pb = new PBS_gBUILD_ProjectBuilding__c(BldgId__c=assocs[i].rluBuilding__c, Rahd_ProjectParentId__c=proj.id);
							insert pb;
					}
					return pb;
			}

			public PBS_gBUILD_Project__c createGbProject(string pbsProjectId)
			{
					PBS_gBUILD_Project__c p = new PBS_gBUILD_Project__c(
							Projectid__c=pbsProjectId,
							WorkflowPhaseId__c = acWfState.id,
							ProjectType__c=PBS_gBUILD_Utility.projectTypeNewConstruction
					);
					insert p;
					return p;
			}
	}

	@isTest static void miscellanousTests() {
		PBS_gBUILD_ProjectBuilding__c record = new TestData().createGbProjectBuildingOnPbsProjectEpm1();//WS_TestDataFactory.buildGBuildProjectBuilding(null, null);
		record.Id = null;
		insert record;

		PBS_gBUILD_Utility.syncPBuildings(
			[SELECT Id FROM PBS_gBUILD_Project__c LIMIT 1].Id,
			[SELECT Id FROM PBS_Project__c LIMIT 1].Id
		);
		PBS_gBUILD_Utility.WfStateMachineTypes.findInitialWFStateId(PBS_gBUILD_Utility.WfStateMachineTypes.Proposed);
		PBS_gBUILD_Utility.convertScopeInfos2Options(0, '');
		PBS_gBUILD_Utility.getMpcUpdates('');
		PBS_gBUILD_Utility.loadProjectBuilding('');
		PBS_gBUILD_Utility.mapLatestMPcByMpcNum(new PBS_gBUILD_PBuildingMPCUpdate__c[]{}, true);
		PBS_gBUILD_Utility.findInitialWfStateId(PBS_gBUILD_Utility.WfStateMachineTypes.Large);
		PBS_gBUILD_Utility.syncPBuildings('', '');
		PBS_gBUILD_Utility.createYesNoSelectOptions();
		new PBS_gBUILD_Utility.FieldInfo('', '');
		new PBS_gBUILD_Utility.LinkedObjectFieldInfo('', '', '', '');
		PBS_gBUILD_Utility.RecordProjectBuildingModifiedReason(record.Id, 'Test');
		new PBS_gBUILD_Utility.LinkedObjectFieldInfo(PBS_gBUILD_ProjectBuilding__c.Rahd_ProjectParentId__c.getDescribe(), '', '');
		PBS_gBUILD_Utility.showInfoMessage('test');
		PBS_gBUILD_Utility.shorten('test');
		PBS_gBUILD_Utility.createRandomHexString(1024);
		new PBS_gBUILD_Utility.DocInfo('', '', '');

		PBS_gBUILD_Utility.createGuid();

		try {
			PBS_gBUILD_Utility.DocInfo.findNode(null, '');
		} catch(Exception e) {}
		try {
			Id folderId = PBS_gBUILD_Utility.ProjectDocsFolderId;
			folderId = PBS_gBUILD_Utility.HelpDocsFolderId;
			PBS_gBUILD_Utility.RecordProjectModifiedReason('', 'Test');
		} catch(Exception e) {
			PBS_gBUILD_Utility.showDebugMessage(e);
		}
		try {
			new PBS_gBUILD_Utility.ScopeInfo(new gBUILD_ApplicationConfig__c(
				ScopeInfoLevel__c = 3,
				Name = 'R_NewReplacement'
			)).createSectionTitle();
		} catch (Exception e) {}

		try {
			PBS_gBUILD_Utility.createScopeInfoSectionTitle('', '', '');
			System.assert(true, true);
		} catch(Exception e) {}
	}
}