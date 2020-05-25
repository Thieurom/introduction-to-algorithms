/// Number of Inversions

// Naive implementation
// Complexity n^2
func inefficientCountInversions(_ numbers: [Int]) -> Int {
    var count = 0
    
    for i in 0..<numbers.count-1 {
        var currentCount = 0
        
        for j in i..<numbers.count {
            if numbers[i] > numbers[j] {
                currentCount += 1
            }
        }
        
        count += currentCount
    }
    
    return count
}

// Modified merge sort
// Complexity nlg(n)

func countInversions(_ numbers: [Int]) -> Int {
    // Merge 2 sorted halves of a list so that it becomes sorted.
    // It also returns the number of inversions of the form (i, j),
    // where i is in the first half and j is in the second half of that list.
    func mergeAndCount(_ numbers: inout [Int], start: Int, mid: Int, end: Int) -> Int {
        let left = Array(numbers[start...mid])
        let right = Array(numbers[mid+1...end])
        
        var count = 0
        var i = 0, j = 0
        
        for k in start...end {
            if i > mid - start {
                numbers[k] = right[j]
                j += 1
            } else if j > end - (mid + 1) {
                numbers[k] = left[i]
                i += 1
            } else if left[i] > right[j] {
                numbers[k] = right[j]
                j += 1
                count += (mid - start + 1) - i
            } else {
                numbers[k] = left[i]
                i += 1
            }
        }
        
        return count
    }
    
    // Sort and return the number of inversions in the list.
    // Note: `to` is inclusive
    func sortAndCount(_ numbers: inout [Int], from: Int, to: Int) -> Int {
        guard from < to else { return 0 }
        
        let midIndex = (from + to) >> 1
        
        let leftCount = sortAndCount(&numbers, from: from, to: midIndex)
        let rightCount = sortAndCount(&numbers, from: midIndex + 1, to: to)

        return leftCount + rightCount + mergeAndCount(&numbers, start: from, mid: midIndex, end: to)
    }

    // Make a copy of given list of numbers since we'll mutate it during running.
    var list = numbers
    
    return sortAndCount(&list, from: 0, to: list.count - 1)
}

// Tests
import XCTest

XCTAssertEqual(inefficientCountInversions([2, 3, 8, 6, 1]), 5)
XCTAssertEqual(countInversions([2, 3, 8, 6, 1]), 5)
