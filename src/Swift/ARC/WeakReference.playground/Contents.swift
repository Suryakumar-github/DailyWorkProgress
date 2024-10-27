import UIKit

class Owner {
    var name : String
    var pet : Pet?
    
    init(name: String) {
        self.name = name
    }
    
    deinit{
        print("Owner \(name) is deinitialized")
    }
}

class Pet {
    var name : String
    weak var owner : Owner?
    
    init(name: String) {
        self.name = name
    }
    
    deinit{
        print("Pet \(name) is deinitialized")
    }
}

var owner1 : Owner? = Owner(name: "hari")
var pet1 : Pet? = Pet(name: "tommy")

owner1?.pet = pet1
pet1?.owner = owner1

print("Owner \(owner1!.name)'s pet name : \(owner1!.pet!.name)")
print("Pet \(pet1!.name)'s owner name : \(pet1!.owner!.name)")

pet1 = nil
owner1 = nil

