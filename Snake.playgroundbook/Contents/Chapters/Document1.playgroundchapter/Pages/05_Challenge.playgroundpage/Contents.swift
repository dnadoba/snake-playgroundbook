//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 In the last challenge you will lern how to detect and handle collision with the boundaries and the snake itself.
 
 In the update function you have to check if the snake will collide with a wall `wallInFrontOfSnake()` or if the snake collides with itself `snakeIntersectWithItself()`.
 If the snake collides with something call the function `gameOver()`, otherwise use your the previous move/collect/extend logic.
 
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, hide)
//#-code-completion(bookauxiliarymodule, show)
//#-code-completion(identifier, show, UIColor)
//#-code-completion(identifier, hide, SnakeGameController, SnakeGame)
//#-code-completion(identifier, hide, Direction)
//#-code-completion(identifier, hide, ctrl)
//#-code-completion(identifier, hide, makeDefaultGame())
//#-code-completion(identifier, hide, didPassTests(), didMakeGrid(), didMakeSnake(), didPlaceCoin(), didCollectCoinInLastUpdate(), didExtendSnakeInLastUpdate(), initGameHints(), passTestOnce(), calledChangeSnakeFacingDirection, calledMoveSnakeInFacingDirection, gameStopped())
//#-code-completion(identifier, hide, enableSnakeRainbowMode(), collectedCoins)
//#-code-completion(keyword, if, else, ||, return)
import PlaygroundSupport


//#-end-hidden-code

func initGame() {
    //#-editable-code
    makeGrid(width: 11, height: 11, wallColor: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
    makeSnake(length: 4, tailColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), headColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
    placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
    //#-end-editable-code
}
func didSwipe(in direction: Direction) {
    //#-editable-code
    changeSnakeFacingDirection(direction)
    //#-end-editable-code
}
func update() {
    //#-editable-code
    if coinInFrontOfSnake() {
        collectCoin()
        extendSnakeInFacingDirection()
        placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
    } else {
        moveSnakeInFacingDirection()
    }
    //#-end-editable-code
}
//#-hidden-code

var didInitGameSuccessful = false
var didExtendSnakeSuccessful = false

func initGameAndTest() {
    initGame()
    if didMakeSnake() && didMakeGrid() && didPlaceCoin() {
        didInitGameSuccessful = true
    } else {
        let hints = initGameHints()
        PlaygroundPage.current.assessmentStatus = .fail(hints: hints, solution: nil)
    }
}

func delegateUpdateAndTest() {
    let wasCoinInFrontOfSnake = coinInFrontOfSnake()
    let wasWallInFrontOfSnake = wallInFrontOfSnake()
    let wasSnakeOnItself = snakeIntersectWithItself()
    update()
    
    if !didExtendSnakeSuccessful {
        let coinCollected = didCollectCoinInLastUpdate()
        let snakeExtended = didExtendSnakeInLastUpdate()
        let coinPlaced = didPlaceCoin()
        didExtendSnakeSuccessful = wasCoinInFrontOfSnake &&
                                    coinCollected &&
                                    snakeExtended &&
                                    coinPlaced
    }
    
    if didExtendSnakeSuccessful && didExtendSnakeSuccessful {
        if (wasWallInFrontOfSnake || wasSnakeOnItself) && gameStopped() {
            if passTestOnce() {
                PlaygroundPage.current.assessmentStatus = .pass(message: nil)
            }
        }
    }
}


ctrl.userInitCallback = initGameAndTest
ctrl.userSwipeCallback = didSwipe
ctrl.userUpdateCallback = delegateUpdateAndTest

PlaygroundPage.current.liveView = ctrl

//#-end-hidden-code
