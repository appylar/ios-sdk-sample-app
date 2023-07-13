import SwiftUI
import Appylar

struct ContentView: View {
    @State private var bannerView = BannerView()
    @State private var isInterstitialShown = false
    @State private var bannerHeight = 50.0
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some View {
        GeometryReader { geometry in
            
            // Check if interstitial should be shown...
            if isInterstitialShown {
                
                // Place the interstitial view container and make it cover the whole screen
                InterstitialViewContainer()
                    .onReceive(NotificationCenter.default.publisher(for: .interstitialClosed))  { _ in
                        isInterstitialShown = false
                    }
                    .ignoresSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width)
                    .frame(height: UIScreen.main.bounds.height)
                
            // ...or if the menu should be shown
            } else {
                
                VStack() {
                    ScrollView(showsIndicators: false){
                        VStack(spacing: 25) {
                            Spacer()
                            
                            // Show Appylar logo and text
                            Image("appylar_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40.0)
                                .padding(.top, 30.0)
                            
                            Text("Appylar Sample App")
                                .font(.largeTitle)
                                .foregroundColor(Color.init(red: 0.16, green: 0.21, blue: 0.26))
                                .padding()
                            
                            Spacer()
                            
                            // Create buttons
                            Button(action: {
                                if BannerView().canShowAd(){
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
                                if InterstitialViewController.canShowAd(){
                                    isInterstitialShown = true
                                }
                            }) {
                                setButtonStyle(title: "Show Interstitial")
                            }
                            
                            Spacer()
                        }
                    }
                    
                    // Place the banner view container at the bottom of the screen
                    BannerViewContainer(bannerView: bannerView)
                        .frame(height: 50)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .ignoresSafeArea(.all,edges: [.trailing,.leading])
    }
    
    // Set a standard button style
    func setButtonStyle(title: String) -> some View {
        return Text(title.uppercased())
            .frame(width: 200.0)
            .frame(height: 15.0)
            .padding()
            .background(Color.init(red: 0.46, green: 0.56, blue: 0.73))
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
    func updateUIViewController(_ uiViewController: InterstitialView, context: Context) {
    }
}

// Set the container where the banners will be shown
struct BannerViewContainer: UIViewRepresentable {
    let bannerView: BannerView
    func makeUIView(context: Context) -> UIView {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        return bannerView
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

// Set notification to be able to detect when the interstitial is closed
extension Notification.Name {
    static let interstitialClosed = Notification.Name("interstitialClosed")
}

// Create the interstitial view
class InterstitialView:InterstitialViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAd()
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
