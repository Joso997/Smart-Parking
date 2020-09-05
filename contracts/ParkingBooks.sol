// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;
pragma experimental ABIEncoderV2;

contract ParkingBooks {

    address payable private admin;
     // modifier to check if caller is owner
    modifier isAdmin() {
        require(msg.sender == admin, "Caller is not admin");
        _;
    }
    // event for EVM logging
    event AdminSet(address indexed oldAdmin, address indexed newAdmin);
    /**
     * @dev Set contract deployer as owner
     */
    constructor() {
        admin = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit AdminSet(address(0), admin);
    }

    struct ParkingTime{
      uint waitReserve;
      uint endReserve;
      uint waitLease;
      uint endLease;
  }

   struct Parking {
       uint id;
      string title;
      int[] location;
      uint score;
      uint[] working_hours;
      bool electric_support;
      bool roof;
      bool garage;
      uint price; //number is saved times 100
      uint deposit; //number is saved times 100
      address payable owner;
      bool enabled;
      ParkingTime time;
  }

  struct User{
      uint parking_id;
      bool hasAccess;
      bool leased;
      address payable user;
  }

    struct Deposit{
        address payable owner;
        address payable user;
        uint price;
        uint deposit;
        bool returnToUser;
    }

  mapping(uint => Parking) public parkings;
  mapping(address => User) public users;
  mapping(address => mapping(uint => Deposit)) public owners;
  mapping(address => uint) public ownsCount;

  uint count = 0;
  uint depositCount = 0;

    modifier isOwner(address owner) {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    modifier isUser(uint id) {
        require(checkIfNotInUse(id) || (users[msg.sender].parking_id == id && users[msg.sender].hasAccess), "Caller is not user");
        _;
    }

    function index() public view returns (Parking[] memory){
        Parking[] memory ret = new Parking[](count);
        for (uint i = 0; i < count; i++) {
            ret[i] = parkings[i];
        }
        return ret;
    }

    function indexByOwner() public view returns (Parking[] memory){
        Parking[] memory ret = new Parking[](ownsCount[msg.sender]);
        uint temp_count = 0;
        for (uint i = 0; i < count; i++) {
            if(parkings[i].owner == msg.sender){
                ret[temp_count++] = parkings[i];
            }
        }
        return ret;
    }

    function show(uint id) public view returns (Parking memory){
        return parkings[id];
    }

    function show() public view returns (Parking memory){
        return parkings[users[msg.sender].parking_id];
    }

    function testStore() public {
        int[] memory temp = new int[](2);
        temp[0] = 20;
        temp[1] = 30;
        uint[] memory working = new uint[](2);
        working[0] = 8;
        working[1] = 18;
        ParkingTime memory _time = ParkingTime({
            waitReserve: 20 seconds,
            endReserve: 0,
            waitLease: 60 seconds,
            endLease: 0
        });
        parkings[count] = Parking({
            id: count,
            title: 'Test',
            location: temp,
            score: 5,
            working_hours: working,
            electric_support: false,
            roof: false,
            garage: false,
            price: 1 ether,
            deposit: 2 ether,
            owner: msg.sender,
            enabled: true,
            time: _time
        });
        count++;
        ownsCount[msg.sender]++;
    }

    function store(string memory _title, int[] memory _location, uint[] memory _working_hours, bool _electric_support, bool _roof, bool _garage, uint _price, uint _deposit, bool _enabled, ParkingTime memory _time) public {
        parkings[count] = Parking({
            id: count,
            title: _title,
            location: _location,
            score: 5,
            working_hours: _working_hours,
            electric_support: _electric_support,
            roof: _roof,
            garage: _garage,
            price: _price * 1 wei,
            deposit: _deposit * 1 wei,
            owner: msg.sender,
            enabled: _enabled,
            time: _time
        });
        count++;
        ownsCount[msg.sender]++;
    }

    function update(uint id, string memory _title, int[] memory _location, uint[] memory _working_hours, bool _electric_support, bool _roof, bool _garage, uint _price, uint _deposit, ParkingTime memory _time) public isOwner(parkings[id].owner) {
        parkings[id].title = _title;
        parkings[id].location = _location;
        parkings[id].working_hours = _working_hours;
        parkings[id].electric_support = _electric_support;
        parkings[id].roof = _roof;
        parkings[id].garage = _garage;
        parkings[id].price = _price * 1 wei;
        parkings[id].deposit = _deposit * 1 wei;
        parkings[id].time = _time;
    }

    function reserve(uint id) public {
        require(checkIfNotInUse(id));
        parkings[id].time.endReserve = block.timestamp+parkings[id].time.waitReserve;
        users[msg.sender] = User({parking_id: id, hasAccess: true, leased: false, user: msg.sender});
        parkings[id].time.endLease = 0;
    }

    function reserve_end(uint id) public isUser(id){
        require(users[msg.sender].leased == false);
        parkings[id].time.endReserve = 0;
        delete users[msg.sender];
    }

    function reserve_end() public {
        require(users[msg.sender].leased == false);
        parkings[users[msg.sender].parking_id].time.endReserve = 0;
        delete users[msg.sender];
    }

    function lease(uint id) public payable hasBalance(id) {
        require(checkIfNotInUse(id) || users[msg.sender].parking_id == id);

        owners[parkings[id].owner][depositCount] = Deposit({
           owner: parkings[id].owner,
           user: msg.sender,
           returnToUser: true,
           price: parkings[id].price,
           deposit: parkings[id].deposit
        });
        depositCount++;
        parkings[id].time.endLease = block.timestamp+parkings[id].time.waitLease;
        users[msg.sender] = User({parking_id: id, hasAccess: true, leased: true, user: msg.sender});
        parkings[id].time.endReserve = 0;
    }

    function leaseUpdate(uint id) public payable hasBalance(id) {
        require(checkIfNotInUse(id) || users[msg.sender].parking_id == id);

        owners[parkings[id].owner][depositCount].price += parkings[id].price;
        owners[parkings[id].owner][depositCount].deposit += parkings[id].deposit;
        parkings[id].time.endLease = block.timestamp+parkings[id].time.waitLease;
    }

    function lease_end(uint id, uint _score) public isUser(id){
        parkings[id].time.endLease = 0;
        if(_score > 5){
            _score = 5;
        }else if(_score < 1){
          _score = 1;
        }
        parkings[id].score = (_score + parkings[id].score)/2;
        delete users[msg.sender];
    }

    function resolveFunds() public {
        for (uint i = 0; i < depositCount; i++) {
            msg.sender.transfer(owners[msg.sender][i].price);
            owners[msg.sender][i].user.transfer(owners[msg.sender][i].deposit);
            delete owners[msg.sender][i];
            delete users[owners[msg.sender][i].user];
        }
    }

    function trunOnOff(uint id) public isOwner(parkings[id].owner) {
        require(checkIfNotInUse(id));
        parkings[id].enabled = !parkings[id].enabled;
    }

    function checkIfNotInUse(uint id) view public returns (bool) {
        return (block.timestamp > parkings[id].time.endReserve && block.timestamp > parkings[id].time.endLease && parkings[id].enabled);
    }

    function checkStatus() view public returns (string memory){
        if(users[msg.sender].hasAccess){
            uint id = users[msg.sender].parking_id;
            if(parkings[id].time.endReserve > 0 && block.timestamp < parkings[id].time.endReserve){
                return "inReserve";
            }else
            if(parkings[users[msg.sender].parking_id].time.endLease > 0 && block.timestamp < parkings[id].time.endLease){
                return "inLease";
            }
        }
        return "inMap";

    }

    modifier hasBalance(uint id){
        require(msg.value >= parkings[id].price+parkings[id].deposit, "Balance is low.");
        _;
    }


}
