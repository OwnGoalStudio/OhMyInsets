import SwiftUI

let UISBWA_UICOLOR = UIColor(red: 9.0 / 255, green: 132.0 / 255, blue: 227.0 / 255, alpha: 1.0)
let UISBWA_COLOR = Color(UISBWA_UICOLOR)

extension Color {
    init(rgbString: String) {
        let components = rgbString.split(separator: ",").map { Double($0) ?? 0 }
        if components.count == 3 {
            self.init(.sRGB, red: components[0] / 255, green: components[1] / 255, blue: components[2] / 255, opacity: 1.0)
        } else {
            self.init(.sRGB, red: components[0] / 255, green: components[1] / 255, blue: components[2] / 255, opacity: components[3])
        }
    }

    func toRGBString() -> String {
        let components = self.cgColor?.components ?? [0, 0, 0, 0]
        let red = Int(components[0] * 255)
        let green = Int(components[1] * 255)
        let blue = Int(components[2] * 255)
        let alpha = components[3]
        return "\(red),\(green),\(blue),\(alpha)"
    }
}
