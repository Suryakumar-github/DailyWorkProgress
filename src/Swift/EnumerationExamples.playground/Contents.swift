import UIKit


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
