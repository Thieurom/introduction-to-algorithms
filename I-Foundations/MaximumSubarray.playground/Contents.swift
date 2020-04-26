/// Maximum Subarray

// Brute-force
// Complexity O(n^2)
func maximumSubarrayBruteForce(_ array: [Int]) -> [Int] {
    assert(!array.isEmpty)
    
    var maxSum = Int.min
    var start = 0
    var end = 0
    
    for i in 0..<array.count {
        var sum = 0
        
        for j in i..<array.count {
            sum += array[j]
            
            if sum > maxSum {
                maxSum = sum
                start = i
                end = j
            }
        }
    }
    
    return Array(array[start...end])
}

// Divide-and-conquer
// Complexity O(n*lgn)
func maximumSubarray(_ array: [Int]) -> [Int] {
    typealias Result = (start: Int, end: Int, sum: Int)
    
    // Find the maximum subarray that crosses the midPoint.
    // The given array must contain 2 elements at least.
    // And the result subarray also must contain 2 elements at least:
    // the rightmost element before the `midPoint` and the leftmost element after the `midPoint`.
    // The `midPoint` here considered the first index of the right. So the result is that `start < midPoint <= end`
    // Running time is O(n)
    func _maximumCrossing(_ array: [Int], midPoint: Int) -> Result {
        precondition(array.count >= 2 && midPoint >= 0 && midPoint < array.count)
        
        var start = midPoint - 1
        var leftMaxSum = Int.min
        var sum = 0
        for i in (0..<midPoint).reversed() {
            sum += array[i]
            if sum > leftMaxSum {
                leftMaxSum = sum
                start = i
            }
        }
        
        var end = midPoint
        var rightMaxSum = Int.min
        sum = 0
        for j in (midPoint..<array.count) {
            sum += array[j]
            if sum > rightMaxSum {
                rightMaxSum = sum
                end = j
            }
        }
        
        return (start, end, leftMaxSum + rightMaxSum)
    }
        
    // Find maximum subarray
    // Running time is O(n*lgn)
    func _maximumSubarray(_ array: [Int]) -> Result {
        assert(!array.isEmpty)
        
        if array.count == 1 { return (0, 0, array.first!) }
        
        // We divide the array into 2 subarrays of equal size.
        let mid = array.count / 2
        
        // Recursively find the maximum subarray of left half
        let leftResult = _maximumSubarray(Array(array[0..<mid]))
        
        // Recursively find the maximum subarray of left half
        let rightResult = _maximumSubarray(Array(array[mid..<array.count]))
        
        // Find the maximum subbaray crossing the `midPoint`
        let crossingResult = _maximumCrossing(array, midPoint: mid)
        
        // The result must be one of above 3 subarrays
        return [leftResult, rightResult, crossingResult]
            .reduce(leftResult) { (current, next) -> Result in
                return next.sum > current.sum ? next : current
        }
    }
    
    let (start, end, _) = _maximumSubarray(array)
    return Array(array[start...end])
}

// Test

import XCTest

let list = [13, -3, -25, 20, -3, -16, -23, 18, 20, -7, 12, -5, -22, 15, -4, 7]
let result = [18, 20, -7, 12]

XCTAssertEqual(maximumSubarrayBruteForce(list), result)
XCTAssertEqual(maximumSubarray(list), result)
