//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 On the following page you will learn how to collect coins and extend the snake in the `update()` game loop.
 
 Your can check with the function `coinInFrontOfSnake()` if we will collide with a coin in the next move. Instead of moving the snake we will extend the snake with the function `extendSnakeInFacingDirection()`. Don't forget to call the function `collectCoin()` and `placeRandomCoin(UIColor)`.
 
 Hint: With the keyword `if` you can create a block which will be executed only if the expression behind the if evaluates to `true` and with the keyword `else` you can define a block wich is executed otherwise.
 
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
//#-code-completion(identifier, hide, snakeIntersectWithItself(), wallInFrontOfSnake(), gameOver(), enableSnakeRainbowMode(), collectedCoins)
//#-code-completion(keyword, if, else, return)
import PlaygroundSupport


//#-end-hidden-code

func initGame() {
    //#-copy-source(id2)
    //#-editable-code
    makeGrid(width: 11, height: 11, wallColor: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
    makeSnake(length: 4, tailColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), headColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
    placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
    //#-end-editable-code
    //#-end-copy-source
}
func didSwipe(in direction: Direction) {
    //#-copy-source(id3)
    //#-editable-code
    changeSnakeFacingDirection(direction)
    //#-end-editable-code
    //#-end-copy-source
}
func update() {
    //#-copy-source(id4)
    //#-editable-code
    moveSnakeInFacingDirection()
    //#-end-editable-code
    //#-end-copy-source
}
//#-hidden-code

var didInitGameSuccessful = false
func didInitGame() -> Bool {
    return didInitGameSuccessful
}
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
    update()
    let coinCollected = didCollectCoinInLastUpdate()
    let snakeExtended = didExtendSnakeInLastUpdate()
    let coinPlaced = didPlaceCoin()
    if didInitGame() &&
        wasCoinInFrontOfSnake &&
        coinCollected &&
        snakeExtended &&
        coinPlaced {
        
        if passTestOnce() {
            PlaygroundPage.current.assessmentStatus = .pass(message: nil)
        }
    }
}


ctrl.userInitCallback = initGameAndTest
ctrl.userSwipeCallback = didSwipe
ctrl.userUpdateCallback = delegateUpdateAndTest

PlaygroundPage.current.liveView = ctrl

//#-end-hidden-code
