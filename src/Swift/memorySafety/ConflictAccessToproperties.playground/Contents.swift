import UIKit

func swapValues(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}

var coordinates = (x: 10, y: 20)

swapValues(&coordinates.x, &coordinates.y)

swapValues(&coordinates.x, &coordinates.x) 

