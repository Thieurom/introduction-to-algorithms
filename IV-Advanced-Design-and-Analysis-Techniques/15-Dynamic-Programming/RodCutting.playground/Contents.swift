// Rod cutting

// Time: O(n^2)
// Space: O(n)
// Return the optimal revenue
func cutRod(length: Int, basePrices: [Int]) -> Int {
    precondition(basePrices.count >= length && length >= 0 && basePrices.allSatisfy({ $0 >= 0 }))
        
    // The optimal revenues when solving rod cutting with length from 0 to `length` units.
    var revenues = Array(repeating: 0, count: length + 1)
    // The optimal sizes of the first piece to cut off when solving rod cutting with specific length
    var cuts = Array(repeating: 0, count: length)
    
    for i in (1...length) {
        var revenue = -1

        for j in (1...i) {
            if prices[j - 1] + revenues[i - j] > revenue {
                revenue = prices[j - 1] + revenues[i - j]
                cuts[i - 1] = j
            }
        }
        
        revenues[i] = revenue
    }
    
    return revenues[length]
}

// Return the list of Optimal revenues and First cuts of each optimal solution
func extendedCutRod(length: Int, basePrices: [Int]) -> (revenues: [Int], firstCuts: [Int]) {
    precondition(basePrices.count >= length && length >= 0 && basePrices.allSatisfy({ $0 >= 0 }))
        
    var revenues = Array(repeating: 0, count: length + 1)
    var firstCuts = Array(repeating: 0, count: length)
    
    for i in (1...length) {
        var revenue = -1

        for j in (1...i) {
            if prices[j - 1] + revenues[i - j] > revenue {
                revenue = prices[j - 1] + revenues[i - j]
                firstCuts[i - 1] = j
            }
        }
        
        revenues[i] = revenue
    }
    
    return (revenues, firstCuts)
}

// Print the cuts for optimal solution
func printCutRod(length: Int, basePrices: [Int]) {
    let (_, firstCuts) = extendedCutRod(length: length, basePrices: basePrices)
    
    var l = length
    var text = ""
    
    while l > 0 {
        text = text + "\(firstCuts[l - 1]) "
        l -= firstCuts[l - 1]
    }
        
    print("Cuts for rod with length of \(length):", text)
}


// Test
let prices = [1, 5, 8, 9, 10, 17, 17, 20, 24, 30]

for rodLength in (1...10) {
    printCutRod(length: rodLength, basePrices: prices)
}
