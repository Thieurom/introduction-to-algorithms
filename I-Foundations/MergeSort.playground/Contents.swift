/// Merge Sort

// Global function to merge two sorted array into one.
private func merge<T>(_ array1: Array<T>, _ array2: Array<T>) -> Array<T> where T: Comparable {
    var result = Array<T>()
    
    var i = 0, j = 0
    
    while i < array1.count && j < array2.count {
        if array1[i] < array2[j] {
            result.append(array1[i])
            i += 1
        } else {
            result.append(array2[j])
            j += 1
        }
    }
    
    if i < array1.count {
        result.append(contentsOf: Array(array1[i..<array1.count]))
    }
    
    if j < array2.count {
        result.append(contentsOf: Array(array2[j..<array2.count]))
    }
    
    return result
}

// Implementation of merge sort
extension Array where Element: Comparable {
    
    /// Sorts the collection using Merge Sort algorith-a typical divide-and-conquer one.
    /// - Returns: A sorted array of the sequence's elements.
    /// - Complexity: O(*n* log *n*), where *n* is the length of the sequence.
    func mergeSorted() -> [Element] {
        // Base case
        guard count > 1 else { return self }
        
        // Recursively merge sort left half
        let leftHalf = Array(self[0..<count/2]).mergeSorted()
        
        // Recursively merge sort right half
        let rightHalf = Array(self[count/2..<count]).mergeSorted()
        
        // Combine two already-sorted halves
        return merge(leftHalf, rightHalf)
    }
}


// Example
import XCTest

let a = [-3, 1, 3, 8, 8, 13, 22]
let b = [-2, 0, 3, 5, 19]

XCTAssertEqual(merge(a, b), [-3, -2, 0, 1, 3, 3, 5, 8, 8, 13, 19, 22])

let numbers = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0]
XCTAssertEqual(numbers.mergeSorted(), [-1, 0, 1, 2, 3, 3, 5, 8, 9, 10, 27])
