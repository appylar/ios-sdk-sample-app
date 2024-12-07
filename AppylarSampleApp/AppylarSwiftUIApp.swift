import Appylar
import SwiftUI

@main
struct AppylarSampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        // Set event listener before initialization
        // Set event to show log for banner & interstitial then you have to pass delegate as self for indivisualy ads
        /* Example: AppylarManager.setEventListener(delegate: self, bannerDelegate: self) // For Banner Ads only
                    AppylarManager.setEventListener(delegate: self, interstitialDelegate: self) // For Interstitial Ads only
                    AppylarManager.setEventListener(delegate: self, bannerDelegate: self, interstitialDelegate: self) // For Both Ads
         */
        AppylarManager.setEventListener(delegate: self, bannerDelegate: self, interstitialDelegate: self)

        // Initialize
        AppylarManager.initialize(
            appKey: "<YOUR_IOS_APP_KEY>", // The unique app key for your app
            adTypes: [AdType.banner, AdType.interstitial], // The ad types that you want to show
            testMode: true // Test mode, true for development, false for production
        )

        AppylarManager.setParameters(dict: [
            "banner_height": ["50"],
            "age_restriction": ["18"]
        ])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Define the app delegate to keep track of the screen orientations when device is flipped
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppylarManager.supportedOrientation
    }
}

extension AppylarSampleApp: AppylarDelegate {
    // Event listener triggered at successful initialization
    func onInitialized() {
        print("onInitialized")
    }

    // Event listener triggered if an error occurs in the SDK
    func onError(error: String) {
        print("onError(): \(error)")
    }
}

extension AppylarSampleApp: BannerViewDelegate {
    // Event listener triggered when a banner is shown
    func onBannerShown() {
        print("onBannerShown()")
    }

    // Event listener triggered when there are no banners to show
    func onNoBanner() {
        print("onNoBanner()")
    }
}

extension AppylarSampleApp: InterstitialDelegate {
    // Event listener triggered when an interstitial is shown
    func onInterstitialShown() {
        print("onInterstitialShown()")
    }

    // Event listener triggered when an interstitial is closed
    func onInterstitialClosed() {
        print("onInterstitialClosed()")
    }

    // Event listener triggered when there are no interstitials to show
    func onNoInterstitial() {
        print("onNoInterstitial()")
    }
}
