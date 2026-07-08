// Generates the Claude-warm Terminal.app profiles (.terminal plists) with proper
// archived NSColor/NSFont blobs. Run: swift gen-terminal.swift <output-dir>
// Palette modeled on the Claude desktop app: warm charcoal dark / ivory light,
// coral accent, olive-sage-gold-slate ANSI hues (no purple).
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

// Full-width Nerd Font variant (NF, not NFM/Mono) so powerline caps render smooth.
// SemiBold weight — Regular/Medium read too thin, especially on the light (ivory) bg.
// (Step between Medium and Bold; swap to GeistMonoNF-Bold for more punch.)
let font = NSFont(name: "GeistMonoNF-SemiBold", size: 15)!

func makeProfile(name: String, bg: String, fg: String, cursor: String, sel: String, ansi: [String]) -> [String: Any] {
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
        "Font": arch(font),
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
    name: "Claude Dark",
    bg: "262624", fg: "e8e6dc", cursor: "c96442", sel: "4a453e",
    ansi: [
        "1f1e1d", "e0705f", "90a870", "d0a45c", "85a3c4", "c68a94", "7fae9b", "c9c5b9",
        "6b675c", "e88373", "a3b985", "ddb46f", "9ab4d1", "d3a0ab", "93bfae", "e8e6dc",
    ]
)

let light = makeProfile(
    name: "Claude Light",
    bg: "faf9f5", fg: "3d3d3a", cursor: "c96442", sel: "e3ddd0",
    ansi: [
        "3d3d3a", "b0432f", "5a7a37", "9c7420", "4c6d96", "9c5468", "457a68", "e8e6dc",
        "6b675c", "c9573f", "6d8c4a", "b08a34", "5f80a8", "b06a80", "5a8f7d", "faf9f5",
    ]
)

let outDir = CommandLine.arguments[1]
for (fname, dict) in [("Claude Dark.terminal", dark), ("Claude Light.terminal", light)] {
    let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
    let url = URL(fileURLWithPath: outDir).appendingPathComponent(fname)
    try! data.write(to: url)
    print("wrote \(url.path)")
}
