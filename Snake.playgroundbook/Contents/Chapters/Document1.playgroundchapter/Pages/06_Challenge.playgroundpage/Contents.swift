//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 Congratulation! You have created the game Snake.
 
 On the following page is a complete implementation with a new feature called Rainbow Mode 🌈
 You can play around and try to beat your high score.
 If you want to use this code to create your own Snake Game, you can the find the complete code in this Playground Book or on [GitHub](https://github.com/dnadoba/snake-playgroundbook)
 
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
//#-code-completion(keyword, if, else, ||, return)
import PlaygroundSupport


//#-end-hidden-code
//#-editable-code
func initGame() {
    makeGrid(width: 11, height: 11, wallColor: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
    makeSnake(length: 4, tailColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), headColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
    placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
}
func didSwipe(in direction: Direction) {
    changeSnakeFacingDirection(direction)
}
func update() {
    if wallInFrontOfSnake() || snakeIntersectWithItself() {
        gameOver()
        return
    }
    if coinInFrontOfSnake() {
        collectCoin()
        extendSnakeInFacingDirection()
        placeRandomCoin(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1))
    } else {
        moveSnakeInFacingDirection()
    }
    if collectedCoins >= 12 {
        enableSnakeRainbowMode()
    }
}
//#-end-editable-code
//#-hidden-code


ctrl.userInitCallback = initGame
ctrl.userSwipeCallback = didSwipe
ctrl.userUpdateCallback = update

PlaygroundPage.current.liveView = ctrl

//#-end-hidden-code
