import UIKit

import Foundation

struct Rectangle {
    var width: Double
    var height: Double
}

// Extension to add more functionality
extension Rectangle {
    
    // Computed Property
    var area: Double {
        return width * height
    }
    
    // Computed Property
    var perimeter: Double {
        return 2 * (width + height)
    }
    
    // Initializer
    init(side: Double) {
        self.width = side
        self.height = side
    }
    
    // Method
    func describe() -> String {
        return "Rectangle with width \(width) and height \(height)"
    }
    
    // Mutating Method
    mutating func scale(by factor: Double) {
        width *= factor
        height *= factor
    }
    
    // Subscript
    subscript(index: Int) -> Double? {
        get {
            switch index {
            case 0: return width
            case 1: return height
            default: return nil
            }
        }
        set {
            guard let newValue = newValue else { return }
            switch index {
            case 0: width = newValue
            case 1: height = newValue
            default: break
            }
        }
    }
    
    // Nested Type
    enum ShapeType {
        case square
        case rectangle
    }
    
    // Computed Property using Nested Type
    var shapeType: ShapeType {
        return width == height ? .square : .rectangle
    }
}

var myRectangle = Rectangle(width: 4, height: 8)
print(myRectangle.describe())

print("Area:", myRectangle.area)
print("Perimeter:", myRectangle.perimeter)

// accessing mutating methods
myRectangle.scale(by: 2)
print("Scaled dimensions - Width: \(myRectangle.width), Height: \(myRectangle.height)")

// Acessing subscript
print("Width using subscript:", myRectangle[0] ?? "N/A")
print("Height using subscript:", myRectangle[1] ?? "N/A")
myRectangle[0] = 10
print("Modified Width:", myRectangle.width)

// Acessing Init
let square = Rectangle(side: 5)
print(square.describe())
print("Shape Type:", square.shapeType)
print("Square Area:", square.area)
print("Square Perimeter:", square.perimeter)

