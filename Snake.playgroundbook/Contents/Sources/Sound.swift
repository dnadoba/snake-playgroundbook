import Foundation

import AVFoundation


/// A `Sound` defines a file in the bundle with a given name and extension which can be played with a `SoundPlayer`
struct Sound {
    /// file name of the sound
    let fileName: String
    /// extension of the sound file
    let fileExtension: String
    init(name: String, withExtension fileExtension: String) {
        self.fileName = name
        self.fileExtension = fileExtension
    }
    
    /// url of the sound file in the main bundle
    var url: URL? {
        return Bundle.main.url(forResource: fileName, withExtension: fileExtension)
    }
}


// MARK: - Available sounds
extension Sound {
    static let move = Sound(name: "customMove", withExtension: "mp3")
    static let collectCoin = Sound(name: "collectCoin", withExtension: "wav")//.wav file is smaller than .mp3 file, maybe use another sound file compressor
    static let gameOver = Sound(name: "gameOver", withExtension: "mp3")
    static let audienceApplauding = Sound(name: "audienceApplauding", withExtension: "mp3")
    static let levelUp = Sound(name: "levelUp", withExtension: "mp3")
}
