//
//  LoginViewController.swift
//  KMe
//
//  Created by CSS on 07/09/23.
//

import UIKit
import JWTDecode
import SSCustomTabbar

class LoginViewController: UIViewController {
    
    //declaration interface builder components
    @IBOutlet weak var googlelogin: UIButton!
    @IBOutlet weak var applelogin: UIButton!
    
    @Injected var appState: AppStore<AppState>
    private var cancelBag = CancelBag()
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add icon to the apple login button
        let appleicon = UIImageView(frame: CGRect(x: 20, y: 25, width: 30, height: 30))
        appleicon.image = UIImage(named: "applelogo")
        appleicon.tintColor = UIColor.white
        appleicon.contentMode = .scaleAspectFit
        applelogin.addSubview(appleicon)
        
        //add icon to the apple login button
        let googleicon = UIImageView(frame: CGRect(x: 20, y: 25, width: 30, height: 30))
        googleicon.image = UIImage(named: "googlelogo")
        googleicon.tintColor = UIColor.white
        googleicon.contentMode = .scaleAspectFit
        googlelogin.addSubview(googleicon)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.subscription()
    }
    
    @objc func appEnterForeground() {
        if appState[\.system.callbackCode] != nil {
            Task {
               await viewModel.loginProcess()
            }
        }
    }
    
    func subscription() {
        cancelBag.collect {
            viewModel.$loginState.dropFirst()
                .receive(on: RunLoop.main)
                .sink { state in
                switch state {
                case .unRegistered(let email):
                    let vc = ProfileCompletionViewController.makeVC(email: email)
                    self.navigationController?.pushViewController(vc, animated:true)
                case .loggedIn:
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController  = storyBoard.instantiateViewController(withIdentifier: "SSCustomTabBarViewController") as! SSCustomTabBarViewController
                    self.navigationController?.pushViewController(nextViewController, animated:true)
                default: break
                }
            }
            
            viewModel.$errorMessage.dropFirst()
                .receive(on: RunLoop.main)
                .sink { error in
                KMAlert.alert(title: "", message: error) { _ in
                    //
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //will hide default navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func loginwithapple(_ sender: UIButton){
        if let url = URL(string: Defined.authHostedURL) {
            UIApplication.shared.open(url)
        }
    }
}
