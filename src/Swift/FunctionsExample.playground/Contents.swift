import UIKit
// func without return type

func greet(person : String) {
    print(person)
}
greet(person: "surya")

// functions
func greeting(for person: String) -> String {
    return "Hello, " + person + "!"
}
print(greeting(for: "surya"))

// explicit return

func greetings(for person: String) -> String {
     "Hello, " + person + "!"
}
print(greetings(for: "surya"))

// argument lables

func move(from start: String, to destination: String) {
    print("Moving from \(start) to \(destination)")
}

move(from: "Chennai ", to: "Delhi")



func add(a: Int, b: Int) -> Int {
    return a + b
}

let sum = add(a: 500, b: 250)
print(sum)
 // returning multiple values as tuples

func calculate(a: Int, b: Int) -> (sum: Int, difference: Int) {
    let sum = a + b
    let difference = a - b
    return (sum, difference)
}

let result = calculate(a: 10, b: 5)
print("Sum: \(result.sum), Difference: \(result.difference)")

// returning optional tuples

func findLongestAndShortest(words: [String]) -> (short: String, long: String)? {
    guard !words.isEmpty else {
        return nil
    }
    
    var currentMin = words[0]
    var currentMax = words[0]
    
    for word in words {
        if word.count > currentMax.count {
            currentMax = word
        }
        if word.count < currentMin.count {
            currentMin = word
        }
    }
    
    return (short: currentMin, long: currentMax)
}

if let result = findLongestAndShortest(words: ["blue", "black", "tree", "map", "tea", "i", "palindrome"]) {
    print("Shoertest word is : \(result.short) and Longest word is : \(result.long)")
} else {
    print("Array was empty")
}

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

// Function to swap values using inout parameters
func swapValues(_ a: inout Int, _ b: inout Int) -> (Int, Int) {
    let temp = a
    a = b
    b = temp
    return (a, b)
}

var x = 5
var y = 10
swapValues(&x, &y)
print("x: \(x), y: \(y)")

// using function types
var mathFunction: (Int, Int) -> Int = multiply
print(mathFunction(2, 3))

mathFunction = add
print(mathFunction(2,3))

func printAndCount(string: String) -> Int {
    print(string)
    return string.count
}
func printWithoutCounting(string: String) {
    let count = printAndCount(string: string)
    print(count)
}
printAndCount(string: "hello, world")
printWithoutCounting(string: "hello, world")

// Function that takes another function as a parameter
func printSwappedValues(_ swapFunction: (inout Int, inout Int) -> (Int, Int), _ num1: Int, _ num2: Int) {
    var number1 = num1
    var number2 = num2
    
    let result = swapFunction(&number1, &number2)
    print("Swapped values: \(result)")
}

var a = 5
var b = 10
printSwappedValues(swapValues, a, b)

// nested functions

func performCalculation(for number : Int) -> (square :Int, cube :Int) {
    
    func squareNumber(_ num : Int) -> Int {
        return num * num
    }
    
    func cubeNumber(_ num : Int) -> Int{
        return num * num * num
    }
    
    let square = squareNumber(number)
    let cube = cubeNumber(number)
    
    return(square, cube)
}

let answer = performCalculation(for: 5)
print("Square : \(answer.square), Cube : \(answer.cube)")
