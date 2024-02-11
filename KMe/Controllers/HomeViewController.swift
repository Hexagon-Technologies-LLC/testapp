//
//  MembersViewController.swift
//  KMe
//
//  Created by CSS on 13/09/23.
//

import UIKit
import ToastViewSwift

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,Optiondelegate {
    @IBOutlet weak var lbUserName: UILabel!
    @LazyInjected var appState: AppStore<AppState>
    
    func menuselected(menuitem: Int) {
        
        self.selectedview.menuview.fadeOut()
        
        if(menuitem == 0)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SharewithViewController") as! SharewithViewController
            
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
        if(menuitem == 2)
        {
            showconfirmalert()
        }
        
    }
    
    func showconfirmalert()
    {
        KMAlert.actionSheetConfirm(title: "", message: "Please confirm before proceeding to deleting the document.", submitTitle: "Delete") { _ in
            // Cancel
        } submitAction: { _ in
            // Delete
        }
    }
    
    func copyclipboardsuccess() {
        let config = ToastConfiguration(
            direction: .bottom,
            dismissBy: [.time(time: 2.0), .swipe(direction: .natural), .longPress],
            animationTime: 0.2
        )
        
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Montserrat-Semibold", size: 15)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attributedString  = NSMutableAttributedString(string: "Share link is copied!" , attributes: attributes)
        let toast = Toast.text(attributedString,config: config)
        
        
        toast.show()
        //    let toast = Toast.text("Share link is copied!", config: config)
        
        // toast.show()
    }
    
    func optionselected(menuitem: Int) {
        
        self.selectedview.menuview.fadeIn()
        
        
        
    }
    
    func optionclose() {
        self.selectedview.menuview.fadeOut()
    }
    
    
    var selectedcountry:Int = 0
    var selectedview: Documentsummary = Documentsummary()
    var selectedindex:Int = 0
    var cardposition:Int = 0;
    
    @IBOutlet weak var Countrypicker: UICollectionView!
    var locations = ["All", "India", "UK", "USA", "Canada", "Australia"]
    var country_flags = ["All", "flag", "UK", "USA", "Canada", "aus"]
    
    var document_names = ["Upload Passport","Upload Voter ID Card","Aadhaar Card","Driving License","PAN Card"]
    var document_placeholder = ["passport_placeholder","voterid_placeholder","aadhaar","drivinglicence_placehoder","pancard"]
    
    
    var documents = [1,1,3,3,3]
    var list = ["1", "2", "3"]
    var colornames = [UIColor.green,UIColor.red,UIColor(named: "drivinglicence"),UIColor(named: "aadhaar_color"),UIColor(named: "accent")]
    
    @IBOutlet weak var documentview: UIStackView!
    @IBOutlet weak var tagview: UILabel!
    @IBOutlet weak var welcomemessage: UILabel!
    
    let optionview = MoreoptionView()
    
    override func viewDidLoad() {
        guard let userInfo = appState[\.userData.userInfo] else { return }
        
        super.viewDidLoad()
        registerNib()
        _ = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.invalidateLayout()
        Countrypicker.collectionViewLayout = layout
        Countrypicker.dataSource = self;
        Countrypicker.delegate = self;
        Countrypicker.reloadData();
        
        let documentname = "KMe";
        
        let textcontent = "Welcome to KMe"
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 15.0)! ]
        let myString = NSMutableAttributedString(string: textcontent, attributes: myAttribute )
        let myRange = NSRange(location: textcontent.count - (documentname.count) , length: documentname.count) // range starting at location 17 with a lenth of 7: "Strings"
        myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "accent")!, range: myRange)
        welcomemessage.attributedText = myString
        lbUserName.text = "Hi \(userInfo.last_name)"
        //Stack View
        documentview.axis  = NSLayoutConstraint.Axis.vertical
        documentview.alignment = UIStackView.Alignment.center
        documentview.spacing   = -32.0
        selectedindex = documents.count - 1
        cardposition = 0;
        for index in documents {
            addnewview(staus: documents[index],indexval: cardposition)
            cardposition = cardposition + 1;
        }
        documentview.translatesAutoresizingMaskIntoConstraints = false
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tagview.numberOfLines = 0
        tagview.text = "Begin by uploading your documents"
        tagview.sizeToFit()
    }
    
    func addnewview(staus: Int,indexval : Int)  {
        switch staus {
        case 1:
            let uploadView = Bundle.main.loadNibNamed("Uploadstackview", owner: self, options: nil)?.first as! UIView
            uploadView.backgroundColor = UIColor(named: "Uploadbg")
            uploadView.heightAnchor.constraint(equalToConstant:90).isActive = true
            uploadView.widthAnchor.constraint(equalToConstant:  self.view.frame.size.width).isActive = true
            uploadView.roundCorners(cornerRadius: 20)
            
            uploadView.applyGradient(colours: [UIColor(named: "gradient_top")!,UIColor(named: "gradient_bottom")!])
            uploadView.layer.borderWidth = 0.75
            uploadView.layer.borderColor = UIColor.lightGray.cgColor
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.uploadAction (_:)))
            uploadView.addGestureRecognizer(gesture)
            
            if let namelabel = uploadView.viewWithTag(33) as? UILabel {
                namelabel.text = document_names[indexval]
                namelabel.textColor = .white
                namelabel.bringSubviewToFront(uploadView)
            }
            
            
            if let docimage = uploadView.viewWithTag(44) as? UIImageView {
                docimage.image = UIImage(named: document_placeholder[indexval])
                docimage.tintColor = .white
            }
            documentview.addArrangedSubview(uploadView)
            
            
            break;
            
        case 3:
            
            
            let documentView = Documentsummary()
            documentView.bgview.backgroundColor = colornames[indexval]
            documentView.namelabel.text = document_names[indexval]
            documentView.docimage.image = UIImage(named: document_placeholder[indexval])
            documentView.docimage.tintColor = .black
            if(selectedindex != indexval)
            {
                documentView.bottomconstraint.constant = 44
                documentView.menubottomconstraint.constant = 44
                documentView.documentview.isHidden = true
                documentView.actionview.isHidden = true
                
            }else
            {
                documentView.bottomconstraint.constant = 24
                documentView.menubottomconstraint.constant = 24
                documentView.documentview.isHidden = false
                documentView.actionview.isHidden = false
                
                
                
            }
            
            
            documentView.widthAnchor.constraint(equalToConstant:  self.view.frame.size.width).isActive = true
            documentView.bgview.layer.cornerRadius = 20;
            documentView.tag = indexval
            documentView.bgview.clipsToBounds = true
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
            documentView.addGestureRecognizer(gesture)
            documentView.bgview.layer.shadowColor = UIColor.black.cgColor
            documentView.bgview.layer.shadowOpacity = 1
            documentView.bgview.layer.shadowOffset = .zero
            documentView.bgview.layer.shadowRadius = 10
            documentView.optiondelegate = self
            selectedview = documentView
            documentview.addArrangedSubview(documentView)
            
            break;
        default:
            break;
        }
    }
    
    @objc func uploadAction(_ sender:UITapGestureRecognizer){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CaptureViewController") as! CaptureViewController
        
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        
        UIView.animate(withDuration: 1.0, animations: {
            
        }) { (finished) in
            self.selectedview.menuview.isHidden = true
            self.selectedview.actionview.isHidden = true
            self.selectedview.documentview.isHidden = true
            let expandview = sender.view as! Documentsummary
            expandview.actionview.isHidden = false
            expandview.documentview.isHidden = false
            self.selectedview = expandview
        }
        print(selectedindex)
        if(selectedindex ==  sender.view?.tag  ?? 0)
        {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DocSummaryViewController") as! DocSummaryViewController
            if(selectedindex == 2)
            {
                nextViewController.isexpired = true
                
            }else
            {
                nextViewController.isexpired = false
                
            }
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
        
        selectedindex = sender.view?.tag  ?? 0
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return locations.count;
    }
    func registerNib() {
        let nib = UINib(nibName: CountryCollectionViewCell.nibName, bundle: nil)
        Countrypicker?.register(nib, forCellWithReuseIdentifier: CountryCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.Countrypicker?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.reuseIdentifier, for: indexPath) as! CountryCollectionViewCell;
        
        let location = locations[indexPath.row];
        cell.nameLabel.text = location;
        cell.nameLabel.sizeToFit()
        if(indexPath.row == selectedcountry)
        {
            
            cell.badgeimg.alpha = 1
            cell.badgeview.backgroundColor = .clear
            cell.nameLabel.textColor = .white
            cell.cellbg.layer.borderColor = UIColor.white.cgColor
            cell.badgetxt.textColor = .white
            cell.badgeview.backgroundColor = UIColor(named: "inactivebadgebg")
            
        }else
        {
            cell.badgetxt.textColor = UIColor(named: "inactivebadge")
            cell.badgeimg.alpha = 0.2
            cell.badgeview.backgroundColor = UIColor(named: "inactivebadgebg")
            cell.nameLabel.textColor = UIColor(named: "inactivetextcolor")
            cell.cellbg.layer.borderColor = UIColor(named: "inactiveborder")?.cgColor
            cell.badgetxt.textColor = UIColor(named: "inactivebadge")
            
        }
        if(location == "All")
        {
            cell.flagview.isHidden = true
        }else
        {
            cell.badgeimg.image = UIImage.init(named: country_flags[indexPath.row])
            
            cell.flagview.isHidden = false
        }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        selectedcountry = indexPath.row
        Countrypicker.reloadData()
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
}
