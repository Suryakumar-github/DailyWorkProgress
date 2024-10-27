import UIKit

class School {
    let name: String
    var principal: Principal!
    
    init(name: String, principalName: String) {
        self.name = name
        self.principal = Principal(name: principalName, school: self)
    }
    
    deinit {
        print("\(name) School is being deinitialized")
    }
}

class Principal {
    let name: String
    unowned let school: School
    
    init(name: String, school: School) {
        self.name = name
        self.school = school
    }
    
    deinit {
        print("Principal \(name) is being deinitialized")
    }
}

var mySchool: School? = School(name: "Greenwood High", principalName: "Mr. Smith")

if let school = mySchool {
    print("\(school.principal.name) is the principal of \(school.name)")
}


mySchool = nil

