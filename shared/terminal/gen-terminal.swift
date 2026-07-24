// Generates the One Dark/Light Terminal.app profiles (.terminal plists) with proper
// archived NSColor/NSFont blobs. Run: swift gen-terminal.swift <output-dir>
// Palette: Atom One / One Dark Pro — slate dark #282c34 / grey-white light
// #fafafa, blue accent.
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
// BlexMono = IBM Plex Mono, Nerd Fonts rename. Medium — a notch lighter than
// SemiBold; the family also has Text (lighter still) and SemiBold/Bold (heavier).
let font = NSFont(name: "BlexMonoNF-Medium", size: 15)!

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
    name: "One Dark",
    bg: "282c34", fg: "abb2bf", cursor: "528bff", sel: "3e4451",
    ansi: [
        "3f4451", "e06c75", "98c379", "d19a66", "61afef", "c678dd", "56b6c2", "abb2bf",
        "5c6370", "e06c75", "98c379", "e5c07b", "61afef", "c678dd", "56b6c2", "ffffff",
    ]
)

let light = makeProfile(
    name: "One Light",
    bg: "fafafa", fg: "383a42", cursor: "526fff", sel: "e5e5e6",
    ansi: [
        "383a42", "e45649", "50a14f", "c18401", "4078f2", "a626a4", "0184bc", "a0a1a7",
        "696c77", "e45649", "50a14f", "c18401", "4078f2", "a626a4", "0184bc", "fafafa",
    ]
)

let outDir = CommandLine.arguments[1]
for (fname, dict) in [("One Dark.terminal", dark), ("One Light.terminal", light)] {
    let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
    let url = URL(fileURLWithPath: outDir).appendingPathComponent(fname)
    try! data.write(to: url)
    print("wrote \(url.path)")
}
