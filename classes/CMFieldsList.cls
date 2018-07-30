global class CMFieldsList extends VisualEditor.DynamicPickList{
	global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('-', '-');
        return defaultValue;
    }
    
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        Schema.SObjectType objSchema = Schema.getGlobalDescribe().get('CampaignMember');
        Map<String, Schema.SObjectField> fieldMap = objSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
            if (fieldMap.get(fieldName).getDescribe().isAccessible()) {
                VisualEditor.DataRow value1 = new VisualEditor.DataRow(fieldLabel, fieldName);
		        myValues.addRow(value1);
            }
        }
        return myValues;
    }

    
}