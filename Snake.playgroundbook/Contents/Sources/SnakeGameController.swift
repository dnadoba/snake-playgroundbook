import Foundation
import UIKit
import PlaygroundSupport

/// A `SnakeGameController` manage `SnakeGame`s. It initalize a game and center its view in the middle of the `liveViewSafeAreaGuide`. If the `SnakeGame` has stopped it will restart if the user taps the screen
public class SnakeGameController: UIViewController, SnakeGameDelegate, PlaygroundLiveViewSafeAreaContainer {
    
    /// current snake game
    public var game: SnakeGame!
    
    /// user update callback, called when the game update interval timer has fired while the game is in the `state` `.started` 
    public var userUpdateCallback: (() -> ())?
    
    /// user did swipe callback, called every time a user swiped up, down, left or right
    public var userSwipeCallback: ((Direction) -> ())?
    
    /// user update callback for the playground page, called once for each game
    public var userInitCallback: (() -> ())?
    
    private lazy var collectedCoinLabel: UILabel = self.createLabelPinned(view: .trailing, label: .trailing, constant: -8)
    private lazy var collectedCoinHighscoreLabel: UILabel = self.createLabelPinned(view: .leading, label: .leading, constant: 8)
    private let highScoreStore = IntStore.highScore
    private var highScore: Int {
        return highScoreStore.value ?? 0
    }
    
    public override func viewDidLoad() {
        initGame()
        title = "Snake"
        view.backgroundColor = #colorLiteral(red: 0.9175695777, green: 0.9176984429, blue: 0.9175289273, alpha: 1)
        addSwipeGestureRecoginizer(direction: .left)
        addSwipeGestureRecoginizer(direction: .right)
        addSwipeGestureRecoginizer(direction: .up)
        addSwipeGestureRecoginizer(direction: .down)
        let tapGestureRecoginizer = UITapGestureRecognizer(target: self, action: #selector(restart))
        view.addGestureRecognizer(tapGestureRecoginizer)
        updateUI()
        
    }
    
    /// initalize a new game
    func initGame() {
        let game = SnakeGame()
        game.delegate = self
        game.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(game.view)
        view.addConstraints([
            NSLayoutConstraint(item: game.view, attribute: .centerX, relatedBy: .equal, toItem: liveViewSafeAreaGuide, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: game.view, attribute: .centerY, relatedBy: .equal, toItem: liveViewSafeAreaGuide, attribute: .centerY, multiplier: 1, constant: 0),
            ])
        game.userUpdateCallback = userUpdateCallback
        self.game = game
        updateUI()
        userInitCallback?()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        game.start()
    }
    
    /// adds a new swipe gesture recognice for a given direction and binds it to the `didSwipe(_:)` method
    ///
    /// - Parameter direction: The permitted direction of the swipe for this gesture recognizer.
    func addSwipeGestureRecoginizer(direction: UISwipeGestureRecognizerDirection) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = direction
        self.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    func didSwipe(_ sender: UISwipeGestureRecognizer) {
        let direction = Direction(sender.direction)
        userSwipeCallback?(direction)
    }
    
    /// removes the current game from the view if the `state` is `.stopped` and init and starts a new game
    func restart() {
        if game.state == .stopped {
            game.view.removeFromSuperview()
            initGame()
            game.start()
        }
    }
    
    /// creates a label which is pinned to the top of the `liveViewSafeAreaGuide` and to the given attributes
    ///
    /// - Parameters:
    ///   - viewAttribute: view attribute
    ///   - labelAttribute: pinned lable attribute
    ///   - constant: contraint constant value
    /// - Returns: pinned label
    func createLabelPinned(view viewAttribute: NSLayoutAttribute, label labelAttribute: NSLayoutAttribute, constant: CGFloat) -> UILabel {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        view.addConstraints([
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: liveViewSafeAreaGuide, attribute: .top, multiplier: 1, constant: 8),
            NSLayoutConstraint(item: label, attribute: labelAttribute, relatedBy: .equal, toItem: liveViewSafeAreaGuide, attribute: viewAttribute, multiplier: 1, constant: constant)
            ])
        
        return label
    }
    
    /// updates the collect coin label and the highscore label
    private func updateUI() {
        collectedCoinLabel.text = "\(game.collectedCoins) Coins"
        collectedCoinHighscoreLabel.text = "Highscore: \(highScore)"
    }
    
    func snakeGame(_ game: SnakeGame, didUpdate collectedCoins: Int) {
        if collectedCoins > highScore {
            highScoreStore.value = collectedCoins
        }
        updateUI()
    }
}
