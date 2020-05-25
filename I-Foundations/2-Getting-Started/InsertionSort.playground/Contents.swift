/// Insertion Sort

import XCTest

extension Array {
    
    // Sorts the mutable collection in place using Insertion Sort algorithm.
    // - Complexity: O(n^2), where n is the length of the collection.
    mutating func insertionSort(by areInIncreasingOrder: (Element, Element) -> Bool) {
        for i in 1..<count {
            let temp = self[i]

            // Insert self[i] in to the sorted sequence self[0...i-1]
            var j = i
            while j > 0 && areInIncreasingOrder(temp, self[j-1]) {
                self[j] = self[j-1]
                j -= 1
            }
            self[j] = temp
        }
    }
}

extension Array where Element: Comparable {
    // Elements are sorted in ascending order.
    mutating func insertionSort() {
        self.insertionSort(by: <)
    }
}

// Tests
var array = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]

array.insertionSort()
XCTAssertEqual(array, [-1, 0, 1, 2, 3, 3, 5, 8, 9, 10, 26, 27])

struct Person: Equatable {
    var name: String
    var age: Int
}

let david = Person(name: "David", age: 25)
let tom = Person(name: "Tom", age: 32)

var friends = [david, tom]

friends.insertionSort { $0.name > $1.name }
XCTAssertEqual(friends, [tom, david])

friends.insertionSort { $0.age < $1.age }
XCTAssertEqual(friends, [david, tom])
