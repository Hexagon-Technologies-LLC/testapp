//
//  ProfileViewController.swift
//  KMe
//
//  Created by CSS on 22/09/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var lbProfileName: UILabel!
    @LazyInjected var appState: AppStore<AppState>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userInfo = appState[\.userData.userInfo] else { return }
        lbProfileName.text = userInfo.fullName
        
    }
    @IBAction func editprofile(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
        
    }
    @IBAction func backnavigation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
