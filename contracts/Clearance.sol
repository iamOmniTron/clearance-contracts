// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.19 <0.9.0;


contract Clearance{
    
    struct Stage{
        uint id;
        string name;
        uint prevId;
    }

    struct User{
        uint id;
        uint stageId;
        bool completedAction;
    }

    Stage [] public StagesList;
    User [] public UsersList;
    mapping(uint=>User) Users;
    mapping(uint=>Stage) Stages;


    function addUser(uint _uid,uint _stageId) public {
        User memory u = User(_uid,_stageId,false);
        UsersList.push(u);
        Users[_uid] = u;
    }

    function addStage(uint _sid,string memory _name, uint _prevId) public{
        Stage memory s = Stage(_sid,_name,_prevId);
        StagesList.push(s);
        Stages[_sid] = s;
    }

    function getStages() public view returns (Stage [] memory){
        return StagesList;
    }

    function getUsers() public view returns (User [] memory){
        return UsersList;
    }

    function proceedUser(uint _uid) public {
        require(Users[_uid].id > 0,"Invalid User");
        require(Users[_uid].completedAction == true,"User hasn't uploaded document/form");
        Stage memory s = Stages[Users[_uid].stageId];
        for (uint i = 0; i < StagesList.length; i +=1){
            if(StagesList[i].prevId == s.id){
                Users[_uid].stageId = StagesList[i].id;
                Users[_uid].completedAction = false;

                for (uint j = 0; j < UsersList.length; j +=1){
                    if(UsersList[j].id == _uid){
                        UsersList[j].stageId = StagesList[i].id;
                         UsersList[j].completedAction = false;
                        break;
                    }
                }
                break;
            }
        }
    }

    function revertUser(uint _uid) public{
        require(Users[_uid].id > 0,"Invalid User");
        Stage memory s = Stages[Users[_uid].stageId];
        if(s.prevId < 1){
            return ;
        }
        Users[_uid].stageId = s.prevId;
        Users[_uid].completedAction = false;
        
         for (uint j = 0; j < UsersList.length; j +=1){
            if(UsersList[j].id == _uid){
                UsersList[j].stageId = s.prevId;
                    UsersList[j].completedAction = false;
                break;
            }
        }
    }

    function updateAction(uint _uid) public{
        require(Users[_uid].id > 0,"Invalid User");
        Users[_uid].completedAction = true;

        for (uint j = 0; j < UsersList.length; j +=1){
            if(UsersList[j].id == _uid){
                    UsersList[j].completedAction = true;
                break;
            }
        }
    }


    function deleteStage(uint _sid) public{
        uint index = 0;
        for (uint i = 0; i < StagesList.length; i +=1){
            if(StagesList[i].id == _sid){
                index = i;
                break;
            }
        }
        require(index >= 0,"Invalid Stage");
        require(index < StagesList.length,"Stage Out of bond");
        if(index != StagesList.length -1){
            StagesList[index] = StagesList[StagesList.length -1];
        }
        StagesList.pop();
    }

     function deleteUser(uint _uid) public{
         uint index = 0;
        for (uint i = 0; i < UsersList.length; i +=1){
            if(UsersList[i].id == _uid){
                index = i;
                break;
            }
        }
        require(index >= 0,"Invalid User");
        require(index < UsersList.length,"User Out of bond");
        if(index != UsersList.length -1){
            UsersList[index] = UsersList[UsersList.length -1];
        }
        UsersList.pop();
    }

}
