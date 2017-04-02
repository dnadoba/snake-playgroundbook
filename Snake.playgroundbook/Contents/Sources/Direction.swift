import Foundation
import UIKit

/// A `Direction` is a type which represents a direction on a 2D `Grid`
public enum Direction {
    case left
    case up
    case right
    case down
    
    
    /// returns the direction in the oposite direction, e.g. if the current direction is up, it returns down
    public var opposite: Direction {
        switch self {
        case .left: return .right
        case .up: return .down
        case .right: return .left
        case .down: return .up
        }
    }
}

extension Direction {
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

extension Coordinate {
    init(_ direction: Direction) {
        switch direction {
        case .left: self = .left
        case .up: self = .up
        case .right: self = .right
        case .down: self = .down
        }
    }
}
