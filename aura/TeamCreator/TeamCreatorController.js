({
    doInit: function(component, event, helper) {
        helper.getCampaignMemberObjectFields(component);
        helper.getMembersList(component, {
            'objectId': component.get("v.recordId")
        });
        helper.getTeamsList(component);
    },
    handleDrag : function(cmp, event, helper) {
        cmp.set("v.draggedId", event.target.id);
    },
    allowDrop : function(cmp, event, helper) {
        event.preventDefault();
    },
    handleDrop : function(component, event, helper) {
        
        //チームカードに対してドラッグ&ドロップを有効化
//        var teamCard = component.find("can_drop");
//        teamCard.setAttribute("draggable","true");
	},
    handleEnd: function(component,event,helper) {
        var newTeam = event.currentTarget.dataset.team;
        console.log(newTeam);
        var srcId = component.get("v.draggedId");
        var allMembers = component.get("v.members");
        
        var draggingRow = [];

        //削除
        for(var i=0; i<allMembers.length; i++) {
            var teamMembers = allMembers[i]["list"];
            
            for(var j=0;j<teamMembers.length; j++) {
                var memberObj = teamMembers[j];
                if(memberObj["id"] == srcId) {
                    draggingRow = allMembers[i]["list"][j];
                    allMembers[i]["list"].splice(j,1);
                }
                
            }
        }
        
        var found = false;
        //挿入
        for(var i=0;i<allMembers.length; i++) {
            var teamLabel = allMembers[i]["key"];
            if (newTeam == teamLabel ) {
                //チームが振り分けられているもの
                allMembers[i]["list"].push(draggingRow);
                found = true;
                break;
            } else if (newTeam == null){
                //チームが振り分けられていないもの
                //配列が何番目か探す
                if (allMembers[i]["key"] == null) {
                  	allMembers[i]["list"].push(draggingRow);
                    found = true;
                    break;
                }
            }
        }
        
        if(!found) {
            var temp = { "key": newTeam, "list": [draggingRow] };
            allMembers.push(temp);
        }
        //更新
        console.log('---AllMembers Updated--');
        component.set('v.members', allMembers);
        console.log(allMembers);
        helper.setCampaignMember(component, {
            'objectId': srcId,
            'newTeam' : newTeam
        });
        
    }
})