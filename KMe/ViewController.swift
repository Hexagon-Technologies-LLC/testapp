//
//  ViewController.swift
//  KMe
//
//  Created by CSS on 04/09/23.
//

import UIKit
import SSCustomTabbar

class ViewController: UIViewController {
    @LazyInjected var appState: AppStore<AppState>
    var cancelBag = CancelBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //trigger after 1 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if self.appState[\.isAuthorized] {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController  = storyBoard.instantiateViewController(withIdentifier: "SSCustomTabBarViewController") as! SSCustomTabBarViewController
                UIApplication.shared.windows.first?.rootViewController = nextViewController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            } else {
                self.showGetStarted()
            }
        }
        
        NotificationCenter.default.publisher(for: Notification.Name("logOut")).sink { _ in
            DispatchQueue.main.async {
                self.showGetStarted()
            }
        }.store(in: cancelBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //hide default navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func flingActionCallback(_ sender: FlingActionButton){
        
        
    }
    
    func showGetStarted() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GetstartedViewController") as! GetstartedViewController
        let navigationController = UINavigationController(rootViewController: nextViewController)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

