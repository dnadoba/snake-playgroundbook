import Foundation
import UIKit

extension UIColor {
    
    /// calculates the red, green, blue and alpha components of a color and returns it
    ///
    /// - Returns: red, green, blue and alpha component of the color
    func rgbaCompoents() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    /// calculates the hue, saturation, brightness and alpha components of a color and returns it
    ///
    /// - Returns: hue, saturation, brightness and alpha component of the color
    func hsbaComponents() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue, saturation, brightness, alpha)
    }
    
    /// brightens the color by a given amount and returns the new color
    ///
    /// - Parameter amount: brightness value from 0 to 1
    /// - Returns: brightened color
    func brightened(by amount: CGFloat) -> UIColor {
        let (hue, saturation, brightness, alpha) = hsbaComponents()
        let newBrightness = max(min(brightness + amount, 1), 0)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    /// darkens the color by a given amount and returns the new color
    ///
    /// - Parameter amount: darkness value from 0 to 1
    /// - Returns: darkened color
    func darkened(by amount: CGFloat) -> UIColor {
        let (hue, saturation, brightness, alpha) = hsbaComponents()
        let newBrightness = max(min(brightness - amount, 1), 0)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
}
