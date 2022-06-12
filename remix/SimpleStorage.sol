// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7 <0.9.0; //0.8.7; // 0.8.12

contract SimpleStorage {
    // boolean, uint, int, address, bytes
    bool hasFavoriteNumber = false;
    uint256 public favoriteNumber = 123; // default: 0, default internal
    string favoriteNumberInText = "Five";
    int256 favoriteInt = 5;
    address myAddress = 0x11F19ff3f7Aa2417B4d1554Bc3D397C0d3Ae4e07;
    bytes32 favoriteBytes = "cat";
    // People public person = People({favoriteNumber: 2, name: 'Mai'});
    // uint256[] favoriteNumbersList;
    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
        // retrieve();
    } 

    // view, pure
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    function add() public pure returns(uint256) {
        return (1 + 1);
    }

    // calldata, meory, stroage
    // memory: temporily & can be  (array, struct, mapping + memory keyword)
    // calldata: temporily & can NOT be modified
    // storage: outside function & can be modified
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        People memory newPerson = People(_favoriteNumber, _name);
        people.push(newPerson);
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

// 0xd9145CCE52D386f254917e481eB44e9943F39138
