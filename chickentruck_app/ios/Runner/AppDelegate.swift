import Flutter
import UIKit
import GoogleMaps   // ✅ hinzugefügt
 
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
 
    if let key = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String {
      GMSServices.provideAPIKey(key)
    } else {
      fatalError("GMSApiKey fehlt. Stelle sicher, dass GMS_API_KEY in Secrets.xcconfig gesetzt ist.")
    }
 
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}