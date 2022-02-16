// SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

  contract AstarBots is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseURI;
  string public baseExtension = ".json";
  string public notRevealedUri;
  uint256 public cost = 150 ether;
  uint256 public maxSupply = 8800;
  uint256 public reserve = 200;
  uint256 public maxMintAmount = 2;
  uint256 public maxMintAmountWl = 4;
  uint256 public maxMintAmountMegawl = 6;
  uint256 public nftPerAddressLimit = 20;
  bool public paused = true;
  bool public revealed = true;
  bool public onlyWhitelisted = true;
  bool public onlyMegaWhitelisted = true;
  address[] public whitelistedAddresses;
  address[] public MegawhitelistedAddresses;
 
  
  constructor(
    string memory _initBaseURI
    
    
  ) ERC721("AstarBots", "ASTB") {
    setBaseURI(_initBaseURI);
    
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  function mint(uint256 _mintAmount) public payable {
    require(!paused, "the contract is paused");
    uint256 supply = totalSupply();
    uint256 ownerTokenCount = balanceOf(msg.sender);
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintAmount, "You can Mint 2 NFT");
    require(supply + _mintAmount <= maxSupply - reserve, "max Supply exceeded");
    require(msg.value >= cost * _mintAmount, "insufficient funds");
    require(ownerTokenCount + _mintAmount <= nftPerAddressLimit, "max NFT per wallet exceeded");

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }

  function wlMint(uint256 _mintAmount) public payable {
    require(!paused, "the contract is paused");
    uint256 supply = totalSupply();
    uint256 ownerTokenCount = balanceOf(msg.sender);
    require(isWhitelisted(msg.sender), "user is not whitelisted");
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintAmountWl, "You can Only Mint 4 NFT");
    require(supply + _mintAmount <= maxSupply - reserve, "max Supply exceeded");
    require(msg.value >= cost * _mintAmount, "insufficient funds");
    require(ownerTokenCount + _mintAmount <= nftPerAddressLimit, "max NFT per wallet exceeded");

        for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
        }
  }
    function MegawlMint(uint256 _mintAmount) public payable {
    require(!paused, "the contract is paused");
    uint256 supply = totalSupply();
    uint256 ownerTokenCount = balanceOf(msg.sender);
    require(isMegaWhitelisted(msg.sender), "user is not Megawhitelisted");
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintAmountMegawl, "You can Only Mint 6 NFT");
    require(supply + _mintAmount <= maxSupply - reserve, "max Supply exceeded");
    require(msg.value >= cost * _mintAmount, "insufficient funds");
    require(ownerTokenCount + _mintAmount <= nftPerAddressLimit, "max NFT per wallet exceeded");

        for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
        }
  }

     function gift(uint256 _mintAmount, address destination) public onlyOwner {
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    uint256 supply = totalSupply();
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(destination, supply + i);
    }
  }

    function mintforowner(uint256 _mintAmount) public onlyOwner {
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    uint256 supply = totalSupply();
    require(supply + _mintAmount <= maxSupply, "max Supply exceeded");

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }
  
  function isWhitelisted(address _user) public view returns (bool) {
    for (uint i = 0; i < whitelistedAddresses.length; i++) {
      if (whitelistedAddresses[i] == _user) {
          return true;
      }
    }
    return false;
  }

    function isMegaWhitelisted(address _user) public view returns (bool) {
    for (uint i = 0; i < MegawhitelistedAddresses.length; i++) {
      if (MegawhitelistedAddresses[i] == _user) {
          return true;
      }
    }
    return false;
  }

  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    if(revealed == false) {
        return notRevealedUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  //only owner
  function reveal(bool _state) public onlyOwner {
      revealed = _state;
  }

  function setMaxSupply(uint256 _newmaxSupply) public onlyOwner {
      maxSupply = _newmaxSupply;
  }
  
  function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
    nftPerAddressLimit = _limit;
  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  function setreserve(uint256 _newreserve) public onlyOwner {
      reserve = _newreserve;
  }

  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }
    function setmaxMintAmountwl(uint256 _newmaxMintAmountwl) public onlyOwner {
    maxMintAmountWl = _newmaxMintAmountwl;
  }
    function setmaxMintAmountMegawl(uint256 _newmaxMintAmountMegawl) public onlyOwner {
    maxMintAmountMegawl = _newmaxMintAmountMegawl;
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
  
  function setOnlyWhitelisted(bool _state) public onlyOwner {
    onlyWhitelisted = _state;
  }

   function setOnlyMegaWhitelisted(bool _state) public onlyOwner {
    onlyMegaWhitelisted = _state;
  }

  
  function whitelistUsers(address[] calldata _users) public onlyOwner {
    delete whitelistedAddresses;
    whitelistedAddresses = _users;
  }
    function MegawhitelistUsers(address[] calldata _users) public onlyOwner {
    delete MegawhitelistedAddresses;
    MegawhitelistedAddresses = _users;
  }
 
  function withdraw() public payable onlyOwner {
    (bool success, ) = payable(0x193Ec4d74Ed08F5A4004356b5b224FeB69B8DFeC).call{value: address(this).balance * 10 /100}("");
    require(success);

    (bool ow, ) = payable(0x10B5357cf9C4E164619421C84749938FFb704518).call{value: address(this).balance}("");
    require(ow);
  }
}

