// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract AdminConsole {
    event MemberAdded(address indexed whoAdded, address indexed wasAdded);
    event MemberRemoved(address indexed whoRemoved, address indexed wasRemoved);
    event FeeAccount(address indexed setBy, address indexed feeAccount);
    event FeePercent(address indexed setBy, uint indexed Percent);

    address public immutable i_owner;
    //address[] adminMembers;
    struct adminMember {
        address admin;
        bool _flag;
    }
    mapping(address => adminMember) adminMembers;
    address feeAccount;
    uint feePercent;

    constructor() {
        i_owner = msg.sender;
    }

    function addMember(address account) external {
        require(
            msg.sender == i_owner,
            "You do not have permission to add members"
        );
        //adminMembers.push(account);
        adminMembers[account] = adminMember(msg.sender, true);
        emit MemberAdded(msg.sender, account);
    }

    function removeMember(address account) external {
        require(
            msg.sender == i_owner,
            "You do not have permission to add members"
        );
        // for(uint i = 0; i < adminMembers.length; i++){
        //     if(adminMembers[i] == account){
        //         adminMembers[i] = adminMembers[adminMembers.length - 1];
        //         adminMembers.pop();
        //     }
        // }
        adminMembers[account] = adminMember(msg.sender, false);

        emit MemberRemoved(msg.sender, account);
    }

    // Checking if the action taken by the user is admin or allowed to perfrom or not
    function isAdmin(address account) public view returns (bool) {
        // for(uint i = 0; i < adminMembers.length; i++){
        //     if(adminMembers[i] == account){
        //         return true;
        //     }
        // }
        // return false;

        // if (adminMembers[account][adminMember._isDeleted]==false){
        //     return true;
        // }
        // else{
        //     return false;
        // }

        if (adminMembers[account]._flag) {
            return true;
        } else {
            return false;
        }
    }

    function setFeeAccount(address account) public {
        require(msg.sender == i_owner, "You do not have set this value!");
        feeAccount = account;
        emit FeeAccount(msg.sender, account);
    }

    function getFeeAccount() public view returns (address) {
        return feeAccount;
    }

    function setFeePercent(uint _feePercent) public {
        require(msg.sender == i_owner, "You do not have set this value!");
        feePercent = _feePercent;
        emit FeePercent(msg.sender, _feePercent);
    }

    function getFeePercent() public view returns (uint) {
        return feePercent;
    }
}
