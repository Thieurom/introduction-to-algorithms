// Quick Sort

extension Array where Element: Comparable {
    /// Sorts the collection using Quick Sort algorithm.
    /// - Returns: A sorted array of the sequence's elements.
    /// - Complexity: Average case: O(*n* log *n*), where *n* is the length of the sequence.
    func quickSorted() -> [Element] {
        // Partitioning the array, always select the last element as the pivot
        func partitioning(array: inout [Element], low: Int, high: Int) -> Int {
            let pivot = array[high]
            var firstHigh = low
            
            for i in (low..<high) {
                if array[i] <= pivot {
                    array.swapAt(i, firstHigh)
                    firstHigh += 1
                }
            }
            
            array.swapAt(high, firstHigh)
            return firstHigh
        }
        
        // Random selecting the pivot
        func randomizedPartitioning(array: inout [Element], low: Int, high: Int) -> Int {
            let i = Int.random(in: (low...high))
            array.swapAt(high, i)
            return partitioning(array: &array, low: low, high: high)
        }
        
        func _quickSort(array: inout [Element], low: Int, high: Int) {
            if low < high {
                let pivotIndex = randomizedPartitioning(array: &array, low: low, high: high)
                _quickSort(array: &array, low: low, high: pivotIndex - 1)
                _quickSort(array: &array, low: pivotIndex + 1, high: high)
            }
        }
        
        // Make a copy
        var needToSort = self
        // Sort in place
        _quickSort(array: &needToSort, low: 0, high: needToSort.count - 1)
        // Return the sorted
        return needToSort
    }
}


// Test
import XCTest

let numbers = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0]
XCTAssertEqual(numbers.quickSorted(), [-1, 0, 1, 2, 3, 3, 5, 8, 9, 10, 27])
