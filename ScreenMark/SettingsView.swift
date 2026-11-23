import AppKit
import SwiftUI

/// The panel shown when the menu bar icon is clicked.
struct SettingsView: View {
    @AppStorage(WatermarkKeys.isEnabled) private var isEnabled = WatermarkDefaults.isEnabled
    @AppStorage(WatermarkKeys.text) private var text = WatermarkDefaults.text
    @AppStorage(WatermarkKeys.layout) private var layout = WatermarkDefaults.layout
    @AppStorage(WatermarkKeys.fontSize) private var fontSize = WatermarkDefaults.fontSize
    @AppStorage(WatermarkKeys.opacity) private var opacity = WatermarkDefaults.opacity
    @AppStorage(WatermarkKeys.color) private var color = WatermarkDefaults.color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Show watermark", isOn: $isEnabled)
                .toggleStyle(.switch)

            Divider()

            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 10) {
                GridRow {
                    Text("Text").gridColumnAlignment(.trailing)
                    TextField("Text", text: $text, prompt: Text("Watermark text"))
                        .labelsHidden()
                }

                GridRow {
                    Text("Position")
                    Picker("Position", selection: $layout) {
                        ForEach(WatermarkLayout.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }

                GridRow {
                    Text("Colour")
                    Picker("Colour", selection: $color) {
                        ForEach(WatermarkColor.allCases) { Text($0.label).tag($0) }
                    }
                    .labelsHidden()
                }

                GridRow {
                    Text("Size")
                    Slider(value: $fontSize, in: 12...200)
                }

                GridRow {
                    Text("Opacity")
                    Slider(value: $opacity, in: 0.05...1)
                }
            }

            Divider()

            HStack {
                Spacer()
                Button("Quit ScreenMark") { NSApplication.shared.terminate(nil) }
            }
        }
        .padding(16)
        .frame(width: 320)
    }
}
