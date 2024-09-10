pragma solidity ^0.8.4;

contract NFT_Market {

  // Authentication service 

  struct UserDetail {
        address wallet; // stores the wallet address
        string user_name;
        string password;
        string ipfs_image_hash; // for storing the profile image in ipfs
        bool artist;
        bool login_status;
  }

  mapping(address => UserDetail) user;

  event UserRegistered(address indexed wallet, string user_name);
  event UserLoggedIn(address indexed wallet);
  event UserLoggedOut(address indexed wallet);

  // User registration
  function registerUser(
      address _wallet,
      string memory _user_name,
      string memory _password,
      string memory _ipfs_image_hash,
      bool _artist
  ) public returns (bool) {
      require(user[_wallet].wallet == address(0), "User already registered");
      
      user[_wallet] = UserDetail({
          wallet: _wallet,
          user_name: _user_name,
          password: _password,
          ipfs_image_hash: _ipfs_image_hash,
          artist: _artist,
          login_status: false
      });

      emit UserRegistered(_wallet, _user_name);

      return true;
  }


  // User login
  function loginUser(address _wallet, string memory _user_name) public returns (bool) {
      require(user[_wallet].wallet == msg.sender, "User not registered");

      if (keccak256(bytes(user[_wallet].user_name)) == keccak256(bytes(_user_name))) {
          user[_wallet].login_status = true;

          emit UserLoggedIn(_wallet);

          return true;

      } else {
          return false;
      }
  }


  // Check if the user is logged in
  function checkUserLogin(address _wallet) public view returns (bool, string memory) {
      return (user[_wallet].login_status, user[_wallet].ipfs_image_hash);
  }

  // Logout the user
  function logoutUser(address _wallet) public {
      user[_wallet].login_status = false;

      emit UserLoggedOut(_wallet);
  }











  // NFT Minting

struct NFT{
        uint256 likes;
        uint256 tokenId;
        address owner;
        uint256 timestamp;
        bool valid; // removed from the user collection after sold
        string name;
        string username;
        string imageURI;
        bool sale; // sale = true and store = false;
  }

  event NFTMinted(address owner, uint256 tokenId, string name);
  event NFTTransferred(uint256 indexed tokenId, address indexed from, address indexed to);

  NFT[] public nft_list;



  uint256 token_number = 0;


  mapping(uint256 => NFT) public token_nft; // we can get the mapped address from tokenId from this;



  // utilities
  function view_nft(uint256 tokenId) public view returns(NFT memory){
    return token_nft[tokenId];
  }


  function isTokenPresent(uint256 tokenId) public view returns (bool) {
      if (token_nft[tokenId].owner == address(0)) {
          return false; // Token not present in the mapping
      } else {
          return true; // Token exists in the mapping
      }
  }



  // minting NFT
  function _safe_mint(string memory name, string memory username, string memory image_uri, bool sale) public returns(NFT memory){

    address owner = msg.sender;
    uint256 tokenId = token_number;
    token_number++;

    token_nft[tokenId] = NFT(0, tokenId, owner, block.timestamp, true, name, username, image_uri, sale);



    nft_list.push(token_nft[tokenId]);

    emit NFTMinted(owner, tokenId, name);

    return token_nft[tokenId]; // remove this after testing
  }


  //transering nft    requiring tokenid belongs to the user
  function NFT_transfer(address to, uint256 tokenId) public {
    require(to != address(0), "Cannot transfer to zero address");
    NFT storage nft = token_nft[tokenId];
    require(msg.sender == nft.owner, "You are not the owner of this token");
    require(nft.valid, "Invalid NFT");

    nft.owner = to;

    nft_list[tokenId].owner = to;






    emit NFTTransferred(tokenId, msg.sender, to);
  }






}
