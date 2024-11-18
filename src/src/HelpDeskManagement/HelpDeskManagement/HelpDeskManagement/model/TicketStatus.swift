//
//  TicketStatus.swift
//  HelpDeskManagement
//
//  Created by incubation on 04/11/24.
//

enum TicketStatus: String {
    case created, assigned, opened, closed, solved, cancelled, onHold
    
    init?(status: String) {
        switch status.lowercased() {
        case "created" :
            self = .created
        case "assigned" :
            self = .assigned
        case "opened":
            self = .opened
        case "closed":
            self = .closed
        case "solved":
            self = .solved
        case "cancelled":
            self = .cancelled
        case "onhold":
            self = .onHold
        default:
            return nil
        }
    }
}
