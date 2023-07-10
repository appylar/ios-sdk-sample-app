import SwiftUI
import Appylar

struct ContentView: View {
    @State private var bannerView = BannerView()
    @State private var isInterstitialShown = false
    @State private var bannerHeight = 50.0
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
                    .frame(width: UIScreen.main.bounds.width)
                    .frame(height: UIScreen.main.bounds.height)
                
                // SHOULD BE IN THE SDK, NOT IN THE APP CODE!

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
                /////////////////////////////////////////////
            } else {
                
                VStack() {
                    ScrollView(showsIndicators: false){
                        VStack(spacing: 25) {
                            Spacer()
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
                                    //        DispatchQueue.main.async {
                                    isInterstitialShown = true
                                    //       }
                                }
                            }) {
                                createButtonStyle(title: "Show Interstitial")
                            }
                            
                            Spacer()
                        }
                    }
                    BannerViewWrapper(bannerView: bannerView)
                        .frame(height: 50)
                        .ignoresSafeArea()
                    
                }
                
                // SHOULD BE IN THE SDK, NOT IN THE APP CODE!
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    currentOrientation = UIDevice.current.orientation
                }
                ////////////////////////////////////
                .frame(maxWidth: .infinity)
                //.ignoresSafeArea()
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
    typealias UIViewControllerType = InterstitialView
    func makeUIViewController(context: Context) -> InterstitialView {
        let vc = InterstitialView()
        return vc
    }
    func updateUIViewController(_ uiViewController: InterstitialView, context: Context) {
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

// Show an interstitial on top of any other view class
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
