import Foundation
import UIKit


/// the main snake game controller for the playground
public let ctrl = SnakeGameController()

/// creates a grid with the given size and wall color
///
/// - Parameters:
///   - width: width of the grid
///   - height: height of the grid
///   - wall: color of the boundary
public func makeGrid(width: Int, height: Int, wallColor wall: UIColor) {
    ctrl.game.makeGrid(width: width, height: height, wall: wall)
}

/// creates a snake with the given peroperties
///
/// - Parameters:
///   - length: start body part cound
///   - tail: end tail color of the snake
///   - head: head color of the snake
public func makeSnake(length: Int, tailColor tail: UIColor, headColor head: UIColor) {
    ctrl.game.makeSnake(length: length, tail: tail, head: head)
}

/// calculates if the snake head collides with any body part excluding the head itself
///
/// - Returns: true if the snake collides with itself, otherwise false
public func snakeIntersectWithItself() -> Bool {
    return ctrl.game.snakeIntersectWithItself()
}

/// checks if a wall is in front of the snake
///
/// - Returns: true if a wall is in front of the snake, othwerwise false
public func wallInFrontOfSnake() -> Bool {
    return ctrl.game.wallInFrontOfSnake()
}

public var calledChangeSnakeFacingDirection = false

/// changes the snake facing direction for the next operations on the snake like move/extend
///
/// - Parameter direction: direction in which the snake should look
public func changeSnakeFacingDirection(_ direction: Direction) {
    calledChangeSnakeFacingDirection = true
    ctrl.game.changeSnakeFaceingDirection(to: direction)
}

/// checks if a coin is in front of the snake
///
/// - Returns: true if a snake is present and a coin is in front of the snake, othwerwise false
public func coinInFrontOfSnake() -> Bool {
    return ctrl.game.coinInFrontOfSnake()
}

/// extends the snake in the current facing direction animated
public func extendSnakeInFacingDirection() {
    ctrl.game.extendSnakeInFacingDirection()
}

public var calledMoveSnakeInFacingDirection = false

/// moves the snake in the current facing direction animated
public func moveSnakeInFacingDirection() {
    calledMoveSnakeInFacingDirection = true
    ctrl.game.moveSnakeInFacingDirection()
}

/// collects the current coin, plays the collect coin sound, fades the coin out and increments the collected coins counter by 1
public func collectCoin() {
    ctrl.game.collectCoin()
}

/// places a coin on a random coordinate inside the grid which is not covered by the snake
///
/// - Parameter color: color of the coin
public func placeRandomCoin(_ color: UIColor) {
    ctrl.game.placeRandomCoin(color: color)
}

/// collected coins count by the snake
public var collectedCoins: Int {
    return ctrl.game.collectedCoins
}

/// enables the rainbow color mode of the snake
public func enableSnakeRainbowMode() {
    ctrl.game.enableSnakeRainbowMode()
}

/// stops the game, flashes the view red and plays the game over sound
public func gameOver() {
    ctrl.game.gameOver()
}

/// full implemantion of the user update callback for the game snake
func defaultUpdate() {
    
    if snakeIntersectWithItself() || wallInFrontOfSnake() {
        gameOver()
    } else {
        if coinInFrontOfSnake() {
            collectCoin()
            extendSnakeInFacingDirection()
            placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
        } else {
            moveSnakeInFacingDirection()
        }
    }
    if collectedCoins >= 12 {
        enableSnakeRainbowMode()
    }
}

/// full implemantion of the user did swipe callback for the game snake
///
/// - Parameter direction: swipe direction
func defaultDidSwipe(in direction: Direction) {
    changeSnakeFacingDirection(direction)
}

/// full implemantion of the user init callback for the game snake
func initDefaultGame() {
    makeGrid(width: 11, height: 11, wallColor: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
    makeSnake(length: 4, tailColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), headColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
    placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
}



public func makeDefaultGame() {
    ctrl.userUpdateCallback = defaultUpdate
    ctrl.userSwipeCallback = defaultDidSwipe
    ctrl.userInitCallback = initDefaultGame
}
// MARK: - Logo
func moveSnakeInDirection(_ direction: Direction) {
    changeSnakeFacingDirection(direction)
    moveSnakeInFacingDirection()
}
func extendSnakeInDirection(_ direction: Direction) {
    changeSnakeFacingDirection(direction)
    extendSnakeInFacingDirection()
}

func initLogoScreenGame() {
    initDefaultGame()
    let moveDirection: [Direction] = [
        .down, .down,
        .left, .left, .left, .left, .left,
        .up,
        .right, .right, .right,
        ]
    moveDirection.forEach(moveSnakeInDirection)
    let extendDirections: [Direction] = [
        .right, .right,
        .up, .up,
        .left, .left, .left, .left,
        .up, .up,
        .right, .right, .right, .right, .right,
        ]
    extendDirections.forEach(extendSnakeInDirection)
}

func showSnakeLogo() {
    ctrl.userUpdateCallback = nil
    ctrl.userSwipeCallback = { _ in placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)) }
    ctrl.userInitCallback = initLogoScreenGame
}
