// Generates the GitHub CB Dark/Light Terminal.app profiles (.terminal plists) with
// proper archived NSColor/NSFont blobs. Run: swift gen-terminal.swift <output-dir>
// Palette: GitHub's colorblind ANSI (no red/green — removals/errors orange,
// additions/passes blue), both grounds dimmed: dark on GitHub Dark Dimmed
// #22272e (L* 15.4), light on grey #d7dade (L* 86.9) with the light hues
// deepened a shade to keep text contrast on it.
// Mirrored by the ghostty, tmux and btop themes — keep them in sync.
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

// Full-width Nerd Font build (JetBrains Mono NF, not "NF Mono") so powerline caps
// render smooth.
//
// Both appearances use Medium. Dark once dropped to Regular (light-on-dark text
// blooms), but that read harder than light mode, so it was bumped back up.
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
    name: "GitHub CB Dark",
    face: "JetBrainsMonoNF-Medium",
    bg: "22272e", fg: "adbac7", cursor: "58a6ff", sel: "314b69",
    ansi: [
        "484f58", "ec8e2c", "58a6ff", "d29922", "58a6ff", "bc8cff", "39c5cf", "b1bac4",
        "6e7681", "fdac54", "79c0ff", "e3b341", "79c0ff", "d2a8ff", "56d4dd", "cdd9e5",
    ]
)

let light = makeProfile(
    name: "GitHub CB Light",
    face: "JetBrainsMonoNF-Medium",
    bg: "d7dade", fg: "24292f", cursor: "085cbf", sel: "a9bed7",
    ansi: [
        "24292f", "974b00", "0550ae", "4d2d00", "085cbf", "7138db", "17686e", "6e7781",
        "57606a", "8a4600", "0969da", "633c01", "006ce3", "8547f7", "297a8e", "8c959f",
    ]
)

let outDir = CommandLine.arguments[1]
for (fname, dict) in [("GitHub CB Dark.terminal", dark), ("GitHub CB Light.terminal", light)] {
    let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
    let url = URL(fileURLWithPath: outDir).appendingPathComponent(fname)
    try! data.write(to: url)
    print("wrote \(url.path)")
}
