import AppKit
import SwiftUI

/// Menu bar only app. The overlay windows are managed by `OverlayController`.
@main struct ScreenMarkApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @AppStorage(WatermarkKeys.isEnabled) private var isEnabled = WatermarkDefaults.isEnabled

    var body: some Scene {
        MenuBarExtra {
            SettingsView()
        } label: {
            Image(systemName: isEnabled ? "seal.fill" : "seal")
        }
        .menuBarExtraStyle(.window)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        WatermarkDefaults.register()
        OverlayController.shared.start()
    }
}
