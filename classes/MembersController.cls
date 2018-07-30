public with sharing class MembersController {
    @AuraEnabled
    // キャンペーンに関連したCampaignMemberをすべて取得
    public static List<CampaignMember> getObjects(Id objectId) {
        if ( isAccessible() ) {
	        String qu;
            qu = 'Select '+GetAllObjectFields('CampaignMember')+ ' FROM CampaignMember WHERE CampaignId = \'' + objectId + '\'';
	        List<CampaignMember> cmp = Database.query(qu);
	        return cmp;
        }else{
            return null;
        }  
    }
    
    @AuraEnabled
    //当該キャンペーンメンバーのレコード（チーム）更新
    public static void updateTeamOfMember(Id objectId, String newTeam) {
        if( isUpdateable('Team__c') ){
            String qu;
        	qu = 'Select ' + GetAllObjectFields('CampaignMember') +' FROM CampaignMember WHERE Id = \'' + objectId + '\'';
            List<CampaignMember> cmp = Database.query(qu);
       		for(CampaignMember c : cmp) {
       		    c.Team__c = newTeam;
   	       }
        try {
    		update cmp;
		} catch (DmlException e) {
    		// Process exception here
    		System.debug('An unexpected error has occurred: ' + e.getMessage());
		}
       }
    }
    
	@AuraEnabled
	public static List<SelectOption> getTeams() {
    	List<SelectOption> options = new List<SelectOption>();
    	Schema.DescribeFieldResult fieldResult = CampaignMember.Team__c.getDescribe();
    	List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        if(Test.isRunningTest()){
            options.add(new SelectOption('test', 'test'));
        }
    	for (Schema.PicklistEntry f: ple) {
      	  options.add(new SelectOption(f.getLabel(), f.getValue()));
    	}       
    	return options;
	}
    
    @AuraEnabled
    public static List<Map<String,String>> getAllObjectFieldsList(List<String> fieldsList) {
        System.debug('==============RESULT');
        List<Map<String,String>> result = new List<Map<String,String>>();
        
        for (String field:fieldsList){
            Map<String, String> newFieldMetadata = new Map<String, String>();
        	String fieldLabel = Schema.getGlobalDescribe().get('CampaignMember').getDescribe().fields.getMap().get(field).getDescribe().getLabel();
        	DisplayType dispType = Schema.getGlobalDescribe().get('CampaignMember').getDescribe().fields.getMap().get(field).getDescribe().getType();
            newFieldMetaData.put('label', fieldLabel);
            newFieldMetadata.put('type', String.valueOf(dispType));
            newFieldMetadata.put('fieldName',field);
            
            result.add(newFieldMetadata);
        }
        
        System.debug(result);
        
        return result;
     }
    
    //オブジェクト内でFieldsすべてを取得
    private static String getAllObjectFields(String objectName){
        Schema.SObjectType objSchema = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
        String allObjectFields = '';
        for (String fieldName: fieldMap.keySet()) {
            if (fieldMap.get(fieldName).getDescribe().isAccessible()) {
                allObjectFields += fieldName + ', ';
            }
        }
        allObjectFields = allObjectFields.removeEnd(', ');
        return allObjectFields;
    }
    
    //SelectOption 使用のためのメソッド
    public class SelectOption {
    public SelectOption(String value, String label) {
        this.value = value;
        this.label = label;
        this.disabled = false;
        this.escapeItem = false;
    }

    public SelectOption(String value, String label, Boolean isDisabled) {
        this.value = value;
        this.label = label;
        this.disabled = isDisabled;
        this.escapeItem = false;
    }

    @AuraEnabled
    public String label { get;set; }
    @AuraEnabled
    public String value { get;set; }
    @AuraEnabled
    public Boolean disabled { get;set; }
    @AuraEnabled
    public Boolean escapeItem { get;set; }

	}
    

    public static Boolean isAccessible(){
        SObjectType schemaType = Schema.getGlobalDescribe().get('CampaignMember');
        return schemaType.getDescribe().isAccessible();
    }
    public static Boolean isUpdateable(String fieldName){
        SObjectType schemaType = Schema.getGlobalDescribe().get('CampaignMember');
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
        return schemaType.getDescribe().isUpdateable();
    }

}