import SwiftUI
import Appylar

struct ContentView: View {
    @State private var bannerView = BannerView()
    @State private var isInterstitialShown = false
    @State private var bannerHeight = 50.0
    @State private var orientation = UIDeviceOrientation.unknown
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var currentOrientation = UIDevice.current.orientation
    var body: some View {
        GeometryReader { geometry in
            if isInterstitialShown {
                
                MyView()
                    .onReceive(NotificationCenter.default.publisher(for: .interstitialClosed))  { _ in
                        isInterstitialShown = false
                    }
                    .ignoresSafeArea(.all)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width)
                    .frame(height: UIScreen.main.bounds.height)
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        orientation = UIDevice.current.orientation
                    }
                    .onAppear{
                        if currentOrientation.isLandscape{
                            if currentOrientation == .landscapeLeft {
                                AppDelegate.orientationLock = .landscapeRight
                            }else if currentOrientation == .landscapeRight {
                                AppDelegate.orientationLock = .landscapeLeft
                            }
                        } else {
                            AppDelegate.orientationLock = .portrait
                        }
                        
                    }
                    .onDisappear{
                        NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil)
                        AppDelegate.orientationLock = .all
                        currentOrientation = UIDevice.current.orientation
                    }
                
            } else {
                VStack(spacing: 30) {
                    
                    BannerViewWrapper(bannerView: bannerView)
                        .frame(height: bannerHeight)
                        .ignoresSafeArea()
                    
                    Image("logo_svg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80.0)
                        .padding(.bottom, 10)
                    
                    Text("Appylar Sample App")
                        .font(.largeTitle)
                        .foregroundColor(Color.init(red: 0.16, green: 0.21, blue: 0.26))
                    
                    Spacer()
                    
                    Button(action: {
                        if BannerView().canShowAd(){
                            bannerView.showAd()
                        }
                    }) {
                        createButtonStyle(title: "Show Banner")
                    }
                    
                    Button(action: {
                        bannerView.hideAd()
                    }) {
                        createButtonStyle(title: "Hide Banner")
                    }
                    
                    Button(action: {
                        if InterstitialViewController.canShowAd(){
                            DispatchQueue.main.async {
                                isInterstitialShown = true
                            }
                        }
                    }) {
                        createButtonStyle(title: "Show Interstitial")
                    }
                    
                    Spacer()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    currentOrientation = UIDevice.current.orientation
                }
                .padding(.vertical, 20)
            }
        }
        
    }
    
    func createButtonStyle(title: String) -> some View {
        return Text(title.uppercased())
            .frame(width: 200)
            .frame(height: 15)
            .padding()
            .background(Color.init(red: 0.46, green: 0.56, blue: 0.73))
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(isInterstitialShown)
    }
}

struct MyView: UIViewControllerRepresentable {
    typealias UIViewControllerType = AdViewController
    func makeUIViewController(context: Context) -> AdViewController {
        let vc = AdViewController()
        return vc
    }
    func updateUIViewController(_ uiViewController: AdViewController, context: Context) {
    }
}


struct BannerViewWrapper: UIViewRepresentable {
    let bannerView: BannerView
    func makeUIView(context: Context) -> UIView {
        bannerView
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}


extension Notification.Name {
    static let interstitialClosed = Notification.Name("interstitialClosed")
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
