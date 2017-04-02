import Foundation


/// A `Collidable` can test if it intersects with a given coordinate or not
protocol Collidable {
    
    /// tests if it intersects with a given coordinate or not
    ///
    /// - Parameter coordinate: coordinate to test for intersction
    /// - Returns: true if the `Collidable` itersects with the given coordinate, otherwise false
    func intersect(with coordinate: Coordinate) -> Bool
}

extension Sequence where Iterator.Element: Collidable {
    
    /// tests if any `Collidable` in the sequence intersects with a given coordinate or not
    ///
    /// - Parameter coordinate: coordinate to test for intersction
    /// - Returns: true if any `Collidable` in the sequence itersects with the given coordinate, otherwise false
    func intersect(with coordinate: Coordinate) -> Bool {
        return self.contains(where: { (collidable) -> Bool in
            return collidable.intersect(with: coordinate)
        })
    }
}

extension Optional where Wrapped: Collidable {
    
    /// unwraps the `Optinal` and tests if it intersects with a given coordinate or not
    ///
    /// - Parameter coordinate: coordinate to test for intersction
    /// - Returns: true if `Optinal` holds some value and the `Collidable` itersects with the given coordinate, otherwise false
    func intersect(with coordinate: Coordinate) -> Bool {
        switch self {
        case .some(let collidable): return collidable.intersect(with: coordinate)
        case .none: return false
        }
    }
}
