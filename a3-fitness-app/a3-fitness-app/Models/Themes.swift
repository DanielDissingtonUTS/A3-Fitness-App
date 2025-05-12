struct Themes { // Add new themes to Assets > Colours > Themes
    static var names: [String] = ["Default", "Strawberry", "Mint"]
    // ^ Manually update this list whenever you add a new theme
    
    static var i: Int = 0
    
    static var all: [Theme] = names.compactMap { name in
        i += 1
        
        return Theme(
            name: name,
            primaryColor: ("\(name)Primary"),       // <- Follow this naming convention
            secondaryColor: ("\(name)Secondary"),   // e.g. DefaultPrimary, DefaultSecondary, DefaultTertiary
            tertiaryColor: ("\(name)Tertiary"),
            requiredLevel: i,                       // <- requiredLevel = position in names list
            unlocked: false                         // e.g. names[0] = requiredLevel 1, names[1] = requiredLevel 2, etc.
        )
    }
}
