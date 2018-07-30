/**
 * TestClass : MembersControllerTest
 */
@isTest
private class MembersControllerTest {
    /**
	 * TestMethod : myTest
	 */
	@testSetup private static void myTest() {
        //キャンペーン
        Campaign campaign_1 = new Campaign(
          Name = 'TESTESTESTSummer Camp--2018-08-15-3Days',
          IsActive = true
        );
        insert campaign_1;
        
        //リード
        Lead lead_1 = new Lead(
          LastName = 'Monaco',
            Company = 'SAMPLE'
        );
        insert lead_1;
        
        //キャンペーンメンバー
        CampaignMember campaignMember_1 = new CampaignMember(
          CampaignId = campaign_1.Id,
          LeadId = lead_1.Id
        );
        insert campaignMember_1;
    }
    
    
    @isTest private static void getObjectNormalTest() {
        //prepare user
	    User u1 = createUser('tttttttt1');
        //execute and assert
    	System.runAs(u1){
	        Test.startTest();
			Campaign campaign_1_2 = [SELECT Id FROM Campaign WHERE Name = 'TESTESTESTSummer Camp--2018-08-15-3Days'];
	        CampaignMember campaignMember_1_2 = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaign_1_2.Id];        
	        List<CampaignMember> result = MembersController.getObjects(campaign_1_2.Id);
        
        
	        System.assertEquals(1, result.size());
	        System.assertEquals(campaignMember_1_2.Id, result[0].Id);
	        Test.stopTest();
    	}
    }
        
    @isTest static void testTeamOptions() {
        User u2 = createUser('tttttttt2');

        System.runAs(u2){
	        Test.startTest();
	        List<MembersController.SelectOption> results = MembersController.getTeams();
	        Test.stopTest();

	        system.assertEquals('test',results.get(0).value);
	        system.assertEquals('test',results.get(0).label);
        }
    }
    
    @isTest static void getAllObjectFieldsListTest() {
        User u3 = createUser('tttttttt3');
        System.runAs(u3){
            Test.startTest();
            List<String> fieldsList = new List<String>();
            fieldsList.add('id');
            List<Map<String,String>> results = MembersController.getAllObjectFieldsList(fieldsList);
            
            Test.stopTest();
            system.assertEquals(1,results.size());
            system.assertEquals('id', results[0].get('fieldName'));
        }
    }

    
    @isTest private static void updateTeamOfMemberTest() {
        User u3 = createUser('tttttttt3');
        Campaign campaign_1_2 = [SELECT Id FROM Campaign WHERE Name = 'TESTESTESTSummer Camp--2018-08-15-3Days'];
        CampaignMember campaignMember_1_2 = [SELECT Id FROM CampaignMember WHERE CampaignId = :campaign_1_2.Id];
        System.runAs(u3){
	        Test.startTest();
	        MembersController.updateTeamOfMember(campaignMember_1_2.Id,'A');
	        Test.stopTest();
        
        	CampaignMember campaignMember_after = [SELECT Id,Team__c FROM CampaignMember WHERE Id = :campaignMember_1_2.Id];
        	System.assertEquals('A',campaignMember_after.Team__c);
        }
    }
        
    /*
 * create a test user
 *  name: firstName
 */
public static User createUser(String name){
    Profile profile = getStandardProfile();
    String profileId = profile.id;

    User user = new User();
    user.Email = name + 'test@xx.xxx.com';
    user.UserName = name + 'test@xx.xxx.com';
    user.FirstName = name;
    user.LastName = '123';
    user.Alias = user.UserName.split('@')[0].left(8);
    user.ProfileId = profileId;
    //user.UserRoleId = role.Id;
    user.EmailEncodingKey = 'ISO-2022-JP';
    user.LanguageLocaleKey = 'ja';
    user.LocaleSidKey = 'ja_JP';
    user.TimeZoneSidKey = 'Asia/Tokyo';
    insert user;
    user = [select Name, UserName, FirstName, LastName, Alias, UserRoleId, ProfileId, CreatedDate from user where UserName = :user.Username limit 1];

    return user;
 }
    
/*
 * get Profile of standard user
 */ 
public static Profile getStandardProfile(){
    Profile[] profiles;
    profiles =  [select Id From Profile where Name = 'System Administrator' limit 1];
    if (profiles.isEmpty()){
       profiles =  [select Id From Profile where Name = 'システム管理者' limit 1];
    }
    return profiles[0];
}
    
}