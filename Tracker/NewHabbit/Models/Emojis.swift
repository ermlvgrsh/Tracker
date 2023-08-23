import Foundation

struct Emojis {
    
    static let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    static subscript(_ index: Int) -> String? {
        guard 0..<emojis.count ~= index else { return nil }
        return emojis[index]
    }
    
    static var count: Int {
        emojis.count
    }
    
    static func findEmojiIndex(emoji: String) -> Int? {
        return emojis.firstIndex(of: emoji)
    }
}
