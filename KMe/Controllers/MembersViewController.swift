//
//  HomeViewController.swift
//  KMe
//
//  Created by CSS on 06/09/23.
//

import UIKit
fileprivate struct Constants {
    static let scaleMultiplier:CGFloat = 0.35
    static let minScale:CGFloat = 0.50
    static let maxScale:CGFloat = 1.20
    static let minFade:CGFloat = -2.0
    static let maxFade:CGFloat = 2.0
    static let defaultButtonWidth: CGFloat = 120.0
}
class MembersViewController: UIViewController,UICollectionViewDelegate, CircularCarouselDelegate,
                             CircularCarouselDataSource,requestaccessdelegate,Invitedelegate,Requestdelegate {
    func requestclosed() {
        dismissPopup(completion: nil)
    }
    
    
    
    func inviteclicked() {
        showemptyrequest(isnew: false)
    }
    
    // Trigger popup when user click request access button in member content view 
    func requestclick(index: Int) {
        let popupVC = self.setPopupVC(storyboradID: "Main", viewControllerID: "RequestAccessViewController") as? RequestAccessViewController
        popupVC?.popupAlign = .bottom
        popupVC?.messageeditor.becomeFirstResponder()
        popupVC?.touchDismiss = true
        popupVC?.requestdelegate = self
        popupVC?.popupSize = CGSize(width: self.view.frame.width - 40, height: self.view.frame.height - 64)
        popupVC?.popupCorner = 16
        self.presentPopup(controller: popupVC!, completion: nil)
    }
    
    
    
    
    
    
    weak private var _carousel : CircularCarousel!
    
    
    //IBOUTLET elements declation
    @IBOutlet var carousel : CircularCarousel! {
        set {
            _carousel = newValue
            _carousel.delegate = self
            _carousel.dataSource = self
        }
        
        get {
            return _carousel
        }
    }
    @IBOutlet weak var profileframe: UIView!
    @IBOutlet weak var bottomcircle: UIView!
    @IBOutlet weak var memberscroll: UIScrollView!
    @IBOutlet weak var memberloading: ShimmerView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var shareto: UILabel!
    @IBOutlet weak var membercontentview: UIView!
    @IBOutlet weak var invitebtn: UIButton!
    @IBOutlet weak var emptycontentview: UIView!
    @IBOutlet weak var documentview: UIStackView!
    @IBOutlet weak var contentview: UIStackView!
    @IBOutlet weak var Countrypicker: UICollectionView!
    
    
    
    
    var selectedindex:Int = 0
    var selectedview: Documentsummary = Documentsummary()
    
    
    
    var selectedcountry:Int = 0
    var documents: NSArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register country cell for uicollectionview
        registerNib()
        
        // add bottom circle view in member card
        addbottomcircle()
        
        
        // Mockdata to show access documents
        documents = APPCONTENT.getMemberDocuments
        for memdoc in documents {
            addnewview(doc: memdoc as! MemberDocument)
        }
        
        // hide memberview initially
        contentview.isHidden = true
        memberloading.isHidden = false
        emptycontentview.backgroundColor = .clear
        
        
        // add bottom padding for member scroll
        self.memberscroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
        
        
        
        
        //Show empty placeholder view when user doesn't have any document access
        let uploadView: EmptyRequestView = UIView.fromNib()
        uploadView.backgroundColor = .clear
        uploadView.invitedelegate = self
        uploadView.frame = emptycontentview.bounds
        emptycontentview.addSubview(uploadView)
        showemptyrequest(isnew: true)
        
        
    }
    
    // switch placholder and contvent view
    func showemptyrequest(isnew: Bool)
    {
        if(isnew)
        {
            invitebtn.isHidden = true
            membercontentview.isHidden = true
            emptycontentview.isHidden = false
        }else
        {
            invitebtn.isHidden = false
            membercontentview.isHidden = false
            emptycontentview.isHidden = true
        }
    }
    @IBAction func switchcdataview(_ sender: UIButton){
        
        self.showemptyrequest(isnew: false)
    }
    
    // update member information in the member card based on user selection
    func updateview(index: Int)
    {
        let memobj = APPCONTENT.getmembers[index] as! Member
        username.text = memobj.profileName
        shareto.text = memobj.relationship
    }
    
    // Render menber content based on mock data
    func addnewview(doc: MemberDocument)  {
        switch doc.status {
        case 1:
            let uploadView: Uploadstackview = UIView.fromNib()
            uploadView.backgroundColor = UIColor.orange
            uploadView.heightAnchor.constraint(equalToConstant:110).isActive = true
            uploadView.widthAnchor.constraint(equalToConstant:  self.view.frame.size.width).isActive = true
            uploadView.roundCorners(cornerRadius: 20)
            uploadView.backgroundColor = UIColor.init(hex: doc.documentColour ?? "FF7639")
            uploadView.requestaccessbtn.isHidden = false
            uploadView.leftimage.isHidden = true
            uploadView.titlelabel.textColor = UIColor.black
            uploadView.layer.borderWidth = 0
            uploadView.layer.borderColor = UIColor.lightGray.cgColor
            uploadView.titlelabel.text = doc.documentName
            uploadView.rightimage.image = UIImage(named: doc.documentPlaceholder ?? "Passport")
            uploadView.rightimage.tintColor = .black
            uploadView.requestdelegate = self
            documentview.addArrangedSubview(uploadView)
            break;
            
        case 3:
            
            
            let documentView = Documentsummary()
            documentView.bgview.backgroundColor = UIColor.init(hex: doc.documentColour ?? "FF7639")
            documentView.namelabel.text = doc.documentName
            documentView.docimage.image = UIImage(named: doc.documentPlaceholder ?? "passport")
            documentView.docimage.tintColor = .black
            if(selectedindex != doc.Id)
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
            documentView.tag = doc.Id
            documentView.bgview.clipsToBounds = true
            documentView.bgview.layer.shadowColor = UIColor.black.cgColor
            documentView.bgview.layer.shadowOpacity = 1
            documentView.bgview.layer.shadowOffset = .zero
            documentView.bgview.layer.shadowRadius = 10
            selectedview = documentView
            documentview.addArrangedSubview(documentView)
            
            break;
        default:
            break;
        }
    }
    
    // Button click for invite button and navigate to InviteViewController
    @IBAction func invitemember(_ sender: UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    // Button click action for search member
    @IBAction func searchemember(_ sender: UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SendInviteViewController") as! SendInviteViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    
    
    // register country selection view cell to country picker
    func registerNib() {
        let nib = UINib(nibName: CountryCollectionViewCell.nibName, bundle: nil)
        Countrypicker?.register(nib, forCellWithReuseIdentifier: CountryCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.Countrypicker?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    // country picker collection view datasource method how many item need to show
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return APPCONTENT.getCountryMaster.count;
    }
    
    
    //country picker collection view datasource method to what need to be show in each cell
    @objc(collectionView:cellForItemAtIndexPath:) private func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCollectionViewCell.reuseIdentifier, for: indexPath) as! CountryCollectionViewCell;
        
        let location = APPCONTENT.getCountryMaster[indexPath.row] as! CountryMaster;
        cell.nameLabel.text = location.name;
        cell.nameLabel.sizeToFit()
        
        // customized selection style when country is selected
        if(indexPath.row == selectedcountry)
        {
            
            cell.badgeimg.alpha = 1
            cell.badgeview.backgroundColor = .clear
            cell.nameLabel.textColor = .white
            cell.cellbg.layer.borderColor = UIColor.white.cgColor
            cell.badgetxt.textColor = .white
            cell.badgeview.backgroundColor = UIColor.init(hex: "1B1313").withAlphaComponent(0.5)
            
        }else
        {
            cell.badgetxt.textColor = UIColor(named: "inactivebadge")
            cell.badgeimg.alpha = 0.2
            cell.badgeview.backgroundColor = UIColor(named: "inactivebadgebg")
            cell.nameLabel.textColor = UIColor(named: "inactivetextcolor")
            cell.cellbg.layer.borderColor = UIColor(named: "inactiveborder")?.cgColor
            cell.badgetxt.textColor = UIColor.white.withAlphaComponent(0.5)
            cell.badgeview.backgroundColor = UIColor.init(hex: "626262")
        }
        
        // hide the country flag if the item is ALL
        
        if(location.name == "All")
        {
            cell.flagview.isHidden = true
        }else
        {
            cell.badgeimg.image = UIImage.init(named: location.flagname)
            
            cell.flagview.isHidden = false
        }
        
        return cell;
    }
    
    
    // collection view delegate method  define what needs to do when user select the country
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedcountry = indexPath.row
        Countrypicker.reloadData()
    }
    
    // add bottom circle
    func addbottomcircle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bottomcircle.frame.size.width/2, y: bottomcircle.frame.size.height/2))
        
        path.addArc(withCenter: CGPoint(x: bottomcircle.frame.size.width/2, y: 0.0),
                    radius: 22.0,
                    startAngle: CGFloat(180.0),
                    endAngle: CGFloat(360.0),
                    clockwise: true)
        
        
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        bottomcircle.backgroundColor = UIColor.init(named: "accent")!
        bottomcircle.layer.mask = shapeLayer
    }
    
    
    // Member carousel view implementation
    
    // carousel view
    func carousel<CGFloat>(_ carousel: CircularCarousel, valueForOption option: CircularCarouselOption, withDefaultValue defaultValue: CGFloat) -> CGFloat {
        switch option {
            
        case .itemWidth:
            return  Constants.defaultButtonWidth as! CGFloat
            
        case .scaleMultiplier:
            return Constants.scaleMultiplier as! CGFloat
            
        case .minScale:
            return Constants.minScale as! CGFloat
            
        case .maxScale:
            return Constants.maxScale as! CGFloat
            
        case .fadeMin:
            return Constants.minFade as! CGFloat
            
        case .fadeMax:
            return Constants.maxFade as! CGFloat
            
        default:
            return defaultValue
        }
    }
    
    func carousel(_: CircularCarousel, viewForItemAt: IndexPath, reuseView: UIView?) -> UIView {
        let roundedButtonView: RoundedButtonView = UIView.fromNib()
        if(viewForItemAt.row < APPCONTENT.getmembers.count)
        {
            let memberobj = APPCONTENT.getmembers[viewForItemAt.row] as! Member
            roundedButtonView.selectedImageView.loadImageUsingCache(withUrl: memberobj.image ?? "")
            return roundedButtonView
            
        }else
        {
            return UIView()
            
        }
    }
    
    func numberOfItems(inCarousel carousel: CircularCarousel) -> Int {
        return APPCONTENT.getmembers.count
    }
    func startingItemIndex(inCarousel carousel: CircularCarousel) -> Int {
        
        return 1
    }
    
    
    func carousel(_ carousel: CircularCarousel, didSelectItemAtIndex index: Int) {
        self.memberloading.startAnimating()
        self.memberloading.isHidden = false
        self.contentview.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.memberloading.isHidden = true
            self.contentview.isHidden = false
            self.updateview(index: index)
        }
        print(index)
    }
    
    func carouselDidEndScrolling(_ carousel: CircularCarousel) {
        self.memberloading.startAnimating()
        self.memberloading.isHidden = false
        self.contentview.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.memberloading.isHidden = true
            self.contentview.isHidden = false
            self.updateview(index: carousel.currentItemIdx)
        }
    }
    
    
    func carousel(_ carousel: CircularCarousel, spacingForOffset offset: CGFloat) -> CGFloat {
        // Tweaked values to support even spacing on scaled items
        return 1.08 - abs(offset * 0.12)
    }
}


