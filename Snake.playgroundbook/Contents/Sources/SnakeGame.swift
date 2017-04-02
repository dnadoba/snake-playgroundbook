import UIKit

protocol SnakeGameDelegate: class {
    func snakeGame(_ game: SnakeGame, didUpdate collectedCoins: Int)
}

public class SnakeGame {
    
    /// state of the snake game
    ///
    /// - stopped: game has not yet started or was stopped
    /// - started: game is currently running
    enum State {
        case stopped
        case started
    }
    weak var delegate: SnakeGameDelegate?
    
    /// boundary view
    let view = BoundaryView()
    
    /// current boundary view size  constrains
    private(set) var viewSizeConstrains: [NSLayoutConstraint] = []
    
    /// grid view, all game objects will be added to this view
    let gridView = UIView()
    
    /// size of one block, e.g. body part of the snake or one coin
    let blockSize = Size(width: 25, height: 25)
    
    /// current grid
    private(set) var grid: Grid?
    
    /// current snake
    private(set) var snake: Snake?
    
    /// current coin
    private(set) var coin: Coin?
    
    /// collected coins count by the snake
    private(set) var collectedCoins = 0 {
        didSet {
            guard oldValue != collectedCoins else { return }
            delegate?.snakeGame(self, didUpdate: collectedCoins)
        }
    }
    
    /// collect coins sound
    private let collectCoinSoundPlayer = SoundPlayer(sound: .collectCoin)
    
    /// game over sound
    private let gameOverSoundPlayer = SoundPlayer(sound: .gameOver)
    
    
    /// size of the boundary walls
    private var borderWidth: Int {
        return max(blockSize.width, blockSize.height)
    }
    
    /// inset of the grid view
    var gridOffset: CGPoint {
        return CGPoint(x: borderWidth, y: borderWidth)
    }
    
    /// current state of the game, use start, stop, gameOver to modify the state
    private(set) var state: State = .stopped
    
    /// current color snake mode used to init the snake
    private(set) var startSnakeColorMode: Snake.ColorMode = .custom
    
    
    /// game loop timer
    private var timer: Timer?
    
    /// user update function used for the playground integration
    var userUpdateCallback: (() -> ())?
    
    /// game loop interval in seconds
    private(set) var updateInterval: TimeInterval = 0.8 {
        didSet {
            start()
        }
    }
    init() {
        view.alpha = 0
        view.addSubview(gridView)
        
        configureViewSizeConstrains()
    }
    
    /// coinstrains the boundary view to a given size
    ///
    /// - Parameters:
    ///   - width: width in points
    ///   - height: height in points
    func configureViewSizeConstrains(width: CGFloat = 300, height: CGFloat = 300) {
        view.backgroundColor = .clear
        view.removeConstraints(viewSizeConstrains)
        //fixed size
        let constrains = [
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height),
            ]
        view.addConstraints(constrains)
        self.viewSizeConstrains = constrains
    }
    
    /// starts the game update loop
    func start() {
        stop()
        let timer = Timer(timeInterval: updateInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
        state = .started
    }
    
    /// stops the game update loop
    func stop() {
        timer?.invalidate()
        timer = nil
        state = .stopped
    }
    
    /// update game loop
    @objc private func update() {
        userUpdateCallback?()
        
        updateGameSpeed()
    }
    
    /// collects the current coin, plays the collect coin sound, fades the coin out and increments the collected coins counter by 1 if a coin is present
    func collectCoin() {
        if let coin = self.coin {
            collectedCoins += 1
            coin.fadeOutAndRemoveFromSuperview(withDuration: animationDuration())
            collectCoinSoundPlayer.play()
            self.coin = nil
        }
    }
    
    /// enables the rainbow color mode of the snake if one is present, otherwise it saves the mode if one is created later
    func enableSnakeRainbowMode() {
        startSnakeColorMode = .rainbow
        self.snake?.enableRainbowMode()
    }
    
    /// places a coin on a random coordinate inside the grid which is not covered by the snake
    ///
    /// - Parameter color: color of the coin
    func placeRandomCoin(color: UIColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)) {
        guard let grid = self.grid else { return }
        var coinCoordinate: Coordinate
        repeat {
            coinCoordinate = grid.randomCoordinateInsideGrid()
        } while(snake.intersect(with: coinCoordinate))
        placeCoin(at: coinCoordinate, color: color)
    }
    
    /// places a coin at a given coordinate with a given color
    ///
    /// - Parameters:
    ///   - coordinate: grid coordinate
    ///   - color: color of the coin
    private func placeCoin(at coordinate: Coordinate, color: UIColor) {
        self.coin?.removeFromSuperview()
        let coin = Coin(coordinate: coordinate, size: blockSize)
        coin.color = color
        self.coin = coin
        gridView.insertSubview(coin, at: 0)
        coin.fadeIn(widthDuration: animationDuration())
    }
    
    /// creates a snake with the given peroperties
    ///
    /// - Parameters:
    ///   - length: start body part cound
    ///   - tail: end tail color of the snake
    ///   - head: head color of the snake
    func makeSnake(length: Int, tail: UIColor, head: UIColor) {
        guard let grid = self.grid else { return }
        if let previousSnake = self.snake {
            previousSnake.view.removeFromSuperview()
        }
        let direction = Direction.right
        let start = grid.center - Coordinate(direction) * (length/2)
        let snake = Snake(startCoordinate: start, facingDirection: direction, length: length, bodyPartSize: blockSize)
        snake.changeColor(tail: tail, head: head)
        snake.mode = startSnakeColorMode
        gridView.addSubview(snake.view)
        self.snake = snake
    }
    
    /// creates a grid with the given size and wall color
    ///
    /// - Parameters:
    ///   - width: width of the grid
    ///   - height: height of the grid
    ///   - wall: color of the boundary
    func makeGrid(width: Int, height: Int, wall: UIColor) {
        view.alpha = 1
        view.color = wall
        let grid = Grid(columnCount: width, rowCount: height, blockSize: blockSize)
        self.grid = grid
        let rect = CGRect(x: 0, y: 0, width: (width + 2) * blockSize.width, height: (height + 2) * blockSize.width)
        configureViewSizeConstrains(width: rect.width, height: rect.height)
        gridView.frame.origin = gridOffset
        gridView.frame.size = CGSize(width: rect.width - CGFloat(borderWidth * 2), height: rect.height - CGFloat(borderWidth * 2))
    }
    /// extends the snake in the current facing direction animated if one is present in the game
    func extendSnakeInFacingDirection() {
        guard let snake = self.snake else { return }
        let duration = animationDurationForSnakeLength(snake.length + 1)
        snake.extendInFacingDirection(duration: duration)
    }
    
    /// moves the snake in the current facing direction animated if one is present in the game
    func moveSnakeInFacingDirection() {
        guard let snake = self.snake else { return }
        let duration = animationDurationForSnakeLength(snake.length)
        snake.moveInFacingDirection(duration: duration)
    }
    
    /// changes the snake facing direction for the next operations on the snake like move/extend if it is not the opposite of the previous facing direction
    ///
    /// - Parameter direction: direction in which the snake should look
    func changeSnakeFaceingDirection(to direction: Direction) {
        snake?.changeFacingDirection(to: direction)
    }
    /// checks if a wall is in front of the snake
    ///
    /// - Returns: true if a snake is present and a wall is in front of the snake, othwerwise false
    func wallInFrontOfSnake() -> Bool {
        guard let grid = self.grid else { return false }
        guard let snake = self.snake else { return false }
        let nextSnakeCoordinate = snake.nextHeadCoordinateInFacingDirection()
        return grid.boundary.intersect(with: nextSnakeCoordinate)
    }
    
    /// checks if a coin is in front of the snake
    ///
    /// - Returns: true if a snake is present and a coin is in front of the snake, othwerwise false
    func coinInFrontOfSnake() -> Bool {
        guard let snake = self.snake else { return false }
        let nextSnakeCoordinate = snake.nextHeadCoordinateInFacingDirection()
        return coin.intersect(with: nextSnakeCoordinate)
    }
    
    /// calculates if the snake head collides with any body part excluding the head itself
    ///
    /// - Returns: true if a snake is present and the snake collides with itself, otherwise false
    func snakeIntersectWithItself() -> Bool {
        guard let snake = self.snake else { return false }
        let headCoordinate = snake.head.coordinate
        return snake.intersectWithCoordinateExcludingHead(headCoordinate)
    }
    
    /// calcuates the game speed for a given snake length
    ///
    /// - Parameter snakeLength: snake body part count
    /// - Returns: update interval in seconds
    private func speedForSnakeLength(_ snakeLength: Int) -> TimeInterval {
        if snakeLength <= 4 {
            return 0.80
        } else if snakeLength <= 6 {
            return 0.75
        } else if snakeLength <= 8 {
            return 0.70
        } else if snakeLength <= 11 {
            return 0.65
        } else if snakeLength <= 15 {
            return 0.62
        } else if snakeLength <= 19 {
            return 0.48
        } else if snakeLength <= 22 {
            return 0.44
        } else if snakeLength <= 26 {
            return 0.42
        } else {
            return 0.4
        }
    }
    
    /// calculates the animation duration for a given snake length
    ///
    /// - Parameter snakeLength: snake body part count
    /// - Returns: animation duration in seconds
    private func animationDurationForSnakeLength(_ snakeLength: Int) -> TimeInterval {
        return speedForSnakeLength(snakeLength) / 3
    }
    
    /// calculates the animation duration for the current snake length
    ///
    /// - Returns: animation duration in seconds
    private func animationDuration() -> TimeInterval {
        let length = snake?.length ?? 4
        return animationDurationForSnakeLength(length)
    }
    
    /// updates the update timer interval to matches the speed for the current snake length
    func updateGameSpeed() {
        guard let snake = self.snake else { return }
        let newUpdateInterval = speedForSnakeLength(snake.length)
        if updateInterval != newUpdateInterval {
            updateInterval = newUpdateInterval
        }
    }
    
    /// stops the game, flashes the view red and plays the game over sound
    func gameOver() {
        stop()
        gridView.backgroundColor = .red
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.gridView.backgroundColor = .clear
        }
        gameOverSoundPlayer.play()
    }
}
