import UIKit
// if-else
let temperature = 30

if temperature > 25 {
    print("It's hot outside!")
} else if temperature < 15 {
    print("It's cold outside!")
} else {
    print("The weather is nice.")
}

// ternary
let age = 20
let canVote = age >= 18 ? "Yes, you can vote." : "No, you're too young."
print(canVote)

// guard with early exit

func checkEligibility(age: Int) {
    guard age >= 18 else {
        print("You are not eligible")
        return
    }
    print("You are eligible to vote")
}

checkEligibility(age : 20)

// for-in loops
var names = ["sam","ram","tom","kim","tim"]

for name in names {
    print(name)
}

for name in names[...2] {
    print(name)
}

var personAndLanguages = ["ram" : "Tamil", "sam" : "telugu", "tom" : "english", "kim" : "korean", "tim" : "spanish"]

for( person, language) in personAndLanguages {
    print("Persoans Name : \(person) , Language : \(language) ")
}

for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}

for index in 1..<10 {
    print(index)
}

let count = 100
let skipBy = 10
for index in stride(from: 0, through: count, by: skipBy) {
    print(index)
}

// while loop

var start = 1
var end = 100

while start < end {
    start += 1 * start
    print(start)
}

// repeat-while
var start1 = 1

repeat {
    start1 += 1 * start1
    print(start1)
}
while(start1 < 100)

// switch

let day = "Friday"

switch day {
    
case "Sunday" :
    print("1st day of the week")
    
case "Monday" :
    print("2nd day of the week")
    
case "Tuesday" :
    print("3rd day of the week")
    
case "WednesDay" :
    print("4th day of the week")
    
case "Thursday" :
    print("5th day of the week")
    
case "Friday" :
    print("6th day of the week")
    
case "Saturday" :
    print("7th day of the week")
default:
    print("Invalid Day")
}

// compound cases

switch day {
    
case "Monday","Tuesday", "Wednesday", "Thursday", "Friday" :
    print("Week day")
    
case "Saturday", "Sunday" :
    print("Weekend")
    
default :
    print("Invalid Day")
}

// fallthrough

let number = 5

switch number {
case 5:
    print("It's 5")
    fallthrough
case 6:
    print("Now it's 6")
default:
    print("Default case")
}

// interval matching

let mark = 70
var statement = ""

switch mark {
case 0..<35 :
    statement = "Fail"
    
case 35..<50 :
    statement = "D grade"
    
case 50..<70 :
    statement = "C grade"
    
case 70..<90 :
    statement = "B grade"
    
case 90..<101 :
    statement = "A grade"
    
default :
    statement = "Invalid mark entered"
}
print("Mark Scored : \(mark) , Grade : \(statement) ")

// tuples in switch

let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
    print("\(somePoint) is inside the box")
default:
    print("\(somePoint) is outside of the box")
}

// value binding and where clause

let boxDimensions = (3, 3, 3)

switch boxDimensions {
case let (l, w, h) where l == w && w == h:
    print("This is a cube with side length \(l).")
case let (l, w, h) where l == 0 || w == 0 || h == 0:
    print("One of the dimensions is zero, this is not a valid box.")
case let (l, w, h) where l < 2 || w < 2 || h < 2:
    print("This is a very flat object.")
case let (l, w, h) where h > l && h > w:
    print("This is a tall box with height \(h).")
case let (l, w, h):
    print("This is a regular box with dimensions \(l) x \(w) x \(h).")
}

// defer
func readFile() {
    print("Opening file...")

    defer {
        print("Closing file...")
    }

    print("Reading file contents...")
    return;

    print("This line will not be executed because of the return.")
}

readFile()

