/// Heap data structure
public struct Heap<Element> {
    private var elements: [Element]
    private let order: (Element, Element) -> Bool
    
    /// Construct the heap from an unordered array.
    /// O(n)
    public init(elements: [Element] = [], order: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.order = order
        
        if !elements.isEmpty {
            for index in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
                heapify(at: index)
            }
        }
    }
    
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    public var size: Int {
        return elements.count
    }
    
    /// Return the root element
    /// O(1)
    public var root: Element? {
        return elements.first
    }
}

// Index calculation
extension Heap {
    public func leftChildIndex(_ index: Int) -> Int {
        return 2 * index + 1
    }
    
    public func rightChildIndex(_ index: Int) -> Int {
        return 2 * index + 2
    }
    
    public func parentIndex(_ index: Int) -> Int {
        return (index + 1) / 2
    }
}

extension Heap: CustomStringConvertible {
    public var description: String {
        return String(describing: elements)
    }
}

//
extension Heap {
    // Maintain the heap property.
    // O(lgn)
    // Since this method mutate `self` and we don't want to make copy,
    // we implement iteratively instead of recursively.
    
    // NOTE: Normally this method is publicly declared, then can be used when implementing HeapSort.
    // But I feel that this should be marked as private. The ability (and responsibility) of maitaining
    // the heap property should belong to itself, not the outside world.
    // It will do that work when the outside wants to make some mutations like adding, removing elements, ...
    mutating private func heapify(at index: Int) {
        var current = index
        
        while true {
            let left = leftChildIndex(current)
            let right = rightChildIndex(current)
            var next = current
            
            if left < size && order(elements[left], elements[next]) {
                next = left
            }
            
            if right < size && order(elements[right], elements[next]) {
                next = right
            }

            if next == current { return }
            
            elements.swapAt(next, current)
            current = next
        }
    }
    
    /// Remove and return the root noode.
    /// O(lgn)
    mutating public func removeRoot() -> Element? {
        guard !elements.isEmpty else { return nil }
        
        elements.swapAt(0, size - 1)
        defer {
            heapify(at: 0)
        }
                
        return elements.removeLast()
    }
}
