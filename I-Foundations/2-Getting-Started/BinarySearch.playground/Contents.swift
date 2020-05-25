/// Binary Search

extension Array where Element: Comparable {
    
    /// The linear search, can apply when we don't know the collection is sorted or not.
    /// - Parameter value: An value to search for in the collection.
    /// - Returns: The first index where `value` is found. If `value` is not
    ///   found in the collection, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    func linearSearch(of value: Element) -> Int? {
        for index in 0..<count {
            if self[index] == value { return index }
        }
        
        return nil
    }
    
    // When we know in advance that the collection is sorted.
    // Iterative implementation.
    /// - Complexity: O(*lg n*), where *n* is the length of the collection.
    func iBinarySearch(of value: Element) -> Int? {
        var low = 0, high = count - 1

        while low <= high {
            let mid = (low + high) >> 1

            if self[mid] == value { return mid }
            
            if value > self[mid] {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        
        return nil
    }
    
    // Recursive implementation
    /// - Complexity: O(*lg n*), where *n* is the length of the collection.
    func rBinarySearch(of value: Element) -> Int? {
        func search(value: Element, from: Int, to: Int) -> Int? {
            guard from <= to else { return nil }
            
            let mid = (from + to) >> 1
            
            if self[mid] == value {
                return mid
            } else if value > self[mid] {
                return search(value: value, from: mid + 1, to: to)
            } else {
                return search(value: value, from: from, to: to - 1)
            }
        }
        
        return search(value: value, from: 0, to: count - 1)
    }
}

// Tests

import XCTest

var array = [Int]()
// search in empty array
XCTAssertNil(array.linearSearch(of: 1))
XCTAssertNil(array.iBinarySearch(of: 1))
XCTAssertNil(array.rBinarySearch(of: 1))

array = [1, 2, 4, 9, 20, 22]
// search a value does exist in given array
XCTAssertEqual(array.linearSearch(of: 1), 0)
XCTAssertEqual(array.iBinarySearch(of: 2), 1)
XCTAssertEqual(array.rBinarySearch(of: 4), 2)

XCTAssertEqual(array.linearSearch(of: 9), 3)
XCTAssertEqual(array.iBinarySearch(of: 20), 4)
XCTAssertEqual(array.rBinarySearch(of: 22), 5)

// search a value out of range
XCTAssertNil(array.iBinarySearch(of: -1))
XCTAssertNil(array.rBinarySearch(of: 100))
