import Foundation
import UIKit


/// A Block is 2D view with a 3D (2.5D) block effect. It is completely customisable. You can change its size, inset, shadowSize and color and animate it's position with `UIView.animate` or the color with `BlockView.animateColor(withDuration:_, animations:_)`
class BlockView: UIView {
    static func animateColor(withDuration duration: TimeInterval, animations: () -> ()) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
        animations()
        CATransaction.commit()
    }
    
    /// coordinate on the grid
    var coordinate: Coordinate {
        didSet { updatePositionAnSize() }
    }
    
    /// size of the block
    var size: Size {
        didSet {
            initBlockLayer()
            updatePositionAnSize()
        }
    }
    
    /// block inset
    var inset: Size = Size(width: 1, height: 1) {
        didSet {
            initBlockLayer()
            updatePositionAnSize()
        }
    }
    
    /// size of the shadow
    var shadowSize: CGFloat = 4 {
        didSet {
            initBlockLayer()
            updatePositionAnSize()
        }
    }
    
    /// base color of the block
    var color: UIColor {
        didSet { updateColor() }
    }
    
    /// darkened base color by 0.2
    private var shadowColor: UIColor {
        return color.darkened(by: 0.2)
    }
    
    init(coordinate: Coordinate, color: UIColor, size: Size) {
        self.coordinate = coordinate
        self.size = size
        self.color = color
        super.init(frame: .zero)
        backgroundColor = .clear
        initBlockLayer()
        updatePositionAnSize()
        updateColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let blockShapeLayer = CAShapeLayer()
    private let blockShadowLayer = CAShapeLayer()
    
    private func initBlockLayer() {
        let insetX = CGFloat(inset.width)
        let insetY = CGFloat(inset.height)
        let width = CGFloat(size.width) - insetX * 2
        let height = CGFloat(size.height) - insetY * 2
        
        let blockRect = CGRect(x: insetX, y: insetY, width: width - shadowSize, height: height - shadowSize)
        let block = UIBezierPath(rect: blockRect)
        blockShapeLayer.path = block.cgPath
        blockShapeLayer.fillColor = color.cgColor
        layer.addSublayer(blockShapeLayer)
        
        let shadow = UIBezierPath()
        shadow.move(to: CGPoint(x: insetX, y: blockRect.maxY))
        shadow.addLine(to: CGPoint(x: shadowSize, y: blockRect.maxY + shadowSize))
        shadow.addLine(to: CGPoint(x: blockRect.maxX + shadowSize, y: blockRect.maxY + shadowSize))
        shadow.addLine(to: CGPoint(x: blockRect.maxX + shadowSize, y: shadowSize))
        shadow.addLine(to: CGPoint(x: blockRect.maxX, y: insetY))
        shadow.addLine(to: CGPoint(x: blockRect.maxX, y: blockRect.maxY))
        shadow.addLine(to: CGPoint(x: insetX, y: blockRect.maxY))
        shadow.close()
        blockShadowLayer.path = shadow.cgPath
        blockShadowLayer.fillColor = shadowColor.cgColor
        layer.addSublayer(blockShadowLayer)
    }
    
    private func updatePositionAnSize() {
        let position = coordinate * size
        let fillSize = size
        frame = CGRect(
            x: position.x,
            y: position.y,
            width: fillSize.width,
            height: fillSize.height
        )
    }
    private func updateColor() {
        blockShapeLayer.fillColor = color.cgColor
        blockShadowLayer.fillColor = shadowColor.cgColor
    }
    
}
