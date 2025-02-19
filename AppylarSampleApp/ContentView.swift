import Appylar
import SwiftUI

struct ContentView: View {
    @State private var bannerView = BannerView()
    @State private var isHidden = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        GeometryReader { _ in
            if AppState.shared.isInterstitialShown {
                InterstitialViewContainer()
                    .onReceive(NotificationCenter.default.publisher(for: .interstitialClosed)) { _ in
                        AppState.shared.isInterstitialShown = false
                    }
                    .ignoresSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width)
                    .frame(height: UIScreen.main.bounds.height)
            } else {
                VStack {
                    VStack(spacing: 14) {
                        Text("Appylar iOS\nSample App")
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 0.16, green: 0.21, blue: 0.26))
                            .padding()

                        // Create buttons
                        Button(action: {
                            //if bannerView.canShowAd() {
                                if bannerView.isHidden {
                                    bannerView.isHidden.toggle()
                                }
                                bannerView.showAd()
                            //}
                        }) {
                            setButtonStyle(title: "Show Banner")
                        }

                        Button(action: {
                            bannerView.hideAd()
                            if !bannerView.isHidden {
                                bannerView.isHidden.toggle()
                            }
                        }) {
                            setButtonStyle(title: "Hide Banner")
                        }

                        Button(action: {
                            //if InterstitialViewController.canShowAd() {
                            AppState.shared.isInterstitialShown = true
                            //}
                        }) {
                            setButtonStyle(title: "Show Interstitial")
                        }

                        Text(AppState.shared.statusText ?? "")
                            .font(.footnote)
                            .foregroundColor(Color(red: 0.16, green: 0.21, blue: 0.26))
                            .padding()

                    }.frame(maxWidth: .infinity, maxHeight: .infinity)

                    // Place the banner view container at the bottom of the screen
                    BannerViewContainer(isHidden: isHidden, bannerView: bannerView)
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.all, edges: [.trailing, .leading])
    }

    // Set a standard button style
    func setButtonStyle(title: String) -> some View {
        return Text(title.uppercased())
            .frame(width: 200.0)
            .frame(height: 15.0)
            .padding()
            .background(Color(red: 0.46, green: 0.56, blue: 0.73))
            .foregroundColor(.white)
            .cornerRadius(8.0)
    }
}

// Set the container where the interstitials will be shown
struct InterstitialViewContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = InterstitialView
    func makeUIViewController(context: Context) -> InterstitialView {
        let vc = InterstitialView()
        return vc
    }

    func updateUIViewController(_ uiViewController: InterstitialView, context: Context) {}
}

// Set the container where the banners will be shown
struct BannerViewContainer: UIViewRepresentable {
    let isHidden: Bool
    let bannerView: BannerView
    
    func makeUIView(context: Context) -> UIView {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.isOpaque = false
        return bannerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.isHidden = isHidden
    }
}

// Set notification to be able to detect when the interstitials are closed
extension Notification.Name {
    static let interstitialClosed = Notification.Name("interstitialClosed")
}

// Create a class that implements the InterstitialViewController class
class InterstitialView: InterstitialViewController {
    
    // Override viewDidLoad() and show the interstitial
    override func viewDidLoad() {
        super.viewDidLoad()
        showAd()
    }

    override func viewDidLayoutSubviews() {
        if AppState.shared.isInterstitialShown == false {
            NotificationCenter.default.post(name: .interstitialClosed, object: nil)
        }
    }
}
