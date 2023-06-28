import SwiftUI
import CoreData
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
                            }else{
                                AppDelegate.orientationLock = .portrait
                            }
                            
                        }
                        .onDisappear{
                            NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil)
                            AppDelegate.orientationLock = .all
                            currentOrientation = UIDevice.current.orientation
                        }
                    
                }else {
                    VStack(spacing: 20) {
                        
                        BannerViewWrapper(bannerView: bannerView)
                            .frame(height: bannerHeight)
                            .ignoresSafeArea()
                        
                        Spacer()
                
                        Button(action: {
                            if BannerView().canShowAd(){
                                bannerView.showAd()
                            }
                        }) {
                            Text("Show Banner")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .disabled(isInterstitialShown)
                        }
                        
                        Button(action: {
                            bannerView.hideAd()
                        }) {
                            Text("Hide Banner")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .disabled(isInterstitialShown)
                        }
                        
                        Button(action: {
                            if InterstitialViewController.canShowAd(){
                                DispatchQueue.main.async {
                                    isInterstitialShown = true
                                    
                                }
                            }
                        }) {
                            Text("Show Interstitial")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .disabled(isInterstitialShown)
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        currentOrientation = UIDevice.current.orientation
                    }
                    .padding(.vertical, 20)
                    
                }
                
//            }
//            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
//                orientation = UIDevice.current.orientation
//            }
        }
                
    }
}

struct MyView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = AddViewController
    
    func makeUIViewController(context: Context) -> AddViewController {
        
        let vc = AddViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AddViewController, context: Context) {
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
