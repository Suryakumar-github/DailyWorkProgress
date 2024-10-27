import UIKit

struct School {
    
    var name: String
    var students: [Student]
    
    enum Level {
        case elementary, middle, high
    }
    
    struct Student {
        var name: String
        var grade: Int
    }
    
    var level: Level
    
    init(name: String, level: Level, students: [Student]) {
        self.name = name
        self.level = level
        self.students = students
    }
    
    func listStudents() {
        print("Students in \(name):")
        for student in students {
            print("\(student.name), Grade: \(student.grade)")
        }
    }
}

let student1 = School.Student(name: "Shiva", grade: 5)
let student2 = School.Student(name: "Albert", grade: 6)
let student3 = School.Student(name: "Charlie", grade: 5)

// Creating a school instance
let elementarySchool = School(name: "Greenwood Elementary", level: .elementary, students: [student1, student2, student3])

// Listing students in the school
elementarySchool.listStudents()

