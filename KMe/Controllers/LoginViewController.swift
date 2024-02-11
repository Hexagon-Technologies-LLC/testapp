//
//  LoginViewController.swift
//  KMe
//
//  Created by CSS on 07/09/23.
//

import UIKit
import JWTDecode

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
        //click action for login button
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileCompletionViewController") as! ProfileCompletionViewController
//        nextViewController.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(nextViewController, animated:true)

        if let url = URL(string: Defined.authHostedURL) {
            UIApplication.shared.open(url)
        }
    }
    
    func loginProcess(_ code: String) {
        do {
            let decodedToken = try decode(jwt: code)
            print(decodedToken)
        } catch {
            print(error)
        }
        
        //        Task {
        //            let credentialResult = try await repoAuth.credentialToken(code: code)
        //            print(credentialResult)
        //        }
    }
}
