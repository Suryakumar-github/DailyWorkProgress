import UIKit

class Company {
    var companyName : String
    var employees : [Employee]
    
    init(companyName: String) {
        self.companyName = companyName
        self.employees = []
    }
    
    deinit{
        print("Company \(companyName) is deinitialized")
    }
}
class Employee {
    var name : String
    unowned var company : Company
    unowned var manager : Employee?
    init(name: String, company: Company, manager: Employee? = nil) {
        self.name = name
        self.company = company
        self.manager = manager
    }
    deinit{
        print("Employee \(name) is deinitialized")
    }
}

var company1 = Company(companyName: "Zoho")
var employee1 = Employee(name: "raj", company: company1)
var employee2 = Employee(name: "abdul", company: company1)
var employee3 = Employee(name: "alex", company: company1)

employee2.manager = employee1
employee3.manager = employee1
company1.employees = [employee1, employee2, employee3]
