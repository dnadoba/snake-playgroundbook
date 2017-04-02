import Foundation
import UIKit

/// linear interpolation between a given start and end Scalar where amount is the progress of the linear interpolation
///
/// - Parameters:
///   - start: start value
///   - end: end value
///   - amount: progress of the interpolation, number between 0 and 1
/// - Returns: interpolated value
func interpolate(from start: CGFloat, to end: CGFloat, by amount: CGFloat) -> CGFloat {
    return start + (end - start) * amount
}


/// interpolate between a given start and end color by a given amount. 
/// it uses the red, green, blue and alpha components of each color and interpolates linear between them.
///
/// - Parameters:
///   - start: start color
///   - end: end color
///   - amount: progress of the interpolation, number between 0 and 1
/// - Returns: interpolated color
func linearRgbaInterpolation(from start: UIColor, to end: UIColor, by amount: CGFloat) -> UIColor {
    let (startRed, startGreen, startBlue, startAlpha) = start.rgbaCompoents()
    let (endRed, endGreen, endBlue, endAlpha) = end.rgbaCompoents()
    return UIColor(
        red: interpolate(from: startRed, to: endRed, by: amount),
        green: interpolate(from: startGreen, to: endGreen, by: amount),
        blue: interpolate(from: startBlue, to: endBlue, by: amount),
        alpha: interpolate(from: startAlpha, to: endAlpha, by: amount)
    )
}

/// interpolate between a given start and end color by a given amount.
/// it uses the hue, saturation, brightness and alpha components of each color and interpolates linear between them.
///
/// - Parameters:
///   - start: start color
///   - end: end color
///   - amount: progress of the interpolation, number between 0 and 1
/// - Returns: interpolated color
func linearHsbaInterpolation(from start: UIColor, to end: UIColor, by amount: CGFloat) -> UIColor {
    
    let (startHue, startSaturation, startBrightness, startAlpha) = start.hsbaComponents()
    let (endHue, endSaturation, endBrightness, endAlpha) = end.hsbaComponents()
    return UIColor(
        hue: interpolate(from: startHue, to: endHue, by: amount),
        saturation: interpolate(from: startSaturation, to: endSaturation, by: amount),
        brightness: interpolate(from: startBrightness, to: endBrightness, by: amount),
        alpha: interpolate(from: startAlpha, to: endAlpha, by: amount)
    )
}
