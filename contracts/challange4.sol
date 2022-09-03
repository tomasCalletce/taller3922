// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {

    mapping(uint => uint) stars;
    uint public totalSupply;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){}

    modifier notContract() {
      uint32 size;
      address _addr = msg.sender;
      assembly {
        size := extcodesize(_addr)
      }
      require(size == 0);
      _;
    }

    function mint(address _account) external payable notContract returns (uint) {
        require(tx.origin != msg.sender);
        require(msg.value == .2 ether);
        ERC721._mint(_account,totalSupply);
        uint _rad = random();
        uint _stars;
        if(_rad < 1) {  _stars = 5; }
        else if(_rad < 5) {  _stars = 4; }
        else if(_rad < 15) {  _stars = 3; }
        else if(_rad < 50) {  _stars = 2; }
        else { _stars = 1; }
        stars[totalSupply] = _stars;
        unchecked {
            totalSupply += 1;
        }
        return totalSupply-1;
    }

    function random() internal  view returns (uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.number,msg.sender,totalSupply))) % 100;
    }

    function getStar(uint _tokenId) external view returns (uint _star) {
        require(ERC721._exists(_tokenId), "ERC721: token already minted");
        _star = stars[_tokenId];
    }

    
}