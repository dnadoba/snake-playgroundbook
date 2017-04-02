import Foundation
import UIKit

private let rainbowStart = UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)
private let rainbowEnd = UIColor(hue: 0.9, saturation: 1, brightness: 1, alpha: 1)


final class Snake: Collidable {
    enum ColorMode {
        case custom
        case rainbow
    }
    
    /// the view containing all body parts of the snake
    let view = UIView()
    private let bodyParts = LinkedList<SnakeBodyPart> ()
    
    /// number of body parts
    var length: Int {
        return bodyParts.count
    }
    let startLength: Int
    /// the first body part of the snake
    var head: SnakeBodyPart {
        return bodyParts.head!
    }
    
    /// the last body part of the snake
    var tail: SnakeBodyPart {
        return bodyParts.tail!
    }
    private(set) var tailColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
    private(set) var headColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    private let moveSoundPlayer = SoundPlayer(sound: .move)
    private let enableRainbowSoundPlayer = SoundPlayer(sound: .levelUp)
    var mode: ColorMode = .custom {
        didSet {
            updateSnakeGradient()
        }
    }
    private(set) var facingDirection: Direction
    private var previousFacingDirection: Direction
    
    
    init(startCoordinate: Coordinate, facingDirection: Direction, length: Int, bodyPartSize: Size) {
        precondition(length >= 3, "A snake must consist of at least three body parts. Make a snake with the length of 3 or greater.")
        startLength = length
        self.facingDirection = facingDirection
        self.previousFacingDirection = facingDirection
        let snakeRange = 0..<length
        let bodyParts = snakeRange.map { bodyPartIndex -> SnakeBodyPart in
            let offset = Coordinate(facingDirection) * bodyPartIndex
            let coordinate = startCoordinate + offset
            
            return SnakeBodyPart(coordinate: coordinate, color: headColor, size: bodyPartSize)
        }
        bodyParts.forEach(self.bodyParts.appendLast)
        bodyParts.forEach(view.addSubview)
        updateSnakeGradient()
    }
    
    /// checks if the coordinate is on the snakes body or the head
    ///
    /// - Parameter coordinate: coordinate
    /// - Returns: true if the snake is on the snake =, otherwise false
    func intersect(with coordinate: Coordinate) -> Bool {
        return bodyParts.intersect(with: coordinate)
    }
    
    /// checks if the coordinate is on the snakes body and not the head
    ///
    /// - Parameter coordinate: coordinate on the snake
    /// - Returns: true if the coordinate is on the snakes body, otherwise false
    func intersectWithCoordinateExcludingHead(_ coordinate: Coordinate) -> Bool {
        let bodyPartsExculdingHead = bodyParts.filter { (bodyPart) -> Bool in
            bodyPart != head
        }
        return bodyPartsExculdingHead.intersect(with: coordinate)
    }
    /// calculates the next coordinate of the head if it would move in the given direction
    ///
    /// - Returns: next head coordinate
    private func nextHeadCoordinate(for direction: Coordinate) -> Coordinate {
        let currentHeadCoordinate = head.coordinate
        return currentHeadCoordinate + direction
    }
    
    /// calculates the next coordinate of the head if it would move in the facing direction
    ///
    /// - Returns: next head coordinate in facing direction
    func nextHeadCoordinateInFacingDirection() -> Coordinate {
        let nextCoordinate = nextHeadCoordinate(for: Coordinate(facingDirection))
        return nextCoordinate
    }
    
    /// changes the snake facing direction for the next operations on the snake like move/extend if it is not the opposite of the previous facing direction
    ///
    /// - Parameter direction: direction in which the snake should look
    func changeFacingDirection(to direction: Direction) {
        if self.previousFacingDirection.opposite != direction {
            self.facingDirection = direction
        }
    }
    /// extends the snake in the current facing direction, animated with a given duration
    ///
    /// - Parameter duration: animation duration
    func extendInFacingDirection(duration: TimeInterval) {
        extend(in: Coordinate(facingDirection), duration: duration)
        moveSoundPlayer.completionDuration = duration
        moveSoundPlayer.play()
    }
    
    /// moves the snake in the current facing direction, animated with a given duration
    ///
    /// - Parameter duration: animation duration
    func moveInFacingDirection(duration: TimeInterval) {
        move(in: Coordinate(facingDirection), duration: duration)
        moveSoundPlayer.completionDuration = duration
        moveSoundPlayer.play()
    }
    /// moves the snake in a given direction, animated with a given durection
    ///
    /// - Parameters:
    ///   - direction: direction in which the snake should move
    ///   - duration: animation duration
    private func move(in direction: Coordinate, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            var nextPosition = self.nextHeadCoordinate(for: direction)
            for bodyPart in self.bodyParts.makeReversedIterator() {
                let direction = nextPosition - bodyPart.coordinate
                nextPosition = bodyPart.coordinate
                bodyPart.move(in: direction)
            }
        }
        didMoveOrExtend()
    }
    
    /// extend the snake in a given direction, animated with a given durection
    ///
    /// - Parameters:
    ///   - direction: direction in which the snake should extend
    ///   - duration: animation duration
    private func extend(in direction: Coordinate, duration: TimeInterval) {
        
        let currentHead = self.head
        let newHead = currentHead.makeCopy()
        self.view.addSubview(newHead)
        self.bodyParts.appendLast(newHead)
        UIView.animate(withDuration: duration) {
            newHead.coordinate += direction
        }
        BlockView.animateColor(withDuration: duration) { 
            updateSnakeGradient()
        }
        didMoveOrExtend()
    }
    
    private func didMoveOrExtend() {
        self.previousFacingDirection = self.facingDirection
    }
    
    
    /// enables the rainbow mode if it is not already enabled
    func enableRainbowMode() {
        guard mode != .rainbow  else { return }
        BlockView.animateColor(withDuration: 1.5) {	
            self.mode = .rainbow
        }
        enableRainbowSoundPlayer.play()
    }
    
    /// updates color of each body part
    private func updateSnakeGradient() {
        let maxIndex = CGFloat(bodyParts.count - 1)
        for (index, bodyPart) in bodyParts.enumerated() {
            let amount = CGFloat(index)/maxIndex
            bodyPart.color = interpolatedColor(by: amount)
        }
    }
    
    /// calculates an interpolated color at a given position of the snake
    ///
    /// - Parameter amount: number between 0 and 1
    /// - Returns: interpolated color matching the tail and head color or a rainbow mode if the current mode is set to rainbow
    private func interpolatedColor(by amount: CGFloat) -> UIColor {
        switch mode {
        case .custom:
            return linearRgbaInterpolation(from: tailColor, to: headColor, by: amount)
        case .rainbow:
            return linearHsbaInterpolation(from: rainbowStart, to: rainbowEnd, by: amount)
        }
    }
    
    /// changes the tail and head color of the snake and update each `SnakeBodyPart`
    ///
    /// - Parameters:
    ///   - tail: new snake end tail color
    ///   - head: new snake head color
    func changeColor(tail: UIColor, head: UIColor) {
        self.tailColor = tail
        self.headColor = head
        updateSnakeGradient()
    }
    
}
