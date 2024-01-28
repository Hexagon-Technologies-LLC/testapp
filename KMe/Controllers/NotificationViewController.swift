//
//  NotificationViewController.swift
//  KMe
//
//  Created by CSS on 21/09/23.
//

import UIKit

class NotificationViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var recentactivitytable: UITableView!
    
    
    //datasource method to show how many rows in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  APPCONTENT.getnotifications.count
    }
    
    //datasource method to what need to show in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        let notifyobj = APPCONTENT.getnotifications[indexPath.row] as! Notify
        cell.updatecelldata(profile: notifyobj)
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //register the cell to tableview which want to render in table row
        recentactivitytable.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
        
        //Add bottom padding to show bottom cell fully while scroll down
        self.recentactivitytable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
    }
    
    // click action for back button
    @IBAction func backnavigation(_ sender: Any) {
        //navigate  to previous screen
        self.navigationController?.popViewController(animated: true)
    }
    
}
