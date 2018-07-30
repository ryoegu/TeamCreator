({
	getMembersList : function(component,params) {
    var action = component.get('c.getObjects');
    action.setParams(params);
    var self = this;
    action.setCallback(this, function(response) {
    var state = response.getState();
    if(component.isValid() && state === "SUCCESS") {
        var result = response.getReturnValue();

        var myObjectMap = [];
        for(var i=0; i<result.length; i++) {
            var myRecord = result[i];
            myRecord = this.toLowerCaseKeys(myRecord);
            var myKey = myRecord.team__c;
            var found = false;
            for(var x=0; x<myObjectMap.length; x++) {
                if("key" in myObjectMap[x] && myObjectMap[x]["key"] == myKey) {
                    myObjectMap[x]["list"].push(myRecord);
                    found = true;
                    break;
                }
            }

            if(!found) {
                var temp = { "key": myKey, "list": [myRecord] };
                myObjectMap.push(temp);
            }
        }
        console.log(myObjectMap);
        this.object_array_sort(myObjectMap, 'key', component.get("v.listAsc"), function(new_data){
		    //ソート後の処理
        	component.set('v.members', new_data);
	        console.log(new_data);
		    
		});

        /*
        [
            {
                "key": "A"
                , "list": [
                    {
                        
                    }
                ]
            }
            , {
                "key": "B"
                , "list": [
                    {

                    }
                ]
            }
        ];

        */
    }
});
    $A.enqueueAction(action);
  },
    getCampaignMemberObjectFields: function(component) {

        var action = component.get('c.getAllObjectFieldsList');
        
        var field1 = component.get("v.fields1");
        var field2 = component.get("v.fields2");
        var field3 = component.get("v.fields3");
        var fieldsList = [field1,field2,field3];
        action.setParams({
            'fieldsList': fieldsList
        });
        var self = this;
        
    	action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set('v.columns',response.getReturnValue());
	    });
    	$A.enqueueAction(action);    
    },
    setCampaignMember: function(component,params) {
        var action = component.get('c.updateTeamOfMember');
        action.setParams(params);
        var self = this;
        action.setCallback(this, function(){
        });
        $A.enqueueAction(action);
    },
    
    getTeamsList: function(component) {
        var action = component.get('c.getTeams');
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.teams', actionResult.getReturnValue());
            console.log('==================');
            console.log(actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    object_array_sort: function(data,key,order,fn) {
        //デフォは降順(DESC)
    var num_a = -1;
    var num_b = 1;

    if(order === 'asc'){//指定があれば昇順(ASC)
      num_a = 1;
      num_b = -1;
    }

   data = data.sort(function(a, b){
      var x = a[key];
      var y = b[key];
      if (x > y) return num_a;
      if (x < y) return num_b;
      return 0;
    });

   fn(data); // ソート後の配列を返す
    },
    
    toLowerCaseKeys: function(obj) {
        var newobj = [];
        for (var key in obj) {
            newobj[key.toLowerCase()] = obj[key];
        }
        return newobj;
	}
})