import UIKit

import Foundation

protocol VotingDelegate: AnyObject {
    func votingDidStart(_ votingSystem: VotingSystem)
    func voting(_ votingSystem: VotingSystem, didCastVoteFor candidate: String)
    func votingDidEnd(_ votingSystem: VotingSystem)
}

class VotingSystem {
    weak var delegate: VotingDelegate?
    private var votes: [String: Int] = [:]
    private var candidates: [String]
    
    init(candidates: [String]) {
        self.candidates = candidates
        for candidate in candidates {
            votes[candidate] = 0
        }
    }
    
    func startVoting() {
        delegate?.votingDidStart(self)
    }
    
    func castVote(for candidate: String) {
        guard votes.keys.contains(candidate) else {
            print("Invalid candidate: \(candidate)")
            return
        }
        votes[candidate, default: 0] += 1
        delegate?.voting(self, didCastVoteFor: candidate)
    }
    
    func endVoting() {
        delegate?.votingDidEnd(self)
        print("Voting results:")
        for (candidate, voteCount) in votes {
            print("\(candidate): \(voteCount) votes")
        }
    }
}

class VotingTracker: VotingDelegate {
    func votingDidStart(_ votingSystem: VotingSystem) {
        print("Voting has started!")
    }
    
    func voting(_ votingSystem: VotingSystem, didCastVoteFor candidate: String) {
        print("Vote cast for \(candidate)")
    }
    
    func votingDidEnd(_ votingSystem: VotingSystem) {
        print("Voting has ended!")
    }
}

// Usage
let votingSystem = VotingSystem(candidates: ["Maari", "Subramni", "Charlie"])
let votingTracker = VotingTracker()

votingSystem.delegate = votingTracker

votingSystem.startVoting()

votingSystem.castVote(for: "Alex")
votingSystem.castVote(for: "Subramni")
votingSystem.castVote(for: "Charlie")
votingSystem.castVote(for: "Maari")
votingSystem.castVote(for: "Maari")
votingSystem.castVote(for: "Subramni")

votingSystem.endVoting()

