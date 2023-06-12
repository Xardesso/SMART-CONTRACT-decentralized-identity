// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IdentityManagement {
    struct Identity {
        string name;
        string age;
        string nationality;
        uint256 height;
    }

    mapping(address => Identity) private identities;
    mapping(address => bool) private authorizedEntities;

    event IdentityRegistered(address indexed user);
    event AuthorizationGranted(address indexed user, address indexed entity);
    event AuthorizationRevoked(address indexed user, address indexed entity);

    modifier onlyAuthorized() {
        require(authorizedEntities[msg.sender], "Unauthorized entity");
        _;
    }

    function registerIdentity(
        string memory _name,
        string memory _age,
        string memory _nationality,
        uint256 _height
    ) public {
        require(bytes(_name).length > 0, "Invalid name");
        require(bytes(_age).length > 0, "Invalid age");
        require(bytes(_nationality).length > 0, "Invalid nationality");

        Identity storage identity = identities[msg.sender];
        require(
            bytes(identity.name).length == 0,
            "Identity already registered"
        );

        identity.name = _name;
        identity.age = _age;
        identity.nationality = _nationality;
        identity.height = _height;

        emit IdentityRegistered(msg.sender);
    }

    function grantAuthorization(address _entity) public {
        require(_entity != address(0), "Invalid entity address");
        require(!authorizedEntities[_entity], "Entity already authorized");

        authorizedEntities[_entity] = true;

        emit AuthorizationGranted(msg.sender, _entity);
    }

    function revokeAuthorization(address _entity) public {
        require(_entity != address(0), "Invalid entity address");
        require(authorizedEntities[_entity], "Entity not authorized");

        authorizedEntities[_entity] = false;

        emit AuthorizationRevoked(msg.sender, _entity);
    }

    function getIdentity(
        address _user
    )
        public
        view
        onlyAuthorized
        returns (string memory, string memory, string memory, uint256)
    {
        Identity memory identity = identities[_user];
        return (
            identity.name,
            identity.age,
            identity.nationality,
            identity.height
        );
    }
}
