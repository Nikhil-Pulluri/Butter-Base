pragma solidity ^0.8.4;

contract NFT_Market {

  // Authentication service 

  struct UserDetail {
        address wallet; // stores the wallet address
        string user_name;
        string password;
        string ipfs_image_hash; // for storing the profile image in ipfs
        // string[] collection; // this can be included in ipfs contract where address can be mapped to collection array.

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



  uint256 token_number = 0;

  mapping(address => uint256[]) public owned_tokens;// tokens owned by any user

  mapping(address => NFT[]) public user_nft_collection; // includes all nfts that are for sale and as well as not for sale

  // mapping(address => NFT[]) public user_nft_sale; // for sale nfts of any user

  // mapping(address => NFT[]) public user_nft_store; // not for sale but to store in ipfs

  mapping(uint256 => NFT) public token_nft; // we can get the mapped address from tokenId from this;

  mapping(address => uint256) public nft_count;


  // utilities
  function view_nft(uint256 tokenId) public view returns(NFT memory){
    return token_nft[tokenId];
  }

  function NFT_Count() public view returns(uint256){
    return nft_count[msg.sender];
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

    token_nft[tokenId] = NFT(tokenId, owner, block.timestamp, true, name, username, image_uri, sale);

    user_nft_collection[owner].push(token_nft[tokenId]);

    // if(sale){
    //   user_nft_sale[owner].push(token_nft[tokenId]);
    // } else{
    //   user_nft_store[owner].push(token_nft[tokenId]);
    // }

    owned_tokens[owner].push(tokenId);

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

    // Transfer logic
    _removeFromUserCollections(msg.sender, tokenId);
    owned_tokens[to].push(tokenId);
    nft_count[msg.sender]--;
    nft_count[to]++;

    emit NFTTransferred(tokenId, msg.sender, to);
  }


  function _removeFromUserCollections(address owner, uint256 tokenId) internal {
        // Remove from owned_tokens
        uint256[] storage tokens = owned_tokens[owner];
        for (uint256 i = 0; i < tokens.length; i++) {
            if (tokens[i] == tokenId) {
                tokens[i] = tokens[tokens.length - 1];
                tokens.pop();
                break;
            }
        }


        NFT[] storage nfts = user_nft_collection[owner];
        for (uint256 i = 0; i < nfts.length; i++) {
            if (nfts[i].tokenId == tokenId) {
                nfts[i] = nfts[nfts.length - 1]; // Replace with the last element
                nfts.pop(); // Remove the last element
                break;
            }
        }
  }




}
