import UIKit
import Appylar

class AdViewController:InterstitialViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if InterstitialViewController.canShowAd(){
            self.showAd()
        }
    }
    
    override func viewDidLayoutSubviews() {
        if Session.isInterstitialShown == false {
            NotificationCenter.default.post(name: .interstitialClosed, object: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}
