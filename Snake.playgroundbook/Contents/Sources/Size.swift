import Foundation


/// Size of an element on the grid
struct Size {
    var width: Int
    var height: Int
}

extension Size {
    
    /// Scalar multiplaction
    static func *(lhs: Size, rhs: Int) -> Size {
        return Size(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    /// Vector multiplaction
    static func *(lhs: Size, rhs: Size) -> Size {
        return Size(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }
    /// Vector addition
    static func +(lhs: Size, rhs: Size) -> Size {
        return Size(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    /// Vector subtraction
    static func -(lhs: Size, rhs: Size) -> Size {
        return Size(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
}
