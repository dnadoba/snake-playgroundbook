import Foundation
import UIKit

/// A Coin is just a BlockView but conforms to the `Collidable` protocol and can be faded in and out.
final class Coin: BlockView, Collidable {
    
    init(coordinate: Coordinate, size: Size) {
        super.init(coordinate: coordinate, color: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func intersect(with coordinate: Coordinate) -> Bool {
        return coordinate == self.coordinate
    }
    
    func fadeOutAndRemoveFromSuperview(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    func fadeIn(widthDuration duration: TimeInterval) {
        alpha = 0
        UIView.animate(withDuration: duration) { [weak self] in
            self?.alpha = 1
        }
    }
    
}
