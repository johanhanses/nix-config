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
    // warm parchment rather than beige f0eee6/ivory faf9f5 — a shade darker paper,
    // with charcoal ink (same as the dark bg) so contrast rises to ~11.5:1
    bg: "e6e0d1", fg: "262624", cursor: "c96442", sel: "d8d0bc",
    ansi: [
        "262624", "9e3a27", "4f6d2f", "8a661a", "426187", "8c4a5c", "3c6d5c", "dcd6c6",
        "5f5b51", "b34c35", "5f7d3e", "9c7a28", "547397", "9e5e72", "4f8070", "e6e0d1",
    ]
)

let outDir = CommandLine.arguments[1]
for (fname, dict) in [("Claude Dark.terminal", dark), ("Claude Light.terminal", light)] {
    let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
    let url = URL(fileURLWithPath: outDir).appendingPathComponent(fname)
    try! data.write(to: url)
    print("wrote \(url.path)")
}
