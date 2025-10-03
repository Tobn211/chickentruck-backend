import Flutter
import UIKit
import GoogleMaps   // ✅ hinzugefügt
 
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCFljpaZh7AvrDTB5zkr2C0EkRm33mzkKE")  // ✅ API-Key setzen
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}