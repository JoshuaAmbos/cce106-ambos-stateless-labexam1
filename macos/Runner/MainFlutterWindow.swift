import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    // Default window size set to standard phone dimensions (390 x 844)
    self.setFrame(NSRect(x: windowFrame.origin.x, y: windowFrame.origin.y, width: 390, height: 844), display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
