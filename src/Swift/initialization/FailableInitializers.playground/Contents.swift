import UIKit

class Human {
    var name : String
    var gender : String
    var age : Int
    
    init?(name: String, gender: String, age: Int) {
        if(name.isEmpty) {
            return nil
        }
        self.name = name
        self.gender = gender
        self.age = age
    }
}

if let human1 = Human(name: "",gender: "male",age :45) {
    print(human1)
}
