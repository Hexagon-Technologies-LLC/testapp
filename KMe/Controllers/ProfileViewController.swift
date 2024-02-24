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
    @IBOutlet weak var lbDOB: UILabel!
    @IBOutlet weak var flagStack: UIStackView!
    
    @LazyInjected var appState: AppStore<AppState>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userInfo = appState[\.userData.userInfo] else { return }
        lbProfileName.text = userInfo.fullName
        lbGender.text = userInfo.gender
        lbDOB.text = userInfo.dob.toDateISO8601()?.toString()
        updateSelectedFlag()
    }
    
    @IBAction func editprofile(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
        
    }
    
    func updateSelectedFlag() {
        flagStack.subviews.forEach({ $0.removeFromSuperview() })
        guard let userInfo = appState[\.userData.userInfo] else { return }
        let regions = userInfo.region.split(separator: ",") as NSArray
        for countryname in regions {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.clear
            imageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.init(named: countryname as! String)
            if(flagStack.subviews.count < 4)
            {
                flagStack.addArrangedSubview(imageView)
            }
        }
        if regions.count > 4 {
            let label:UILabel = UILabel()
            label.textColor=UIColor.white
            label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            label.text = "+\(regions.count - 4)"
            label.sizeToFit()
            flagStack.addArrangedSubview(label)
        }
    }
    
    @IBAction func backnavigation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
