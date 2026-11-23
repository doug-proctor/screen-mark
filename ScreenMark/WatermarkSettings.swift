import SwiftUI

/// UserDefaults keys shared by the settings panel and the overlay.
enum WatermarkKeys {
    static let isEnabled = "isEnabled"
    static let text = "text"
    static let layout = "layout"
    static let fontSize = "fontSize"
    static let opacity = "opacity"
    static let color = "color"
}

enum WatermarkDefaults {
    static let isEnabled = true
    static let text = "CONFIDENTIAL"
    static let layout = WatermarkLayout.tiled
    static let fontSize = 48.0
    static let opacity = 0.15
    static let color = WatermarkColor.white

    static func register() {
        UserDefaults.standard.register(defaults: [
            WatermarkKeys.isEnabled: isEnabled,
            WatermarkKeys.text: text,
            WatermarkKeys.layout: layout.rawValue,
            WatermarkKeys.fontSize: fontSize,
            WatermarkKeys.opacity: opacity,
            WatermarkKeys.color: color.rawValue,
        ])
    }
}

enum WatermarkLayout: String, CaseIterable, Identifiable {
    case tiled
    case center
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    var id: String { rawValue }

    var label: String {
        switch self {
        case .tiled: "Tiled"
        case .center: "Centre"
        case .topLeft: "Top left"
        case .topRight: "Top right"
        case .bottomLeft: "Bottom left"
        case .bottomRight: "Bottom right"
        }
    }

    var alignment: Alignment {
        switch self {
        case .tiled, .center: .center
        case .topLeft: .topLeading
        case .topRight: .topTrailing
        case .bottomLeft: .bottomLeading
        case .bottomRight: .bottomTrailing
        }
    }
}

enum WatermarkColor: String, CaseIterable, Identifiable {
    case white
    case black
    case red
    case blue

    var id: String { rawValue }

    var label: String { rawValue.capitalized }

    var color: Color {
        switch self {
        case .white: .white
        case .black: .black
        case .red: .red
        case .blue: .blue
        }
    }
}
