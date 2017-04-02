import Foundation
import UIKit


/// 2D Grid with a given size
struct Grid {
    let blockSize: Size
    
    /// horizontal block count, the width of the grid
    let columnCount: Int
    
    /// vertical block count, the height of the grid
    let rowCount: Int
    
    /// boundary of the grid
    let boundary: Boundary
    
    
    /// rounded, towards zero, center coordinate of the grid
    var center: Coordinate {
        return Coordinate(x: columnCount/2, y: rowCount/2)
    }
    
    init(fitIntoRect rect: CGRect, blockSize: Size) {
        let gridWidth = Int(rect.width)/blockSize.width
        let gridHeight = Int(rect.height)/blockSize.height
        self.init(columnCount: gridWidth, rowCount: gridHeight, blockSize: blockSize)
    }
    init(columnCount: Int, rowCount: Int, blockSize: Size) {
        self.blockSize = blockSize
        self.columnCount = columnCount
        self.rowCount = rowCount
        self.boundary = Boundary(width: columnCount, height: rowCount)
    }
    
    /// calculates if a given `Coordinate` is inside the boundaries of the grid
    ///
    /// - Parameter coordinate: coordinate
    /// - Returns: true if the point is inside the grid, otherwise false
    func isCoordinateInsideGrid(_ coordinate: Coordinate) -> Bool {
        return coordinate.x >= 0 && coordinate.x < columnCount &&
            coordinate.y >= 0 && coordinate.y < rowCount
    }
    
    /// calculates a random `Coordinate` which is inside the boundary
    ///
    /// - Returns: random coordinate inside the boundaries
    func randomCoordinateInsideGrid() -> Coordinate {
        let x = arc4random_uniform(UInt32(columnCount))
        let y = arc4random_uniform(UInt32(rowCount))
        return Coordinate(x: Int(x), y: Int(y))
    }
}
