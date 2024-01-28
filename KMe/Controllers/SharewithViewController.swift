//
//  NotificationViewController.swift
//  KMe
//
//  Created by CSS on 21/09/23.
//

import UIKit

class SharewithViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        APPCONTENT.getsharewith.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareTableViewCell", for: indexPath) as! ShareTableViewCell
        let item = APPCONTENT.getsharewith[indexPath.row] as! Sharedwith
        cell.username.text = item.profileName
        cell.descriptionlbl.text = item.description
        cell.timesince.text = item.timesince
        cell.tolabel.text = item.toshare
        cell.profileimage.loadImageUsingCache(withUrl: item.image ?? "")
        return cell
    }
    
    @IBOutlet weak var recentactivitytable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentactivitytable.register(UINib(nibName: "ShareTableViewCell", bundle: nil), forCellReuseIdentifier: "ShareTableViewCell")
        // Do any additional setup after loading the view.
        self.recentactivitytable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
    }
    
    
    @IBAction func backnavigation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
