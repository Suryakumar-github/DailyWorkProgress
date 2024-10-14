//import UIKit
let three = 3
let pointOneFour = 0.14159
let pi = Double(three) + pointOneFour

let orangesAreOrage = true
let turnipsAreDelicious = false

if (turnipsAreDelicious) {
    print("Mmm, tasty turnips")
}
else {
    print("Eww, turnips are horrible")
}
var arr : [Int] = [2,3,5,6,7]
print(arr)
arr.append(0)
print(arr)

let http404Error = (404, "not found")
print(http404Error)

let (statusCode, statusMessage) = http404Error
print("Erroe code is : \(statusCode)")
print("Erroe msg is : \(statusMessage)")
let(justStatusCode,_) = http404Error
print(justStatusCode)
//print(_)
print("Error code is : \(http404Error.0)")
print("Error msg is : \(http404Error.self)")
print("Message : \(http404Error.1)")
var name: String? = "Suryakumar"
print(name!)
var name2 : String? = nil
//print(name2!)
if let unwrappedName = name2 {
    print("The name is \(name2!)")
}
else {
    print("The name is nil")
}
let unwrappedName2 = name2 ?? "Default Name"
print(unwrappedName2)
let name1 : String? = "sam"

