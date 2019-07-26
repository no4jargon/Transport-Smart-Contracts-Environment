pragma solidity ^0.5.1;

contract ContractsEnvironment{
    
    struct Contract {uint8 key;
    address creator;
    address receiver;
    string ftlorltl;
    string origin;
    string destination;
    uint weight;
    uint cost;
    uint start;
    uint expiry;
    string state;}
    mapping (uint8 => Contract) contractsindex;
    mapping (address => uint8[]) userscontractsindex;
    uint8[] contractsbystatuslist;
    uint8[] allcontractslist;
    
    function createcontract(address to, string memory ftlorltl, string memory o, string memory d, uint w, uint c, uint s, uint e) public returns (uint8) {
        uint8 key = random(to);
        Contract memory newcon = Contract(key,msg.sender,to,ftlorltl,o,d,w,c,s,e,"init");
        contractsindex[key] = newcon;
        userscontractsindex[msg.sender].push(key);
        userscontractsindex[to].push(key);
        return newcon.key;
    }
    
    function getcontractinfo(uint8 key) public view 
    returns (uint8, address, address, string memory, string memory, string memory, uint, uint, uint, uint, string memory) {
    Contract memory newcon = contractsindex[key];
    return (newcon.key, newcon.creator, newcon.receiver, newcon.ftlorltl, newcon.origin, newcon.destination, newcon.weight, newcon.cost, newcon.start, newcon.expiry, newcon.state);
    }
    
    function getallcontracts(address anyaddress) public returns (uint8[] memory){
        return userscontractsindex[anyaddress];
    }
    
    function getcontractsbystatus(address anyaddress, string memory status) public returns (uint8[] memory){        
        uint8[] memory List = getallcontracts(anyaddress);
        delete contractsbystatuslist;
        uint i;
        for (i=0; i < List.length; i++){
            (uint8 q, address w, address e, string memory r, string memory t, string memory y, uint a, uint s, uint d, uint f, string memory State) = getcontractinfo(List[i]);
            if ((keccak256(abi.encodePacked(State))) == keccak256(abi.encodePacked(status))) contractsbystatuslist.push(List[i]);
        return contractsbystatuslist;
        }
    }
    
    function random(address to) private view returns (uint8) {
       return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty,msg.sender,to)))%251);
   }
   
   function changestatecontract(uint8 key, string memory statedecision) public{
        (uint8 q, address w, address e, string memory r, string memory t, string memory y, uint a, uint s, uint d, uint f, string memory State) = getcontractinfo(key);
        require(msg.sender == e, "Only receiver can change state of contract");
        require(keccak256(abi.encodePacked(statedecision)) == keccak256(abi.encodePacked("accept")) || keccak256(abi.encodePacked(statedecision)) == keccak256(abi.encodePacked("reject")));
        contractsindex[key]=Contract(q,w,e,r,t,y,a,s,d,f,statedecision);
    }
}