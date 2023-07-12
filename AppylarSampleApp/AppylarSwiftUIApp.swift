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
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppylarManager.supportedOrientation
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
    func onBannerShown() {
        print("onNoBanner()")
    }
    
    func onNoBanner() {
        print("onNoBanner()")
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

