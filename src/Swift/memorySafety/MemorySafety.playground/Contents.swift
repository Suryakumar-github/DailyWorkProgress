import UIKit

func doubleEachElement(in array: inout [Int]) {
    for index in 0..<array.count {
        array[index] *= 2
    }
}

var values = [1, 2, 3, 4, 5]
doubleEachElement(in: &values)
print(values)
