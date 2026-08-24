// Generates the Tokyo Night Storm/Day Terminal.app profiles (.terminal plists)
// with proper archived NSColor/NSFont blobs.
// Run: swift gen-terminal.swift <output-dir>
// Palette: Tokyo Night (folke/tokyonight.nvim) — storm-blue #24283b dark /
// pale blue-grey #e1e2e7 light. Storm rather than the default Night: Night's
// #1a1b26 sits at L* 10.1, close to the too-dark grounds rejected before,
// while Storm's L* 16.5 matches the ground that has stuck. Every value below
// is upstream's own terminal export (extras/ghostty/tokyonight_{storm,day}),
// which brightens ANSI 9-14 rather than repeating 1-6, so bright and normal
// stay distinguishable. Cursor is the foreground, as upstream intends.
import AppKit

func color(_ hex: String) -> NSColor {
    var s = hex
    if s.hasPrefix("#") { s.removeFirst() }
    let v = UInt32(s, radix: 16) ?? 0
    let r = CGFloat((v >> 16) & 0xff) / 255.0
    let g = CGFloat((v >> 8) & 0xff) / 255.0
    let b = CGFloat(v & 0xff) / 255.0
    return NSColor(srgbRed: r, green: g, blue: b, alpha: 1.0)
}

func arch(_ obj: Any) -> Data {
    return try! NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: false)
}

// Full-width Nerd Font build (JetBrainsMono Nerd Font, not the NFM/Propo
// variants) so powerline caps render smooth.
//
// Weight differs per appearance: light-on-dark text blooms and reads heavier, so
// dark drops one notch (Medium 500 -> Regular 400) to match the light profile's
// perceived weight. JetBrains Mono has no 450 step, so the pair is Medium/Regular.
func font(_ face: String) -> NSFont {
    return NSFont(name: face, size: 15)!
}

func makeProfile(name: String, face: String, bg: String, fg: String, cursor: String, sel: String, ansi: [String]) -> [String: Any] {
    let ansiKeys = [
        "ANSIBlackColor", "ANSIRedColor", "ANSIGreenColor", "ANSIYellowColor",
        "ANSIBlueColor", "ANSIMagentaColor", "ANSICyanColor", "ANSIWhiteColor",
        "ANSIBrightBlackColor", "ANSIBrightRedColor", "ANSIBrightGreenColor", "ANSIBrightYellowColor",
        "ANSIBrightBlueColor", "ANSIBrightMagentaColor", "ANSIBrightCyanColor", "ANSIBrightWhiteColor",
    ]
    var d: [String: Any] = [
        "name": name,
        "type": "Window Settings",
        "ProfileCurrentVersion": 2.07,
        "Font": arch(font(face)),
        "BackgroundColor": arch(color(bg)),
        "TextColor": arch(color(fg)),
        "TextBoldColor": arch(color(fg)),
        "CursorColor": arch(color(cursor)),
        "SelectionColor": arch(color(sel)),
        "FontAntialias": true,
        "FontWidthSpacing": 1.0,
        "columnCount": 120,
        "rowCount": 34,
        "CursorType": 0,
        "BlinkText": false,
    ]
    for (i, k) in ansiKeys.enumerated() {
        d[k] = arch(color(ansi[i]))
    }
    return d
}

let dark = makeProfile(
    name: "Tokyo Night Storm",
    face: "JetBrainsMonoNF-Regular",
    bg: "24283b", fg: "c0caf5", cursor: "c0caf5", sel: "2e3c64",
    ansi: [
        "1d202f", "f7768e", "9ece6a", "e0af68", "7aa2f7", "bb9af7", "7dcfff", "a9b1d6",
        "414868", "ff899d", "9fe044", "faba4a", "8db0ff", "c7a9ff", "a4daff", "c0caf5",
    ]
)

let light = makeProfile(
    name: "Tokyo Night Day",
    face: "JetBrainsMonoNF-Medium",
    bg: "e1e2e7", fg: "3760bf", cursor: "3760bf", sel: "b7c1e3",
    ansi: [
        "b4b5b9", "f52a65", "587539", "8c6c3e", "2e7de9", "9854f1", "007197", "6172b0",
        "a1a6c5", "ff4774", "5c8524", "a27629", "358aff", "a463ff", "007ea8", "3760bf",
    ]
)

let outDir = CommandLine.arguments[1]
for (fname, dict) in [("Tokyo Night Storm.terminal", dark), ("Tokyo Night Day.terminal", light)] {
    let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
    let url = URL(fileURLWithPath: outDir).appendingPathComponent(fname)
    try! data.write(to: url)
    print("wrote \(url.path)")
}
