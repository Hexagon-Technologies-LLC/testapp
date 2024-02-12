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
    @LazyInjected var repoAuth: AuthRepository
    @Injected var appState: AppStore<AppState>
    
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
    }
    
    @objc func appEnterForeground() {
        if let callbackCode = appState[\.system.callbackCode] {
            loginProcess(callbackCode)
            appState[\.system.callbackCode] = nil
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
    
    func loginProcess(_ code: String) {
        do {
            let decodedToken = try decode(jwt: code)
            if let email = decodedToken.body["email"] as? String {
                Task {
                    do {
                        let _ = try await repoAuth.getProfile(email: email)
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController  = storyBoard.instantiateViewController(withIdentifier: "SSCustomTabBarViewController") as! SSCustomTabBarViewController
                        self.navigationController?.pushViewController(nextViewController, animated:true)
                    } catch {
                        let vc = ProfileCompletionViewController.makeVC(email: email)
                        self.navigationController?.pushViewController(vc, animated:true)
                    }
                }
            } else {
                KMAlert.alert(title: "", message: "Email not found") { _ in
                }
            }
        } catch {
            print(error)
        }
    }
}
