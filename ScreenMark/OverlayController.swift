import AppKit
import SwiftUI

/// Puts one transparent, click-through window over each screen.
final class OverlayController {
    static let shared = OverlayController()

    private var windows: [NSWindow] = []

    func start() {
        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { _ in
            MainActor.assumeIsolated { OverlayController.shared.rebuild() }
        }
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            MainActor.assumeIsolated { OverlayController.shared.applyEnabledState() }
        }
        rebuild()
    }

    private var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: WatermarkKeys.isEnabled)
    }

    private func rebuild() {
        windows.forEach { $0.orderOut(nil) }
        windows = NSScreen.screens.map(makeWindow(for:))
        applyEnabledState()
    }

    private func applyEnabledState() {
        for window in windows {
            if isEnabled {
                window.orderFrontRegardless()
            } else {
                window.orderOut(nil)
            }
        }
    }

    private func makeWindow(for screen: NSScreen) -> NSWindow {
        let window = NSWindow(
            contentRect: screen.frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.ignoresMouseEvents = true
        window.isReleasedWhenClosed = false
        window.level = .screenSaver
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary, .ignoresCycle]
        // .readOnly lets screen capture (Zoom, Meet) see the window. .none would hide it.
        window.sharingType = .readOnly

        let hostingView = NSHostingView(rootView: WatermarkView())
        hostingView.sizingOptions = []
        window.contentView = hostingView
        window.setFrame(screen.frame, display: true)
        return window
    }
}
