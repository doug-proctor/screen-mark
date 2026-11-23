import SwiftUI

/// The watermark drawn inside each overlay window.
struct WatermarkView: View {
    @AppStorage(WatermarkKeys.text) private var text = WatermarkDefaults.text
    @AppStorage(WatermarkKeys.layout) private var layout = WatermarkDefaults.layout
    @AppStorage(WatermarkKeys.fontSize) private var fontSize = WatermarkDefaults.fontSize
    @AppStorage(WatermarkKeys.opacity) private var opacity = WatermarkDefaults.opacity
    @AppStorage(WatermarkKeys.color) private var color = WatermarkDefaults.color

    var body: some View {
        Group {
            if layout == .tiled {
                tiled
            } else {
                single
            }
        }
        .opacity(opacity)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }

    private var label: Text {
        Text(text)
            .font(.system(size: fontSize, weight: .bold))
            .foregroundStyle(color.color)
    }

    private var single: some View {
        label
            .padding(fontSize)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: layout.alignment)
    }

    /// Repeats the text in rotated rows that cover the whole screen.
    private var tiled: some View {
        Canvas { context, size in
            let resolved = context.resolve(label)
            let textSize = resolved.measure(in: CGSize(width: CGFloat.infinity, height: .infinity))
            let stepX = textSize.width + fontSize * 3
            let stepY = textSize.height + fontSize * 3
            let reach = hypot(size.width, size.height) / 2

            context.translateBy(x: size.width / 2, y: size.height / 2)
            context.rotate(by: .degrees(-30))

            var row = 0
            var y = -reach
            while y <= reach {
                var x = -reach + (row.isMultiple(of: 2) ? 0 : stepX / 2)
                while x <= reach {
                    context.draw(resolved, at: CGPoint(x: x, y: y))
                    x += stepX
                }
                y += stepY
                row += 1
            }
        }
    }
}
