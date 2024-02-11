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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileCompletionViewController") as! ProfileCompletionViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextViewController, animated:true)

//        if let url = URL(string: Defined.authHostedURL) {
//            UIApplication.shared.open(url)
//        }
//        
//        do {
//            let decodedToken = try decode(jwt: "eyJraWQiOiIwbjBibElmSXJ6OVhtUGswenZhZ1ZJYm9kOGoybERScWIyU3RtcHVtOThNPSIsImFsZyI6IlJTMjU2In0.eyJhdF9oYXNoIjoicW1TTmNRNHhiYkQwdHM3bE9tRUR0QSIsInN1YiI6ImM5ZDc4ZDI2LTU0ZWQtNDA2Yi1hOTBhLTg2NjAzZTJhMmM0NyIsImNvZ25pdG86Z3JvdXBzIjpbInVzLWVhc3QtMV9VZVhGRVBINnNfR29vZ2xlIl0sImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9VZVhGRVBINnMiLCJjb2duaXRvOnVzZXJuYW1lIjoiZ29vZ2xlXzExNTc3ODk3ODYyMDgxMTU2MTMzNiIsImdpdmVuX25hbWUiOiJKYXkiLCJvcmlnaW5fanRpIjoiN2U4OWRiMDItZjI1My00NjRmLTlhYTEtMTA3Njc0ZWJlYjBlIiwiYXVkIjoiNDV2cjc1am9xMGhnanY2azhhdGg2aWZpbW0iLCJpZGVudGl0aWVzIjpbeyJ1c2VySWQiOilxMTU3Nzg5Nzg2MjA4MTE1NjEzMzYiLCJwcm92aWRlck5hbWUiOiJHb29nbGUiLCJwcm92aWRlclR5cGUiOiJHb29nbGUiLCJpc3N1ZXIiOm51bGwsInByaW1hcnkiOiJ0cnVlIiwiZGF0ZUNyZWF0ZWQiOiIxNzAzNTU5NzYxOTk1In1dLCJ0b2tlbl91c2UiOiJpZCIsImF1dGhfdGltZSI6MTcwNjMwMDIzNSwibmFtZSI6IkpheSBNb2hhbiIsImV4cCI6MTcwNjMwMzgzNSwiaWF0IjoxNzA2MzAwMjM1LCJmYW1pbHlfbmFtZSI6Ik1vaGFuIiwianRpIjoiZGY1ZDMyY2EtYjEwNC00NWU3LTgwZjEtMDNjMGYzMWI4MjM3IiwiZW1haWwiOiJtamFnZ3VAZ21haWwuY29tIn0.k-e1NAgcGLQbNGNopRWa_joqPKtD2iKmJAEikYbfnKfrn3lQ4VESeggGgwvjIILjedj-kjJeFi4I_EylyL1cSPcIN7nO7XJLVqNC6_7qVw17gAxTbXyUJD84nYLEnnzQRe6NnxDCBHpvk3vV4PQDjf790sXJ-t6fcUU9XLrkMWtBFRhGU35Qcc6VXEWAK2KgsjpDaERrgOXG18gXh3mODavNmglXiEwAxjIN3X51rHIGnd4PgKyQKkaJ6_12Obst4RvB8aVQnKRNVI_EApaSAr3Wr-fabu9wFI5w-v4hAdL4Yev_Up9IkPNQ70uN9NxbZtH_507z7ml0PbrfgvQ6vQ")
//            print(decodedToken)
//        } catch {
//            print(error)
//        }
        
//        Task {
//            let mockCode = "730e2c89-dc8a-4174-b7df-fb6cb9fc47b7"
//            let credentialResult = try await repoAuth.credentialToken(code: mockCode)
//            print(credentialResult)
//        }
    }
    
    func loginProcess(_ code: String) {
        Task {
            let credentialResult = try await repoAuth.credentialToken(code: code)
            print(credentialResult)
        }
    }
}
