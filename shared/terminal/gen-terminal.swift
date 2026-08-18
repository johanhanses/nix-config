// Generates the Bluloco Dark/Light Terminal.app profiles (.terminal plists)
// with proper archived NSColor/NSFont blobs.
// Run: swift gen-terminal.swift <output-dir>
// Palette: Bluloco (uloco/bluloco.nvim) — slate #282c34 dark / near-white
// #f9f9f9 light, vivid blue accent. Same dark ground as Atom One but a
// markedly more saturated palette on top, and the author's own signature
// cursors: yellow on dark, pink on light. ANSI values are the upstream
// kitty exports; surface shades come from its tab colors.
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

// Full-width Nerd Font build (Maple Mono NF, upstream's own) so powerline caps
// render smooth.
//
// Weight differs per appearance: light-on-dark text blooms and reads heavier, so
// dark drops one notch (Medium 500 -> Regular 400) to match the light profile's
// perceived weight. Maple has no 450 step, so the pair is Medium/Regular.
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
    name: "Bluloco Dark",
    face: "MapleMono-NF-Regular",
    bg: "282c34", fg: "b9c0cb", cursor: "ffcc00", sel: "2c4271",
    ansi: [
        "41444d", "fc2f52", "25a45c", "ff936a", "3476ff", "7a82da", "4483aa", "cdd4e0",
        "8f9aae", "ff6480", "3fc56b", "f9c859", "10b1fe", "ff78f8", "5fb9bc", "ffffff",
    ]
)

let light = makeProfile(
    name: "Bluloco Light",
    face: "MapleMono-NF-Medium",
    bg: "f9f9f9", fg: "373a41", cursor: "f32759", sel: "daf1ff",
    ansi: [
        "373a41", "d52753", "23974a", "df631c", "275fe4", "823ff1", "27618d", "babbc2",
        "676a77", "ff6480", "3cbc66", "c5a332", "0099e1", "ce33c0", "6d93bb", "d3d3d3",
    ]
)

let outDir = CommandLine.arguments[1]
for (fname, dict) in [("Bluloco Dark.terminal", dark), ("Bluloco Light.terminal", light)] {
    let data = try! PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
    let url = URL(fileURLWithPath: outDir).appendingPathComponent(fname)
    try! data.write(to: url)
    print("wrote \(url.path)")
}
