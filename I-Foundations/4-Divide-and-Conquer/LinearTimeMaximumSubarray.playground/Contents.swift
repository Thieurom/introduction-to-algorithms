//
// Exercises 4.1-5
// Implement a non-recursive, linear-time algorithm (O(n)) for the maximum-subarray problem.
//

func maximumSubarray(_ array: [Int]) -> [Int] {
    assert(!array.isEmpty)
    
    if array.count == 1 { return array }
    
    // Starting index of maximumSubarray
    var start = 0
    // Ending index of maximumSubarray
    var end = 0
    // Sum of current maximumSubarray
    var maxSoFar = array[0]
    
    // Starting index of maximumSubarray that ends at the traversing index
    var startOfMaxEndingHere = 0
    // Sum of maximumSubarray that ends at the traversing index
    var maxEndingHere = array[0]
    
    for i in (1..<array.count) {
        // Update the `maxEndingHere`
        if maxEndingHere + array[i] > array[i] {
            maxEndingHere = maxEndingHere + array[i]
        } else {
            maxEndingHere = array[i]
            startOfMaxEndingHere = i
        }

        // Update the `maxSoFar`
        if maxSoFar < maxEndingHere {
            maxSoFar = maxEndingHere
            start = startOfMaxEndingHere
            end = i
        }
    }
    
    return Array(array[start...end])
}

// Test

import XCTest

// List mixed with positive and negative numbers
let arrayA = [13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, 7]
let resultA = [18, 20, -7, 12]
XCTAssertEqual(maximumSubarray(arrayA), resultA)

// List with all positive numbers
let arrayB = [2, 3, 8, 2, 7]
XCTAssertEqual(maximumSubarray(arrayB), arrayB)

// List with all negative numbers
let arrayC = [-2, -3, -1, -2, -3]
let resultC = [-1]
XCTAssertEqual(maximumSubarray(arrayC), resultC)

// List with one element
let arrayD = [-8]
XCTAssertEqual(maximumSubarray(arrayD), arrayD)
