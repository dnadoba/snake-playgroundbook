//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 On this page you will learn how to collect coins and extend the snake.
 
 In the following source code you see a function `didSwipe(in direction: Direction)` which will be executed every time you swipe up, down, left or right on the game screen.
 Your task is to change the facing direction of the snake with the function `changeSnakeFacingDirection(Direction)`.
 
 There is another function `update()` which is executed every second and is the heart of every game (also kown as the game update loop). This is the right place to call the function `moveSnakeInFacingDirection()` because we want the snake to move even if the user didn't swipe.
 
 Should be easy for you 😉, so what are you waiting for?

 
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
//#-code-completion(identifier, hide, snakeIntersectWithItself(), wallInFrontOfSnake(), gameOver(), extendSnakeInFacingDirection(), collectCoin(), enableSnakeRainbowMode(), gameOver(), coinInFrontOfSnake(), collectedCoins)
import PlaygroundSupport


//#-end-hidden-code

func initGame() {
    //#-editable-code
    //#-copy-destination("Initialize Game", id1)
    makeGrid(width: 11, height: 11, wallColor: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
    makeSnake(length: 4, tailColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), headColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
    placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
    //#-end-copy-destination
    //#-end-editable-code
}
func didSwipe(in direction: Direction) {
    
}
func update() {
    
}


//#-hidden-code
var didInitGameSuccessful = false
var didExecuteDidSwipeUserCallback = false
var didExecuteUpdateUserCallback = false
var didHandleSwipeSuccessful = false
var didHandleUpdateSuccessful = false
var lastHints = [String]()
func test() {
    if didInitGameSuccessful && didHandleSwipeSuccessful && didHandleUpdateSuccessful {
        if passTestOnce() {
            PlaygroundPage.current.assessmentStatus = .pass(message: nil)
        }
    } else {
        var hints = initGameHints()
        if didExecuteDidSwipeUserCallback && !didHandleSwipeSuccessful {
            hints.append("Call the function `changeSnakeFacingDirection(Direction)` in the `didSwipe(in: Direction)` function")
        }
        if didExecuteUpdateUserCallback && !didHandleUpdateSuccessful {
            hints.append("Call the function `moveSnakeInFacingDirection())` in the `update()` function")
        }
        if lastHints != hints {
            PlaygroundPage.current.assessmentStatus = .fail(hints: hints, solution: nil)
        }
        lastHints = hints
    }
}
func initGameAndTest() {
    initGame()
    if didMakeSnake() && didMakeGrid() && didPlaceCoin() {
        didInitGameSuccessful = true
    }
    test()
}
func delegateSwipeAndTest(direction: Direction) {
    didExecuteDidSwipeUserCallback = true
    didSwipe(in: direction)
    didHandleSwipeSuccessful = calledChangeSnakeFacingDirection
    test()
}
func delegateUpdateAndTest() {
    didExecuteUpdateUserCallback = true
    update()
    didHandleUpdateSuccessful = calledMoveSnakeInFacingDirection
    test()
}


ctrl.userInitCallback = initGameAndTest
ctrl.userSwipeCallback = delegateSwipeAndTest
ctrl.userUpdateCallback = delegateUpdateAndTest

PlaygroundPage.current.liveView = ctrl

//#-end-hidden-code
