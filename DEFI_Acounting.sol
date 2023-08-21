// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Accounting {
    struct DEFI_Transaction {
        uint256 amount;
        address sender;
        uint256 timestamp;
        address receiver;
        string description;
    }

    mapping(address => uint256) public balances;
    Transaction[] public transactions;
    address public owner;

    event DepositFunds(
        address indexed account, 
        uint256 amount
    );

    event FundsWithdrawal(
        address indexed account, 
        uint256 amount
    );

    event TransactionMade(
        address indexed sender, 
        address indexed receiver, 
        uint256 indexed id, 
        uint256 timestamp, 
        string description, 
        uint256 amount,
    );

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender === owner, "only owner is permitted to call this function");
        _;
    }

    function depositFunds public payable {
        require(msg.value > 0, "amount must be greater than 0.");
        balances[msg.sender] += msg.value;
        emit DepositFunds(msg.sender,msg.value);
    }

    function withdrawFunds(uint256 amount) public {
        require(amount > 0, "amount must be greater than 0.");
        require(balances[msg.sender] >= amount, "Insufficient balance.");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit FundsWithdrawal(msg.sender,amount);
    }

    function addTransactionRecord(address receiver, uint256 amount, string memory description) public {
        require(amount > 0, "amount must be greater than 0.");
        require(balances[msg.sender] >= amount, "Insufficient balance.");

        balances[msg.sender] -= amount;
        balances[receiver] += amount;

        transaction.push(Transaction(amount, msg.sender, block.timestamp, receiver, description));

        emit TransactionMade(msg.sender, receiver, transaction.length - 1, block.timestamp, description, amount);
    }

    function getTransactionsCount() public view returns (uint256){
        return transactions.length
    }

    function getTransactionById(uin256 id) public view returns (uint265, address, address, uint256, string memory){
        require(id < transaction.length, "Invalid transaction id.");
        
        Transaction memory transaction = transaction[id]; 

        return (transaction.amount, transaction.sender, transaction.receiver, transaction.timestamp, transaction.description);
    }
   

}