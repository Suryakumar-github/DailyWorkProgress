import UIKit

class Mobile {
    // default capacity
    var batteryCapacity : String = "4500mah"
}

var mobile = Mobile()
print("Mobile Battery Capacity is : \(mobile.batteryCapacity)")
mobile.batteryCapacity = "5000mah"
print("Mobile Battery Capacity is : \(mobile.batteryCapacity)")
var mobile2 = Mobile()

print(mobile === mobile2)
