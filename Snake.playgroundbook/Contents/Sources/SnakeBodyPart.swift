import Foundation
import UIKit



/// A SnakeBodyPart is one block of a snake
final class SnakeBodyPart: BlockView, LinkedListElement, Collidable {
    weak var previousElement: SnakeBodyPart?
    var nextElement: SnakeBodyPart?
    
    
    /// creates a copy of the current snake with the same coordinate, color and size but not the same previous and next element
    ///
    /// - Returns: <#return value description#>
    func makeCopy() -> SnakeBodyPart {
        return SnakeBodyPart(coordinate: coordinate, color: color, size: size)
    }
    
    /// moves a snake in the specified direction
    ///
    /// - Parameter direction: normalized direction vector
    func move(in direction: Coordinate) {
        coordinate += direction
    }
    
    /// tests if a given coordinate is equal to the coorinate of the snake body part
    ///
    /// - Parameter coordinate: coordinate
    /// - Returns: true if the snake body part intersects with the given coordinate, otherwise false
    func intersect(with coordinate: Coordinate) -> Bool {
        return self.coordinate == coordinate
    }
}
