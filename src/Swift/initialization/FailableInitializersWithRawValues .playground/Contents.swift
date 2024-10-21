import UIKit

enum Days : String{
    case sunday = "sun"
    case monday = "mon"
    case tuesday = "tue"
    case wednesday = "wed"
    case thursday = "thu"
    case friday = "fri"
    case saturday = "sat"

}

var day = Days(rawValue: "wed")

var day2 = Days(rawValue: "ved")
