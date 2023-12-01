import Cocoa
import FlutterMacOS
let flutterViewController = FlutterViewController()
class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
//    let flutterViewController = flutterViewController
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
