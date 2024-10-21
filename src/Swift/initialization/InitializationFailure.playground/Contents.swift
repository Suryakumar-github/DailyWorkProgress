import UIKit

class Person {
    var name : String
    var age : Int
    
    init?(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Employee : Person {
    var empId : String
    
    init?(empId: String, name : String, age : Int) {
        if(empId.isEmpty) {
            return nil
        }
        self.empId = empId
        super.init(name: name, age: age)
    }
}

var employee1 = Employee(empId: "z_0012", name: "alex", age: 27)
var employee2 = Employee(empId: "", name: "ram", age: 28)
