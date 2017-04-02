//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 The following page will teach you how to configure the game Snake. You can change the color and size of the walls and the snake.
 
 The very first thing we need is a grid enclosed by walls. To add a grid with walls to the game call the function `makeGrid(width: Int, height: Int, wallColor: UIColor)`. A good size is `11x11`.
 
 After you created a grid you can add the snake to the game by calling the function `makeSnake(length: Int, tailColor: UIColor, headColor: UIColor)`. A good length is `4`.
 
 In addition, place a coin on the grid by calling the function `placeRandomCoin(UIColor)`.
 
 Let's Code!
 
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
//#-code-completion(identifier, hide, snakeIntersectWithItself(), wallInFrontOfSnake(), extendSnakeInFacingDirection(), moveSnakeInFacingDirection(), collectCoin(), enableSnakeRainbowMode(), gameOver(), coinInFrontOfSnake(), collectedCoins)

import PlaygroundSupport


//#-end-hidden-code

func initGame() {
    //#-copy-source(id1)
    //#-editable-code Tap to write your game configuration code
    
    //#-end-editable-code
    //#-end-copy-source
}

//#-hidden-code

func initGameAndTest() {
    initGame()
    if didMakeSnake() && didMakeGrid() && didPlaceCoin() {
        if passTestOnce() {
            PlaygroundPage.current.assessmentStatus = .pass(message: nil)
        }
    } else {
        let hints = initGameHints()
        PlaygroundPage.current.assessmentStatus = .fail(hints: hints, solution: nil)
    }
}

ctrl.userInitCallback = initGameAndTest

PlaygroundPage.current.liveView = ctrl

//#-end-hidden-code
