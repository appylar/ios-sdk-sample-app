import SwiftUI
import Appylar
@main
struct AppylarSampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        AppylarManager.setEventListener(delegate: self, bannerDelegate: self, interstitialDelegate: self)
        AppylarManager.Init(
            appKey: "OwDmESooYtY2kNPotIuhiQ",
            adTypes: [AdType.banner, AdType.interstitial],
            testMode: true
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                    }
                }
                UIViewController.attemptRotationToDeviceOrientation()
            } else {
                if orientationLock == .landscape {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if Session.isInterstitialShown{
            return AppDelegate.orientationLock
        } else {
            return AppylarManager.supportedOrientation
        }
        
    }
}

extension AppylarSampleApp: InterstitialDelegate {
    func onNoInterstitial() {
        print("onNoInterstitial()")
    }
    
    func onInterstitialShown() {
        print("onInterstitialShown()")
    }
    
    func onInterstitialClosed() {
        print("onInterstitialClosed()")
    }
}

extension AppylarSampleApp: BannerViewDelegate {
    func onNoBanner() {
        print("onNoBanner()")
    }
    
    func onBannerShown() {
        print("onBannerShown()")
    }
}

extension AppylarSampleApp: AppylarDelegate{
    func onInitialized() {
        print("onInitialized")
    }
    
    func onError(error: String) {
        print("onError:\(error)")
    }
}

