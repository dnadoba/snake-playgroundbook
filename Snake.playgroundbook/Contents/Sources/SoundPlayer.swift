import Foundation
import AVFoundation


/// A `SoundPlayer` can play `Sound`s and can play them faster so the complete in a given time interval
class SoundPlayer {
    
    /// sound which the player will play
    let sound: Sound
    private let audioPlayer: AVAudioPlayer
    init(sound: Sound) {
        self.sound = sound
        self.audioPlayer = try! AVAudioPlayer(contentsOf: sound.url!)
    }
    
    /// A time interval in which the sound should finish playing
    var completionDuration: TimeInterval? {
        didSet {
            if let completionDuration = self.completionDuration {
                audioPlayer.enableRate = true
                audioPlayer.rate = Float(audioPlayer.duration / completionDuration)
            } else {
                audioPlayer.rate = 1
                audioPlayer.enableRate = false
            }
        }
    }
    
    /// plays the sound from start
    func play() {
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
}
