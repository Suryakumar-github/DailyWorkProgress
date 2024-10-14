import UIKit

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

