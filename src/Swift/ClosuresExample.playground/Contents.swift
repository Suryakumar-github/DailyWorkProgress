import UIKit

let names = ["surya", "amar", "john", "sri", "alex"]

func compare(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
// passin closure as normal func
var reversedNames = names.sorted(by: compare)

// directly passing the closure
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

// Inferring Type From Context
reversedNames = names.sorted(by : {s1,s2 in return s1 > s2})

//Shorthand Argument Names
reversedNames = names.sorted(by : {$0 > $1})

// operator method
reversedNames = names.sorted(by : < )
print(reversedNames)

// closures
let addNumbers = { (a: Int, b: Int) -> Int in
    return a + b
}

let results = addNumbers(5, 3)
print(" total : \(results)")

// capturing
func makeIncrementer(incrementAmount: Int) -> () -> Int {
    var total = 0
    let incrementer = {
        total += incrementAmount
        return total
    }
    return incrementer
}
 
let incrementByTwenty = makeIncrementer(incrementAmount: 20)
print(incrementByTwenty())
print(incrementByTwenty())

let incrementByFifty = makeIncrementer(incrementAmount: 50)
print(incrementByFifty())
print(incrementByFifty())
print(incrementByTwenty())
print(incrementByFifty())

// trailing closure
func performTask(completion: () -> Void) {
    completion()
}

performTask(completion: {
    print("Task performed")
})

performTask {
    print("Task performed")
}

// Shorthand argument names
let numbers = [1, 2, 3, 4, 5]
let squaredNumbers = numbers.map { $0 * $0 }
print("Squared Values : \(squaredNumbers) ")

