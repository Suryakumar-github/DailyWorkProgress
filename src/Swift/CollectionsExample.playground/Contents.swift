import UIKit

var array = [10,20,30,40,50]
print("Array Elements : \(array) ")

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
print(set1.endIndex)
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
