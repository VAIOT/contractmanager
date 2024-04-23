// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title ContractManager
 * @dev Management of contracts with dynamic fields
 */

contract ContractManager {
  // ============= VARIABLES ============
  uint256 private nextContractId = 1;
  address private deployer;

  // ============= MAPPINGS ============
  mapping(address => mapping(uint256 => mapping(string => string)))
    private userContracts;
  mapping(address => uint256[]) private userContractIds;
  mapping(address => mapping(uint256 => string[])) private contractFieldNames;
  mapping(address => mapping(uint256 => uint256)) private contractCreationDates;
  mapping(address => mapping(uint256 => string)) private contractPartyA;
  mapping(address => mapping(uint256 => string)) private contractPartyB;
  mapping(address => mapping(uint256 => string)) private contractTypes;

  // ============= EVENTS ============
  event ContractAdded(uint256 contractId, address indexed owner);
  event ContractFieldUpdated(
    uint256 contractId,
    string fieldName,
    string fieldValue
  );
  event ContractFieldDeleted(uint256 contractId, string fieldName);

  // ============= MODIFIERS ============
  modifier onlyDeployer() {
    require(msg.sender == deployer, "Only deployer can perform this action");
    _;
  }

  // ============= CONSTRUCTOR ============
  constructor() {
    deployer = msg.sender;
  }

  // ============= MAIN FUNCTIONS =============

  /**
   * @dev Adds a new Contract with its fields for a user.
   * @param _owner Address of the contract owner.
   * @param _fieldNames Names of the contract fields
   * @param _fieldValues Values for the contract fields.
   * @param _partyA Value for the party A of the contract.
   * @param _partyB Value for the party B of the contract.
   * @param _contractType Type of contract.
   * @return The new contract ID.
   */
  function addNDA(
    address _owner,
    string[] memory _fieldNames,
    string[] memory _fieldValues,
    string memory _partyA,
    string memory _partyB,
    string memory _contractType
  ) public onlyDeployer returns (uint256) {
    require(_owner != address(0), "Invalid owner address");
    require(
      _fieldNames.length == _fieldValues.length,
      "Field names and values length mismatch"
    );

    uint256 contractId = nextContractId++;
    for (uint256 i = 0; i < _fieldNames.length; i++) {
      userContracts[_owner][contractId][_fieldNames[i]] = _fieldValues[i];
      contractFieldNames[_owner][contractId].push(_fieldNames[i]);
    }
    userContractIds[_owner].push(contractId);
    contractCreationDates[_owner][contractId] = block.timestamp;

    // Store partyA and partyB
    contractPartyA[_owner][contractId] = _partyA;
    contractPartyB[_owner][contractId] = _partyB;

    // Store the contract type
    contractTypes[_owner][contractId] = _contractType;

    emit ContractAdded(contractId, _owner);
    return contractId;
  }

  /**
   * @dev Updates an existing field or adds a new field to a specific contract.
   * If the field name does not exist, it is added to the contract. If it does exist,
   * its value is updated with the new value provided.
   * @param _owner Address of the contract owner.
   * @param _contractId ID of the contract to be updated.
   * @param _fieldName Name of the field to be updated or added.
   * @param _fieldValue Value of the field to be updated or added.
   */
  function updateNDAField(
    address _owner,
    uint256 _contractId,
    string memory _fieldName,
    string memory _fieldValue
  ) public onlyDeployer {
    require(
      _contractId > 0 && _contractId < nextContractId,
      "Invalid contract ID"
    );
    require(bytes(_fieldName).length > 0, "Field name cannot be empty");
    // Check if the field already exists. If not, add it to the field names list.
    if (!fieldExists(_owner, _contractId, _fieldName)) {
      contractFieldNames[_owner][_contractId].push(_fieldName);
    }
    // Update or set the field value.
    userContracts[_owner][_contractId][_fieldName] = _fieldValue;
    emit ContractFieldUpdated(_contractId, _fieldName, _fieldValue);
  }

  /**
   * @dev Deletes a field from a specific contract.
   * @param _owner Address of the contract owner.
   * @param _contractId ID of the contract from which the field will be deleted.
   * @param _fieldName Name of the field to be deleted.
   */
  function deleteNDAField(
    address _owner,
    uint256 _contractId,
    string memory _fieldName
  ) public onlyDeployer {
    require(
      bytes(userContracts[_owner][_contractId][_fieldName]).length != 0,
      "Field does not exist"
    );
    delete userContracts[_owner][_contractId][_fieldName];
    removeFieldName(_owner, _contractId, _fieldName);
    emit ContractFieldDeleted(_contractId, _fieldName);
  }

  /**
   * @dev Retrieves a field value from a specific contract.
   * @param _owner Address of the contract owner.
   * @param _contractId ID of the contract.
   * @param _fieldName Name of the field whose value is to be retrieved.
   * @return The value of the specified field.
   */
  function getNDAFieldValue(
    address _owner,
    uint256 _contractId,
    string memory _fieldName
  ) public view returns (string memory) {
    return userContracts[_owner][_contractId][_fieldName];
  }

  /**
   * @notice Retrieves all contract IDs associated with a specific owner.
   * @param _owner Address of the owner whose contracts IDs are being queried.
   * @return An array of contract IDs owned by the specified address.
   */
  function getUserContractIds(
    address _owner
  ) public view returns (uint256[] memory) {
    return userContractIds[_owner];
  }

  /**
   * @notice Fetches all field names, their corresponding values, and creation timestamp for a given contract
   * @param _owner Address of the contract owner
   * @param _contractId ID of the contract whose fields are being queried.
   * @return creationTimestamp The creation timestamp of the contract.
   * @return fieldNames An array of field names in the specified contract.
   * @return fieldValues An array of field values corresponding to the field names in the specified contract.
   * @return partyA Party A of the contract.
   * @return partyB Party B of the contract.
   */
  function getNDAFieldsAndValues(
    address _owner,
    uint256 _contractId
  )
    public
    view
    returns (
      uint256 creationTimestamp,
      string[] memory fieldNames,
      string[] memory fieldValues,
      string memory partyA,
      string memory partyB,
      string memory contractType
    )
  {
    require(userContractIds[_owner].length > 0, "No contracts found for owner");
    require(
      contractCreationDates[_owner][_contractId] != 0,
      "Contract does not exist"
    );

    uint256 fieldCount = contractFieldNames[_owner][_contractId].length;
    creationTimestamp = contractCreationDates[_owner][_contractId];
    fieldNames = new string[](fieldCount);
    fieldValues = new string[](fieldCount);

    for (uint256 i = 0; i < fieldCount; i++) {
      string memory fieldName = contractFieldNames[_owner][_contractId][i];
      fieldNames[i] = fieldName;
      fieldValues[i] = userContracts[_owner][_contractId][fieldName];
    }

    // Return partyA and partyB along with other information
    partyA = contractPartyA[_owner][_contractId];
    partyB = contractPartyB[_owner][_contractId];
    contractType = contractTypes[_owner][_contractId];

    return (
      creationTimestamp,
      fieldNames,
      fieldValues,
      partyA,
      partyB,
      contractType
    );
  }

  /**
   * @dev Checks if a field name exists for a given NDA.
   * @param _owner The address of the NDA's owner.
   * @param _contractId The unique identifier of the NDA.
   * @param _fieldName The name of the field to check for existence.
   * @return bool True if the field exists, false otherwise.
   */
  function fieldExists(
    address _owner,
    uint256 _contractId,
    string memory _fieldName
  ) private view returns (bool) {
    string[] memory fields = contractFieldNames[_owner][_contractId];
    for (uint256 i = 0; i < fields.length; i++) {
      if (
        keccak256(abi.encodePacked(fields[i])) ==
        keccak256(abi.encodePacked(_fieldName))
      ) {
        return true;
      }
    }
    return false;
  }

  /**
   * @dev Removes a field name from the array of field names for a given NDA.
   * This function should be called to maintain consistency between the stored field values
   * and their corresponding names when a field is deleted.
   * @param _owner The address of the NDA's owner.
   * @param _contractId The unique identifier of the NDA.
   * @param _fieldName The name of the field to be removed.
   */
  function removeFieldName(
    address _owner,
    uint256 _contractId,
    string memory _fieldName
  ) private {
    uint256 fieldIndex = 0;
    bool found = false;
    for (
      uint256 i = 0;
      i < contractFieldNames[_owner][_contractId].length;
      i++
    ) {
      if (
        keccak256(
          abi.encodePacked(contractFieldNames[_owner][_contractId][i])
        ) == keccak256(abi.encodePacked(_fieldName))
      ) {
        fieldIndex = i;
        found = true;
        break;
      }
    }

    if (found) {
      for (
        uint256 i = fieldIndex;
        i < contractFieldNames[_owner][_contractId].length - 1;
        i++
      ) {
        contractFieldNames[_owner][_contractId][i] = contractFieldNames[_owner][
          _contractId
        ][i + 1];
      }
      contractFieldNames[_owner][_contractId].pop();
    }
  }
}
