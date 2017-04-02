import Foundation
import UIKit


/// A `Coordinate` is a 2D Point on the grid
struct Coordinate {
    var x: Int
    var y: Int
    
    
    /// calculates a coordinate in the opposit direction
    ///
    /// - Returns: <#return value description#>
    func negated() -> Coordinate {
        return Coordinate(x: -x, y: -y)
    }
}

// MARK: - Coordinate arithmetic operations
extension Coordinate {
    
    /// Scalar multiplication
    static func *(lhs: Coordinate, rhs: Int) -> Coordinate {
        return Coordinate(x: lhs.x * rhs, y: lhs.y * rhs)
    }
    /// Vector multiplication
    static func *(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    /// Vector multiplication
    static func *(lhs: Coordinate, rhs: Size) -> Coordinate {
        return Coordinate(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
    }
    
    /// Vector addition
    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    /// Vector subtraction
    static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    static func +=(lhs: inout Coordinate, rhs: Coordinate) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}

extension Coordinate: Equatable {
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Coordinate {
    static var up: Coordinate {
        return Coordinate(x: 0, y: -1)
    }
    static var down: Coordinate {
        return Coordinate(x: 0, y: 1)
    }
    static var left: Coordinate {
        return Coordinate(x: -1, y: 0)
    }
    static var right: Coordinate {
        return Coordinate(x: 1, y: 0)
    }
}

extension Coordinate {
    init(_ size: Size) {
        self.init(x: size.width, y: size.height)
    }
}

extension CGPoint {
    init(_ coordinate: Coordinate) {
        self.init(x: coordinate.x, y: coordinate.y)
    }
}

extension Coordinate {
    init(_ swipeDirection: UISwipeGestureRecognizerDirection) {
        if swipeDirection.contains(.up) {
            self = .up
        } else if swipeDirection.contains(.down) {
            self = .down
        } else if swipeDirection.contains(.left) {
            self = .left
        } else {
            self = .right
        }
    }
}
