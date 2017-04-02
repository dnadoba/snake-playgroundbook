/// Helper functions to validate playground pages and to
/// to give usefull hints

import Foundation
import PlaygroundSupport

public func didMakeGrid() -> Bool {
    return ctrl.game.grid != nil
}
public func didMakeSnake() -> Bool {
    return ctrl.game.snake != nil
}
public func didPlaceCoin() -> Bool {
    return ctrl.game.coin != nil
}
private weak var lastKnownGame: SnakeGame?
private var lastCoinCount = 0
private var lastSnakeLength: Int? = 0
private func remeberLastKnownGameAndRestStatesIfNeeded() {
    if lastKnownGame !== ctrl.game! {
        lastKnownGame = ctrl.game
        lastCoinCount = 0
        lastSnakeLength = nil
    }
    if lastSnakeLength == nil {
        lastSnakeLength = ctrl.game.snake?.startLength
    }
}


public func didCollectCoinInLastUpdate() -> Bool {
    remeberLastKnownGameAndRestStatesIfNeeded()
    if ctrl.game.collectedCoins > lastCoinCount {
        lastCoinCount = ctrl.game.collectedCoins
        return true
    }
    return false
}

public func didExtendSnakeInLastUpdate() -> Bool {
    remeberLastKnownGameAndRestStatesIfNeeded()
    if let previousSnakeLength = lastSnakeLength,
        let currentSnakeLength = ctrl.game.snake?.length {
        
        if currentSnakeLength > previousSnakeLength {
            return true
        }
    }
    return false
}

public func gameStopped() -> Bool {
    return ctrl.game.state == .stopped
}

public func initGameHints() -> [String] {
    var hints = [String]()
    if !didMakeGrid() {
        hints.append("Try first to create a Grid with `makeGrid(width: Int, height: Int, wallColor: .blue)`")
    }
    if !didMakeSnake() {
        hints.append("Try to create a snake with `makeSnake(length: Int, tailColor: .green, headColor: .red)` after you created a grid")
    }
    if !didPlaceCoin() {
        hints.append("Try to place a coin with `placeRandomCoin(.yellow)` after you created a grid and a Snake")
    }
    
    return hints
}


private let audienceApplaudingSoundPlayer = SoundPlayer(sound: .audienceApplauding)
private var passedTest = false
public func passTestOnce() -> Bool{
    if !passedTest {
        passedTest = true
        audienceApplaudingSoundPlayer.play()
        return true
    }
    return false
}
