/// Matrix
struct Matrix<Value> where Value: Numeric {
    let rows: Int
    let columns: Int
    private var grid: Array<Value>
    
    init(rows: Int, columns: Int, initialValue: Value = 0) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: initialValue, count: rows * columns)
    }
}

// MARK: - Getters/Setters

extension Matrix {
    private func rowIsValid(_ row: Int) -> Bool {
        return row >= 0 && row < rows
    }
    
    private func columnIsValid(_ column: Int) -> Bool {
        return column >= 0 && column < columns
    }
    
    private func indexIsValid(row: Int, column: Int) -> Bool {
        return rowIsValid(row) && columnIsValid(column)
    }
    
    subscript(row: Int, column: Int) -> Value {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range.")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range.")
            grid[(row * columns) + column] = newValue
        }
    }
    
    subscript(row row: Int) -> [Value] {
        get {
            assert(rowIsValid(row), "Row out of range.")
            
            let lower = row * columns
            let upper = row * columns + columns
            return Array(grid[lower..<upper])
        }
        set {
            assert(rowIsValid(row), "Row out of range.")
            assert(newValue.count == columns, "Each matrix's row has \(columns) items, you gave it \(newValue.count).")
            
            for (index, value) in newValue.enumerated() {
                grid[index + row * columns] = value
            }
        }
    }
    
    subscript(column column: Int) -> [Value] {
        get {
            assert(columnIsValid(column), "Column out of range.")
            
            let indices = stride(from: column, to: column + rows * columns, by: columns)
            return indices.map({ grid[$0] })
        }
        set {
            assert(columnIsValid(column), "Column out of range.")
            assert(newValue.count == rows, "Each matrix's column has \(columns) items, you gave it \(newValue.count).")
            
            for (index, value) in newValue.enumerated() {
                grid[column + index * columns] = value
            }
        }
    }
}

// MARK: - Description

extension Matrix: CustomStringConvertible {
    var description: String {
        var string = ""
        
        for i in 0..<rows {
            let currentRow = self[row: i]
            string.append(currentRow.map { String(describing: $0) }.joined(separator: " "))
            string.append("\n")
        }
        
        return string
    }
}

// MARK: - Matrix's basic arithmetic operations: Add and Substract

extension Matrix {
    static func + (lhs: Matrix, rhs: Matrix) -> Matrix {
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must be the same size.")
        
        var result = Matrix(rows: lhs.rows, columns: lhs.columns)
        
        for index in (0..<lhs.rows * lhs.columns) {
            let row = index / lhs.columns
            let column = index % lhs.columns
            result[row, column] = lhs[row, column] + rhs[row, column]
        }
        
        return result
    }
    
    static func - (lhs: Matrix, rhs: Matrix) -> Matrix {
        precondition(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrices must be the same size.")
        
        var result = Matrix(rows: lhs.rows, columns: lhs.columns)
        
        for index in (0..<lhs.rows * lhs.columns) {
            let row = index / lhs.columns
            let column = index % lhs.columns
            result[row, column] = lhs[row, column] - rhs[row, column]
        }
        
        return result
    }
}

// MARK: - Matrix's multiplication operation.

extension Matrix {
    var isSquare: Bool {
        return rows == columns
    }
    
    enum MultiplicationMethod {
        case canonical  // O(n^3)
        case plainDC    // Plain divide-and-conquer: O(n^3)
        case strassen   // Strassen divide-and-conquer: O(n^lg7)
    }
    
    func multiply(by other: Matrix, method: MultiplicationMethod = .strassen) -> Matrix {
        precondition(self.columns == other.rows, "Multiply 2 matrices, one must has dimensions mxn, the other has dimension nxp")

        switch method {
        case .canonical:
            return bruteForceMultiply(by: other)
            
        case .plainDC, .strassen:
            // padding the arrays if necessary
            let maxDimension = max(self.rows, self.columns, other.rows, other.columns)
            let paddedSize = maxDimension.nextPowerOfTwo()
            
            // Extend 2 arrays, padded with zero(s)
            var paddedSelf = self.squarePadded(size: paddedSize)
            var paddedOther = other.squarePadded(size: paddedSize)
            
            let paddedResult = method == .strassen
                ? paddedSelf._strassenMatrixMultiply(by: paddedOther)
                : paddedSelf._divideConquerMultiply(by: paddedOther)
            
            var result = Matrix(rows: self.rows, columns: other.columns)
            
            for i in (0..<self.rows) {
                for j in (0..<other.columns) {
                    result[i, j] = paddedResult[i, j]
                }
            }
            
            return result
        }
    }
    
    // Padding the matrix in to square matrix.
    // O(n^2)
    private func squarePadded(size: Int) -> Matrix {
        precondition(size >= rows && size >= columns)
        
        var padded = Matrix(rows: size, columns: size)
        
        for i in (0..<rows) {
            for j in (0..<columns) {
                padded[i, j] = self[i, j]
            }
        }
        
        return padded
    }
    
    /// Multiply 2 matrices, one has dimensions mxl, the other has dimension lxk
    /// Use straight forward brute force
    /// Time complexity is O(n^3)
    func bruteForceMultiply(by other: Matrix) -> Matrix {
        precondition(self.columns == other.rows, "Multiply 2 matrices, one must has dimensions mxl, the other has dimension lxk")
        
        var result = Matrix(rows: self.rows, columns: other.columns)
        
        for i in (0..<self.rows) {
            for j in (0..<other.columns) {
                result[i, j] = self[row: i].sumProduct(with: other[column: j])
            }
        }
        
        return result
    }
    
    // Multiply 2 matrices, one has dimensions mxn, the other has dimension nxp
    // Use a straight forward divide-and-conquer method
    // Time complexity is O(n^3)
    func _divideConquerMultiply(by other: Matrix) -> Matrix {
        precondition(self.isSquare && other.isSquare && self.rows == other.rows, "----")
        
        var result = Matrix(rows: self.rows, columns: other.rows)
        let items = self.rows
        
        if items == 1 {
            result[0, 0] = self[0, 0] * other[0, 0]
        } else {
            let itemsBy2 = items / 2
            
            var l11 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var l12 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var l21 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var l22 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var r11 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var r12 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var r21 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var r22 = Matrix(rows: itemsBy2, columns: itemsBy2)
            
            for i in 0..<itemsBy2 {
                for j in 0..<itemsBy2 {
                    l11[i, j] = self[i, j]
                    l12[i, j] = self[i, j + itemsBy2]
                    l21[i, j] = self[i + itemsBy2, j]
                    l22[i, j] = self[i + itemsBy2, j + itemsBy2]
                    r11[i, j] = other[i, j]
                    r12[i, j] = other[i, j + itemsBy2]
                    r21[i, j] = other[i + itemsBy2, j]
                    r22[i, j] = other[i + itemsBy2, j + itemsBy2]
                }
            }
            
            let p1 = l11._divideConquerMultiply(by: r11) + l12._divideConquerMultiply(by: r21)
            let p2 = l11._divideConquerMultiply(by: r12) + l12._divideConquerMultiply(by: r22)
            let p3 = l21._divideConquerMultiply(by: r11) + l22._divideConquerMultiply(by: r21)
            let p4 = l21._divideConquerMultiply(by: r12) + l22._divideConquerMultiply(by: r22)
            
            for i in 0..<itemsBy2 {
                for j in 0..<itemsBy2 {
                    result[i, j] = p1[i, j]
                    result[i, j + itemsBy2] = p2[i, j]
                    result[i + itemsBy2, j] = p3[i, j]
                    result[i + itemsBy2, j + itemsBy2] = p4[i, j]
                }
            }
        }
        
        return result
    }
    
    // Multiply 2 matrices, one has dimensions mxn, the other has dimension nxp
    // Use Strassen's method
    // Time complexity is O(n^lg7)
    func _strassenMatrixMultiply(by other: Matrix) -> Matrix {
        precondition(self.isSquare && other.isSquare && self.rows == other.rows, "----")
        
        var result = Matrix(rows: self.rows, columns: other.rows)
        let items = self.rows
        
        if items == 1 {
            result[0, 0] = self[0, 0] * other[0, 0]
        } else {
            let itemsBy2 = items / 2
            
            var l11 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var l12 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var l21 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var l22 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var r11 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var r12 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var r21 = Matrix(rows: itemsBy2, columns: itemsBy2)
            var r22 = Matrix(rows: itemsBy2, columns: itemsBy2)
            
            for i in 0..<itemsBy2 {
                for j in 0..<itemsBy2 {
                    l11[i, j] = self[i, j]
                    l12[i, j] = self[i, j + itemsBy2]
                    l21[i, j] = self[i + itemsBy2, j]
                    l22[i, j] = self[i + itemsBy2, j + itemsBy2]
                    r11[i, j] = other[i, j]
                    r12[i, j] = other[i, j + itemsBy2]
                    r21[i, j] = other[i + itemsBy2, j]
                    r22[i, j] = other[i + itemsBy2, j + itemsBy2]
                }
            }
            
            let p1 = l11._strassenMatrixMultiply(by: r12 - r22)
            let p2 = (l11 + l12)._strassenMatrixMultiply(by: r22)
            let p3 = (l21 + l22)._strassenMatrixMultiply(by: r11)
            let p4 = l22._strassenMatrixMultiply(by: r21 - r11)
            let p5 = (l11 + l22)._strassenMatrixMultiply(by: r11 + r22)
            let p6 = (l12 - l22)._strassenMatrixMultiply(by: r21 + r22)
            let p7 = (l11 - l21)._strassenMatrixMultiply(by: r11 + r12)
            
            let c1 = p5 + p4 - p2 + p6
            let c2 = p1 + p2
            let c3 = p3 + p4
            let c4 = p1 + p5 - p3 - p7
            
            for i in 0..<itemsBy2 {
                for j in 0..<itemsBy2 {
                    result[i, j] = c1[i, j]
                    result[i, j + itemsBy2] = c2[i, j]
                    result[i + itemsBy2, j] = c3[i, j]
                    result[i + itemsBy2, j + itemsBy2] = c4[i, j]
                }
            }
        }
        
        return result
    }
}

// MARK: - Extensions for Standard Library
import Darwin

extension Array where Element: Numeric {
    // O(n)
    func sumProduct(with other: Array<Element>) -> Element {
        precondition(self.count == other.count, "Two arrays must be the same size.")
        
        return zip(self, other)
            .reduce(0) { $0 + $1.0 * $1.1 }
    }
}

extension Int {
    func nextPowerOfTwo() -> Int {
      let logN = log2(Double(self))
      let ceilLogN = ceil(logN)
      let nextPowerOfTwo = pow(2, ceilLogN)
      return Int(nextPowerOfTwo)
    }
}

// Tests

var a = Matrix<Int>(rows: 4, columns: 4)
a[row: 0] = [1, 2, 3, 4]
a[row: 1] = [2, 3, 4, 1]
a[row: 2] = [3, 4, 1, 2]
a[row: 3] = [4, 1, 2, 3]

var b = Matrix<Int>(rows: 4, columns: 4)
b[column: 0] = [5, 6, 7, 8]
b[column: 1] = [6, 7, 8, 5]
b[column: 2] = [7, 8, 5, 6]
b[column: 3] = [8, 5, 6, 7]

let ab1 = a.multiply(by: b, method: .canonical)
print(ab1)

let ab2 = a.multiply(by: b, method: .plainDC)
print(ab2)

let ab3 = a.multiply(by: b, method: .strassen)
print(ab3)

var c = Matrix<Int>(rows: 3, columns: 4)
c[row: 0] = [1, 2, 3, 4]
c[row: 1] = [2, 3, 4, 1]
c[row: 2] = [3, 4, 1, 2]

var d = Matrix<Int>(rows: 4, columns: 2)
d[row: 0] = [5, 6]
d[row: 1] = [6, 7]
d[row: 2] = [7, 8]
d[row: 3] = [8, 5]

let cd1 = c.multiply(by: d, method: .canonical)
print(cd1)

let cd2 = c.multiply(by: d, method: .plainDC)
print(cd2)

let cd3 = c.multiply(by: d, method: .strassen)
print(cd3)
