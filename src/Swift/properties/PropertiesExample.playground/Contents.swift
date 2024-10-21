import UIKit

struct Book {
    // stored properties
    var title: String
    var author: String
    var totalPages: Int
    var currentPage: Int
    
    // computed properties
    var readingProgress: String {
        get {
            let progress = Double(currentPage) / Double(totalPages) * 100
            return "Reading progress: \(progress)%"
        }
        set(newProgress) {
        
            if let percentIndex = newProgress.firstIndex(of: "%") {
                let progressValue = Double(newProgress[..<percentIndex]) ?? 0
                currentPage = Int((progressValue / 100) * Double(totalPages))
            }
        }
    }
}

var myBook = Book(title: "Swift Programming", author: "alex", totalPages: 400, currentPage: 120)
print(myBook.readingProgress)

myBook.readingProgress = "50%"
print(myBook.currentPage)

// property observers

class Car {
    var fuelLevel: Int = 100 {
        willSet(newFuelLevel) {
            print("Fuel level will change from \(fuelLevel) to \(newFuelLevel).")
        }
        didSet {
            if fuelLevel < oldValue {
                print("Fuel consumption detected: \(oldValue - fuelLevel) liters.")
            }
        }
    }
}

let myCar = Car()
myCar.fuelLevel = 80

// lazy properties

class ImageLoader {
    var imageName: String
    lazy var image: String = {
        print("Loading image: \(imageName)")
        return "\(imageName) Image Data"
    }()
    
    init(imageName: String) {
        self.imageName = imageName
    }
}

let loader = ImageLoader(imageName: "SampleImage")
print(loader.image)

//Read-Only Computed Properties

struct Circle {
    var radius: Double
    
    var circumference: Double {
        return 2 * .pi * radius
    }
    
    var area: Double {
        .pi * radius * radius
    }
}

let myCircle = Circle(radius: 10.0)
print("Circumference: \(myCircle.circumference)")
print("Area: \(myCircle.area)")


//
struct Square {
    var sideLength: Double
    
    var area: Double {
        get {
            sideLength * sideLength
        }
        set {
            sideLength = sqrt(newValue)
        }
    }
}

var mySquare = Square(sideLength: 5.0)
print("Area: \(mySquare.area)")

mySquare.area = 36.0
print("New side length: \(mySquare.sideLength)")


// property wrappers

@propertyWrapper
struct Capitalized {
    private var value: String
    
    init(wrappedValue: String) {
        self.value = wrappedValue.capitalized
    }
    
    var wrappedValue: String {
        get { value }
        set { value = newValue.capitalized }
    }
}

struct Person {
    @Capitalized var name: String
}

var person = Person(name: "suryakumar")
print(person.name)
person.name = "amar"
print(person.name)
