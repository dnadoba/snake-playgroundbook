import Foundation
import PlaygroundSupport

class IntStore {
    let key: String
    
    var value: Int? {
        get {
            guard let keyValue = PlaygroundKeyValueStore.current[key],
                case .integer(let storedValue) = keyValue else {
                return nil
            }
            return storedValue
        }
        set {
            if let valueToStore = newValue {
                PlaygroundKeyValueStore.current[key] = .integer(valueToStore)
            } else {
                PlaygroundKeyValueStore.current[key] = nil
            }
        }
    }
    
    init(key: String) {
        self.key = key
    }
}

extension IntStore {
    static let highScore = IntStore(key: "highScore")
}
