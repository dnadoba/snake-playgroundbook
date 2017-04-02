import Foundation


/// Boundary of a Grid
struct Boundary: Collidable {
    
    /// width of the grid
    let width: Int
    
    /// height of the grid
    let height: Int
    
    /// tests if a given coordinate is not inside the grid
    ///
    /// - Parameter coordinate: given coordinate
    /// - Returns: false if the point is inside the grid, otherwise true
    func intersect(with coordinate: Coordinate) -> Bool {
        return coordinate.x < 0 || coordinate.y < 0 ||
            coordinate.x >= width || coordinate.y >= height
    }
}
