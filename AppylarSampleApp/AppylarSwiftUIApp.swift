import Appylar
import SwiftUI

@main
struct AppylarSampleApp: App {
    
    init() {

        // Set event listener before initialization
        AppylarManager.setEventListener(delegate: self, bannerDelegate: self, interstitialDelegate: self)

        // Initialize
        AppylarManager.initialize(
            appKey: "<YOUR_IOS_APP_KEY>", // The unique app key for your app
            adTypes: [AdType.banner, AdType.interstitial], // The ad types that you want to show
            testMode: true // Test mode, true for development, false for production
        )

        AppylarManager.setParameters(dict: [
            "banner_height": ["50"],
            "age_restriction": ["12"]
        ])
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState.shared)
        }
    }
}

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var statusText: String? = "Initializing the SDK, please wait..."
    @Published var isInterstitialShown: Bool = false
    private init() {}
}

extension AppylarSampleApp: AppylarDelegate {
    
    // Event listener triggered at successful initialization
    func onInitialized() {
        print("onInitialized")
        DispatchQueue.main.async {
            AppState.shared.statusText = "The SDK is initialized."
        }
    }

    // Event listener triggered if an error occurs in the SDK
    func onError(error: String) {
        print("onError(): \(error)")
        DispatchQueue.main.async {
            AppState.shared.statusText = "Error: \(error)"
        }
    }
}

extension AppylarSampleApp: BannerViewDelegate {
    // Event listener triggered when a banner is shown
    func onBannerShown(_ height: Int) {
        print("onBannerShown(): \(height)")
        DispatchQueue.main.async {
            AppState.shared.statusText = ""
        }
    }

    // Event listener triggered when there are no banners to show
    func onNoBanner() {
        print("onNoBanner()")
        DispatchQueue.main.async {
            AppState.shared.statusText = "No banners in the buffer."
        }
    }
}

extension AppylarSampleApp: InterstitialDelegate {
    // Event listener triggered when an interstitial is shown
    func onInterstitialShown() {
        print("onInterstitialShown()")
        DispatchQueue.main.async {
            AppState.shared.statusText = ""
        }
    }

    // Event listener triggered when an interstitial is closed
    func onInterstitialClosed() {
        print("onInterstitialClosed()")
        AppState.shared.isInterstitialShown = false
        DispatchQueue.main.async {
            AppState.shared.statusText = ""
        }
    }

    // Event listener triggered when there are no interstitials to show
    func onNoInterstitial() {
        print("onNoInterstitial()")
        DispatchQueue.main.async {
            AppState.shared.statusText = "No interstitials in the buffer."
        }
    }
}
