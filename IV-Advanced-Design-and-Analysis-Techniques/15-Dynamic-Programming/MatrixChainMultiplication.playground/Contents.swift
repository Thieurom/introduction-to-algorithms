/// Matrix chain order
/// - Parameter dimensions: The dimensions of matrices.
///   This `dimensions` represents the chain of matrices such that the ith matrix `Ai` is of dimension `dimensions[i-1] x dimensions[i]`.
///   For eg: `[10, 20, 5, 15]` represents 3 matrices: `10x20`, `20x5`, `5x15`
/// - Complexity: `O(n^3)`
/// - Returns: A tuple consists of costs and positions.
///   - The costs: the minimum number of scalar multiplications.
///   `costs[i][j]` is the cost needed to compute the product `AiAi+1...Aj`
///   - The positions: `positions[i][j]` is the value of `k` at which we split the product `AiAi+1...Aj` in an optimal parenthesization.
func matrixChainOrder(dimensions: [Int]) -> (costs: [[Int]], positions: [[Int]]) {
    precondition(dimensions.allSatisfy({ $0 > 0 }))
    
    let n = dimensions.count - 1
    
    var costs = Array(repeating: Array(repeating: -1, count: n + 1), count: n + 1)
    var positions = Array(repeating: Array(repeating: -1, count: n + 1), count: n + 1)
    
    for i in (1...n) {
        costs[i][i] = 0
    }
    
    for l in (2...n) {
        for i in (1...n-l+1) {
            let j = i + l - 1
            costs[i][j] = Int.max
            
            for k in (i...j-1) {
                let cost = costs[i][k] + costs[k+1][j] + dimensions[i-1]*dimensions[k]*dimensions[j]
                
                if cost < costs[i][j] {
                    costs[i][j] = cost
                    positions[i][j] = k
                }
            }
        }
    }
    
    return (costs, positions)
}

func optimalParens(s: [[Int]], i: Int, j: Int) -> String {
    if i == j {
        return "A\(i)"
    } else {
        return "("
            + optimalParens(s: s, i: i, j: s[i][j])
            + "x"
            + optimalParens(s: s, i: s[i][j] + 1, j: j)
            + ")"
    }
}

// Test
let dimensions = [30, 35, 15, 5, 10, 20, 25]
let s = matrixChainOrder(dimensions: dimensions)
print(optimalParens(s: s.positions, i: 1, j: 6))  // It should print out: ((A1x(A2xA3))x((A4xA5)xA6))
