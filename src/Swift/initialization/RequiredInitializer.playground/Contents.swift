import UIKit

import UIKit

class Person {
    var name: String

    // Required init
    required init(name: String) {
        self.name = name
    }
}

class Employee: Person {
    var empId: String

    required init(name: String) {
        self.empId = "Unknown"
        super.init(name: name)
    }

    init(name: String, empId: String) {
        self.empId = empId
        super.init(name: name)
    }
}

class Manager: Employee {
    var department: String

    required init(name: String) {
        self.department = "Unknown"
        super.init(name: name)
    }

    init(name: String, empId: String, department: String) {
        self.department = department
        super.init(name: name, empId: empId)
    }
}


let employee = Employee(name: "surya")
print("Employee Name: \(employee.name), Employee ID: \(employee.empId)")

let manager = Manager(name: "amar", empId: "M001", department: "HR")
print("Manager Name: \(manager.name), Employee ID: \(manager.empId), Department: \(manager.department)")

