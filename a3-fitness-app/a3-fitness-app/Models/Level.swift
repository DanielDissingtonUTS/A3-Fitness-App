struct Level: Codable {
    var level: Int
    var xp: Int
    var progress: Float {
        if xp > 0 {
            return Float(xp) / Float(level * 400)
        }
        
        return 0
    }
}
