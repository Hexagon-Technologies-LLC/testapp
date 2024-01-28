//
//  DocSummaryViewController.swift
//  KMe
//
//  Created by CSS on 19/09/23.
//

import UIKit
import ToastViewSwift

class DocSummaryViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,Optiondelegate {
    func menuselected(menuitem: Int) {
        self.docdetails.menuview.fadeOut()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SharewithViewController") as! SharewithViewController
        
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    func copyclipboardsuccess() {
        
        let config = ToastConfiguration(
            direction: .top,
            dismissBy: [.time(time: 4.0), .swipe(direction: .natural), .longPress],
            animationTime: 0.2
        )
        
        let toast = Toast.text("Share link is copied!", config: config)
        
        toast.show()
    }
    
    func optionselected(menuitem: Int) {
        
        self.docdetails.menuview.fadeIn()
        
    }
    
    func optionclose() {
        self.docdetails.menuview.fadeOut()
    }
    
    
    var isexpired : Bool = false;
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardbgview: UIView!
    @IBOutlet weak var docdetails: DocumentDetails!
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var heightconstraint: NSLayoutConstraint!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        APPCONTENT.getrecenactivity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        let activity_obj = APPCONTENT.getrecenactivity[indexPath.row] as! Activity;
        cell.profileimage.loadImageUsingCache(withUrl: activity_obj.image ?? "")
        cell.profilename.text = activity_obj.profileName
        cell.timesince.text = activity_obj.timesince
        
        return cell
    }
    
    @IBOutlet weak var recentactivitytable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentactivitytable.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
        self.viewScroll.contentInset = UIEdgeInsets(top: 16 , left: 0, bottom: 44, right: 0)
        // Do any additional setup after loading the view.
        docdetails.optiondelegate = self
        
        if(isexpired)
        {
            docdetails.expireview.isHidden = true
            docdetails.expiredaysview.isHidden = false
            docdetails.expiredate.text = ""
            docdetails.expiredate.isHidden = true
            
        }else
        {
            docdetails.expiredaysview.isHidden = true
            docdetails.expireview.isHidden = false
            docdetails.expiredate.text = "Expired on 12-Mar-2022"
            docdetails.expiredate.isHidden = false
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        heightconstraint.constant = CGFloat(APPCONTENT.getrecenactivity.count * 80) + 32
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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.recentactivitytable.reloadData()
        self.recentactivitytable.invalidateIntrinsicContentSize()
        heightconstraint.constant = self.recentactivitytable.contentSize.height
        self.recentactivitytable.tableFooterView = UIView()
        
        
    }
}
