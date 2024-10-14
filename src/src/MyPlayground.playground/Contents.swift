//import UIKit
/* let three = 3
let pointOneFour = 0.14159
let pi = Double(three) + pointOneFour */
/*
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

var names = ["sam","ram","tom","kim","tim"]

/*for name in names {
    print(name)
} */

for name in names[...2] {
    print(name)
}

let softWrappedQuotation = """
The White Rabbit put on his spectacles.  "Where shall I begin, \
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on 
till you come to the end; then stop."

"""
print(softWrappedQuotation)

let threeDoubleQuotationMarks = """
Escaping the first quotation mark \"""
Escaping all three quotation marks \"\"\"
"""
//print(threeDoubleQuotationMarks)

let threeMoreDoubleQuotationMarks = #"""
Here are three more double quotes: """
"""#
//print(threeMoreDoubleQuotationMarks)


var str = "horse"
print(str)
//print(str + " is running ")
//print(str)
str.append(threeDoubleQuotationMarks)
print(str)

//var char = "e"
//char += str
//print(char)

let precomposed: Character = "\u{D55C}"    //\u{1161}\u{11AB}
let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"
print(precomposed)
print(decomposed)
*/
/*
var greeting = "Wecome All "
print(greeting[greeting.startIndex])
print(greeting.startIndex)
print(greeting[greeting.index(after : greeting.startIndex)])

let index = greeting.index(greeting.startIndex, offsetBy: 2)
print(greeting[index])
greeting.insert("!", at: greeting.endIndex)
print(greeting)
greeting.insert(contentsOf: "to Zoho ", at: greeting.index(before: greeting.endIndex))
print(greeting)

greeting.remove(at: greeting.index(before: greeting.endIndex))
print(greeting)

let range = greeting.index(greeting.endIndex, offsetBy: -6)..<greeting.endIndex
greeting.removeSubrange(range)
print(greeting)

let index1 = greeting.firstIndex(of: ",") ?? greeting.endIndex
let beginning = greeting[..<index1]
let newString = String(beginning)
//print(greeting)
*/
var arr1 = Array(repeating: 5, count: 3)
var arr2 = Array(repeating: 3, count: 3)
var arr3 = Array(repeating: 6, count: 3)
var mergerdArray = arr1 + arr2 + arr3
/*
print(mergerdArray)
print(arr1.last)
print(mergerdArray.count)
mergerdArray[4...6] = [1,1,1,1,1]
print(mergerdArray)
mergerdArray.insert(10, at: 0)
print(mergerdArray.remove(at: 1))
print(mergerdArray.removeLast())
 
for (index1,value) in mergerdArray.enumerated() {
    print("element \(index1 + 1) : \(value)")
}
 */
var set1 : Set = [1,2,3,4,5]
print(set1.sorted())

for elemnt in set1.sorted() {
    print(elemnt)
}
var set2 : Set = [3,5,6,7,8]
//var set3 = set1.intersection(set1)
//print(set3)
print(set2.symmetricDifference(set1))
var set4 : Set = [2,4]
/*print(set1.isSuperset(of: set4))
print(set1.isSubset(of: set4))
print(set4.isSubset(of: set1))
print(set2.isDisjoint(with: set4))
print(set1.isStrictSuperset(of: set4))
print(set4.isStrictSubset(of: set1))
var dupSet : Set = [1,2,3,4,5]
print(set1.isDisjoint(with: dupSet))
var twodArray = [[2,3,4],
                [5,6,7],
                [8,9,1]]
//print(twodArray)

for elements in twodArray {
    for element in elements {
        print(element, terminator: " ")
    }
    print()
}
*/

var dict : [Int : String] = [1 : "Ak", 2 : "Vj", 3 : "Vk", 4 : "Sk"]

/*for (num , name) in dict {
    print("Index : \(num) , Name : \(name)")
} */
/*
for nums in dict.keys {
    print(nums, terminator: ", ")
}
print()
for names in dict.values {
    print(names, terminator: ", ")
}
 var char1 : Character = "z"
var char2 : Character = "a"
char2 += char1
print(char2) */

var score = 3
if score < 100 {
    score += 100
    defer {
        score -= 100
        print(score)
    }
    print("score : \(score)")
}

func printAndCount(string: String) -> Int {
    print(string)
    return string.count
}
func printWithoutCounting(string: String) {
    let _ = printAndCount(string: string)
}
print(printAndCount(string: "hello , world !"))
print(printWithoutCounting(string: "hello , world !"))

func printAndCount1(string: String) -> Int {
    string.count
}
print("Count is : \(printAndCount1(string: "hello , world !  ")) " )
// functions
func greeting(for person: String) -> String {
    "Hello, " + person + "!"
}
print(greeting(for: "surya"))

func add(a: Int, b: Int) -> Int {
    return a + b
}

let sum = add(a: 500, b: 250)
print(sum)
 // returning multiple values

func calculate(a: Int, b: Int) -> (sum: Int, difference: Int) {
    let sum = a + b
    let difference = a - b
    return (sum, difference)
}

let result = calculate(a: 10, b: 5)
print("Sum: \(result.sum), Difference: \(result.difference)")

func multiply(_ a: Int, _ b: Int) -> Int {
    return a * b
}

let ans = multiply(4, 5)

func greet(person: String, from city: String = "Unknown") {
    print("Hello \(person) from \(city)!")
}

greet(person: "surya")
greet(person: "amar", from: "india")

// variadic parameters
func sumOf(numbers: Int...) -> Int {
    var total = 0
    for number in numbers {
        total += number
    }
    return total
}

let total = sumOf(numbers: 1, 2, 3, 4, 5)
print("total : \(total)")

// in-out
func swapValues(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}

var x = 5
var y = 10
swapValues(&x, &y)
print("x: \(x), y: \(y)")

let mathFunction: (Int, Int) -> Int = multiply
print(mathFunction(2, 3))

// closures
let addNumbers = { (a: Int, b: Int) -> Int in
    return a + b
}

let results = addNumbers(5, 3)
print(" total : \(results)")
func makeIncrementer(incrementAmount: Int) -> () -> Int {
    var total = 0
    let incrementer = {
        total += incrementAmount
        return total
    }
    return incrementer
}

let incrementByTwo = makeIncrementer(incrementAmount: 2)
print(incrementByTwo())
print(incrementByTwo())

func performTask(completion: () -> Void) {
    completion()
}

performTask(completion: {
    print("Task performed")
})

performTask {
    print("Task performed")
}

let numbers = [1, 2, 3, 4, 5]
let squaredNumbers = numbers.map { $0 * $0 }
print("Squared Values : \(squaredNumbers) ")
// enums

enum Direction: String {
    case north = "North"
    case east = "East"
    case west = "West"
    case south = "South"
    
    
}
var eastDirection = Direction.east.rawValue
print("Direction is : \(eastDirection) ")

enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sums = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sums, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}


print(evaluate(product))

enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")

for cases in Beverage.allCases {
    print(cases)
}
