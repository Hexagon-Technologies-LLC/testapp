//
//  SettingsViewController.swift
//  KMe
//
//  Created by CSS on 21/09/23.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var profileview: UIView!
    @IBOutlet weak var termsview: UIView!
    @IBOutlet weak var settingsviiew: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @LazyInjected var repoAuth: AuthRepository
    @LazyInjected var appState: AppStore<AppState>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.showProfile (_:)))
        profileview.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.showterms (_:)))
        termsview.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.showSettings (_:)))
        settingsviiew.addGestureRecognizer(gesture2)
    }
    
    @objc func showProfile(_ sender:UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    @objc func showSettings(_ sender:UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationSettingsViewController") as! NotificationSettingsViewController
        
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    @objc func showterms(_ sender:UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func searchclicked(_ sender: UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SendInviteViewController") as! SendInviteViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    @IBAction func notifyclicked(_ sender: UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    @IBAction func backclicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutProfileClicked(_ sender: Any) {
        appState.value.logout()
    }
    
    @IBAction func deleteProfileClicked(_ sender: Any) {
        guard let userInfo = appState[\.userData.userInfo] else { return }
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            Task {
                let deletedUser = try await self.repoAuth.deleteProfile(id: userInfo.id)
                if !deletedUser.isEmpty {
                    self.appState.value.logout()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
