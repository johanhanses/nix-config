// Generates the Catppuccin Terminal.app profiles (.terminal plists) with proper
// archived NSColor/NSFont blobs. Run: swift gen-terminal.swift <output-dir>
// Dark flavor = Macchiato, light flavor = Latte.
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
// Medium weight — Regular reads too thin, especially on the light (Latte) bg.
let font = NSFont(name: "GeistMonoNF-Medium", size: 15)!

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

let macchiato = makeProfile(
    name: "Catppuccin Macchiato",
    bg: "24273a", fg: "cad3f5", cursor: "f4dbd6", sel: "5b6078",
    ansi: [
        "494d64", "ed8796", "a6da95", "eed49f", "8aadf4", "f5bde6", "8bd5ca", "b8c0e0",
        "5b6078", "ed8796", "a6da95", "eed49f", "8aadf4", "f5bde6", "8bd5ca", "a5adcb",
    ]
)

let latte = makeProfile(
    name: "Catppuccin Latte",
    bg: "eff1f5", fg: "4c4f69", cursor: "dc8a78", sel: "acb0be",
    ansi: [
        "5c5f77", "d20f39", "40a02b", "df8e1d", "1e66f5", "ea76cb", "179299", "acb0be",
        "6c6f85", "d20f39", "40a02b", "df8e1d", "1e66f5", "ea76cb", "179299", "bcc0cc",
    ]
)

let outDir = CommandLine.arguments[1]
for (fname, dict) in [("Catppuccin Macchiato.terminal", macchiato), ("Catppuccin Latte.terminal", latte)] {
    let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
    let url = URL(fileURLWithPath: outDir).appendingPathComponent(fname)
    try! data.write(to: url)
    print("wrote \(url.path)")
}
