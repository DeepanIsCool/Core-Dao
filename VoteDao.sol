// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title VoteDao with Quadratic Voting
/// @notice Users get a fixed budget of voting credits per proposal.  
///         Casting n votes costs n² credits, curbing large vote dumps.
contract VoteDao {
    struct Proposal {
        string description;
        uint256 deadline;           // timestamp when voting ends
        uint256 votesFor;           // sum of weighted votes
        uint256 votesAgainst;
        bool executed;
        mapping(address => uint256) creditsSpent;
    }

    uint256 public proposalCount;
    mapping(uint256 => Proposal) private proposals;
    uint256 public constant CREDIT_BUDGET = 100; // credits per address per proposal
    uint256 public votingDuration = 3 days;      // default voting period

    /// @notice Emitted when a new proposal is created
    event ProposalCreated(uint256 indexed id, string description, uint256 deadline);

    /// @notice Emitted when someone votes
    event Voted(
        uint256 indexed proposalId,
        address indexed voter,
        bool support,
        uint256 votes,
        uint256 cost
    );

    /// @notice Emitted when a proposal is executed
    event ProposalExecuted(uint256 indexed id, bool passed);

    modifier validProposal(uint256 _id) {
        require(_id > 0 && _id <= proposalCount, "Invalid proposal ID");
        _;
    }

    /// @notice Create a new proposal
    /// @param _description Human-readable proposal text
    function createProposal(string calldata _description) external {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.description = _description;
        p.deadline = block.timestamp + votingDuration;

        emit ProposalCreated(proposalCount, _description, p.deadline);
    }

    /// @notice Vote on a proposal using quadratic voting
    /// @param _proposalId ID of the proposal
    /// @param _support True = support, False = against
    /// @param _votes Number of votes you want to cast (0 < _votes)
    function vote(
        uint256 _proposalId,
        bool _support,
        uint256 _votes
    ) external validProposal(_proposalId) {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp <= p.deadline, "Voting period over");
        require(_votes > 0, "Must cast at least one vote");

        // Quadratic cost = votes^2
        uint256 cost = _votes * _votes;
        uint256 spent = p.creditsSpent[msg.sender] + cost;
        require(spent <= CREDIT_BUDGET, "Exceeds credit budget");

        // Record spending
        p.creditsSpent[msg.sender] = spent;

        // Tally weighted votes
        if (_support) {
            p.votesFor += _votes;
        } else {
            p.votesAgainst += _votes;
        }

        emit Voted(_proposalId, msg.sender, _support, _votes, cost);
    }

    /// @notice Execute the proposal after deadline to determine outcome
    /// @param _proposalId ID of the proposal
    function executeProposal(uint256 _proposalId) external validProposal(_proposalId) {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp > p.deadline, "Voting still open");
        require(!p.executed, "Already executed");

        p.executed = true;
        bool passed = p.votesFor > p.votesAgainst;

        // (Optional) Here you could hook in treasury transfers, state changes, etc.

        emit ProposalExecuted(_proposalId, passed);
    }

    /// @notice View details of a proposal
    function getProposal(uint256 _proposalId)
        external
        view
        validProposal(_proposalId)
        returns (
            string memory description,
            uint256 deadline,
            uint256 votesFor,
            uint256 votesAgainst,
            bool executed,
            uint256 creditsUsed
        )
    {
        Proposal storage p = proposals[_proposalId];
        description = p.description;
        deadline = p.deadline;
        votesFor = p.votesFor;
        votesAgainst = p.votesAgainst;
        executed = p.executed;
        creditsUsed = p.creditsSpent[msg.sender];
    }

    /// @notice Change voting duration (in seconds)
    /// @dev Could be owner-only in a real DAO; left open for simplicity
    function setVotingDuration(uint256 _seconds) external {
        votingDuration = _seconds;
    }
}
