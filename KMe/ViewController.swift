//
//  ViewController.swift
//  KMe
//
//  Created by CSS on 04/09/23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //trigger after 1 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Your code with navigate to another controller
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GetstartedViewController") as! GetstartedViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //hide default navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    @IBAction func flingActionCallback(_ sender: FlingActionButton){
        
        
    }
}

