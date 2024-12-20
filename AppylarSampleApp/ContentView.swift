import Appylar
import SwiftUI

struct ContentView: View {
    @State private var bannerView = BannerView()
    @State private var isInterstitialShown = false
    
    var body: some View {
        GeometryReader { _ in
            // Check if interstitial should be shown...
            if isInterstitialShown {
                // Place the interstitial view container and make it cover the whole screen
                InterstitialViewContainer()
                    .onReceive(NotificationCenter.default.publisher(for: .interstitialClosed)) { _ in
                        isInterstitialShown = false
                    }
                    .ignoresSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width)
                    .frame(height: UIScreen.main.bounds.height)

                // ...or if the menu should be shown
            } else {
                VStack {
                    VStack(spacing: 14) {
                        Text("Appylar iOS\nSample App")
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 0.16, green: 0.21, blue: 0.26))
                            .padding()

                        // Create buttons
                        Button(action: {
                            if bannerView.canShowAd() {
                                bannerView.showAd()
                            }
                        }) {
                            setButtonStyle(title: "Show Banner")
                        }

                        Button(action: {
                            bannerView.hideAd()
                        }) {
                            setButtonStyle(title: "Hide Banner")
                        }

                        Button(action: {
                            if InterstitialViewController.canShowAd() {
                                isInterstitialShown = true
                            }
                        }) {
                            setButtonStyle(title: "Show Interstitial")
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)

                    // Place the banner view container at the bottom of the screen
                    BannerViewContainer(bannerView: bannerView)
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
            .disabled(isInterstitialShown)
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
    let bannerView: BannerView
    
    func makeUIView(context: Context) -> UIView {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        //bannerView.backgroundColor = UIColor.red
        return bannerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
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
        if Session.isInterstitialShown == false {
            NotificationCenter.default.post(name: .interstitialClosed, object: nil)
        }
    }
}

// Set the preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
