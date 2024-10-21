import UIKit

enum Days {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    init?(symbol : String) {
        switch symbol {
        case "sun" :
            self = .sunday
        case "mon" :
            self = .monday
        case "tue" :
            self = .tuesday
        case "wed" :
            self = .wednesday
        case "thu" :
            self = .thursday
        case "fri" :
            self = .friday
        case "sat" :
            self = .friday
        default :
            return nil
        }
    }
}

var day = Days(symbol: "sdf")
