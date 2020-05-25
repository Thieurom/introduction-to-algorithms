extension Array {
    /// Heapsort
    /// Time: O(n(lgn))
    /// Space: O(1) to create an immediate Heap
    mutating func heapSort(by areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        let reverseOrder = { e1, e2 in areInIncreasingOrder(e2, e1) }
        var heap = Heap(elements: self, order: reverseOrder)
        
        for index in (0..<count) {
            guard let root = heap.removeRoot() else { continue }
            self[index] = root
        }
    }
}

// Test
import XCTest

var list = [5, 13, 2, 25, 7, 17, 20, 8, 4]
list.heapSort(by: >)

XCTAssertEqual(list, [2, 4, 5, 7, 8, 13, 17, 20, 25])
