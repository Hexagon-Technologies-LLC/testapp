//
//  ProfileCompletionViewController.swift
//  KMe
//
//  Created by CSS on 07/09/23.
//

import UIKit
import SSCustomTabbar
import Combine

class ProfileCompletionViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate,regionselectiondelegate {
    
    /** Delegate function for region selection field popup dismiss*/
    func regionclosed() {
        self.dismissPopup(completion: nil)
    }
    
    /** Delegate function for region selection applied*/
    func regionselectionapplied(countries: NSMutableArray) {
        
        region.text = countries.componentsJoined(by: ",")
        region.sendActions(for: .editingChanged)
        
        selectedcountries.removeAllObjects()
        selectedcountries.addObjects(from: countries as! [String])
        self.dismissPopup(completion: nil)
        if(selectedcountries.count > 0)
        {
            region.isHidden  = true
        }else
        {
            region.isHidden = false
        }
    }
    
    /** Declare iboutlet components*/
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var regionlayout: UIStackView!
    @IBOutlet weak var firstname: MaterialOutlinedTextField!
    @IBOutlet weak var middlename: MaterialOutlinedTextField!
    @IBOutlet weak var lastname: MaterialOutlinedTextField!
    @IBOutlet weak var dateofbirth: MaterialOutlinedTextField!
    @IBOutlet weak var gender: MaterialOutlinedTextField!
    @IBOutlet weak var region: MaterialOutlinedTextField!
    @IBOutlet weak var flaglayout: UIStackView!
    @IBOutlet weak var regionview: UIView!
    @IBOutlet weak var flingBtn: FlingActionButton!
    
    var selectedcountries : NSMutableArray = NSMutableArray()
    var isExpand:Bool = false
        /**Master vlaues for gender**/
    let genderpicker = ["Male","Female","Other","Don't want to specify"]
    var pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    
    private var viewModel: ProfileCompletionViewModel!
    private var cancelBag = CancelBag()
    @LazyInjected var repoAuth: AuthRepository
    
    class func makeVC(email: String) -> ProfileCompletionViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ProfileCompletionViewController") as! ProfileCompletionViewController
        let viewModel = ProfileCompletionViewModel(registerEmail: email)
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscription()
        bindingToViewModel()
    }
 
    func bindingToViewModel() {
        firstname.textPublisher
            .assign(to: \.firstName, on: viewModel)
              .store(in: cancelBag)
        middlename.textPublisher
              .assign(to: \.middleName, on: viewModel)
              .store(in: cancelBag)
        lastname.textPublisher
              .assign(to: \.lastName, on: viewModel)
              .store(in: cancelBag)
        dateofbirth.textPublisher
              .assign(to: \.dateOfBirth, on: viewModel)
              .store(in: cancelBag)
        gender.textPublisher
              .assign(to: \.gender, on: viewModel)
              .store(in: cancelBag)
        region.textPublisher
              .assign(to: \.region, on: viewModel)
              .store(in: cancelBag)
    }
    
    func subscription() {
        cancelBag.collect {
            viewModel.$userInfo.dropFirst().sink { userInfo in
                KMAlert.alert(title: "", message: "Register Successfully") { action in
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController  = storyBoard.instantiateViewController(withIdentifier: "SSCustomTabBarViewController") as! SSCustomTabBarViewController
                    self.navigationController?.pushViewController(nextViewController, animated:true)
                }
            }
            
            viewModel.$errorMessage.dropFirst().sink { error in
                KMAlert.alert(title: "", message: error) { _ in
                    self.flingBtn.reset()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /** to stop editing and close keyboard**/
        self.view.endEditing(true)
        
        /** to update rightview for textfield**/
        
        updatetextfield(t: firstname,label: "First name",imagename: "")
        updatetextfield(t: middlename,label: "Middle name",imagename: "")
        updatetextfield(t: lastname,label: "Last name",imagename: "")
        updatetextfield(t: dateofbirth,label: "Date of birth",imagename: "calendar")
        updatetextfield(t: gender,label: "Gender",imagename: "gender")
        updatetextfield(t: region,label: "Select Regions",imagename: "regions")
        
        /** to setup delegate  for textfield and pickers **/
        firstname.delegate = self
        lastname.delegate = self
        middlename.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        region.delegate = self

        
        /** Add toolbar view for gender field*/
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
                toolbar.setItems([spaceButton,cancelButton], animated: false)
        gender.inputAccessoryView = toolbar
        gender.inputView = pickerView
        
        /*method to setup tool bar for date of birth field*/
        showDatePicker()
        
        
        /**Hide default navigation bar**/
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateofbirth.inputAccessoryView = toolbar
        dateofbirth.inputView = datePicker
    }
    
    
    @objc func donedatePicker(){
        if datePicker.date > Defined.MINIMUM_AGE {
            // Age under 18
            KMAlert.alert(title: "Invalid Age", message: "You must be over 18 years old ") { _ in
                
            }
            self.view.endEditing(true)
            return
        }
        
        dateofbirth.text = datePicker.date.toString()
        dateofbirth.sendActions(for: .editingChanged)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func updatetextfield(t: MaterialOutlinedTextField,label:String,imagename: String)  {
        t.label.text = label
        t.placeholder = label
        t.clearButtonMode = .whileEditing
        
        /*update border radius border color and floating text */
        t.setColorModel(ColorModel(textColor: .white, floatingLabelColor: UIColor.init(named: "textFieldBorder")!, normalLabelColor: UIColor.init(named: "textFieldBorder")!, outlineColor: UIColor.init(named: "textFieldBorder")!), for: .normal)
        t.setColorModel(ColorModel(textColor: .white, floatingLabelColor: UIColor.init(named: "accent")!, normalLabelColor: .white, outlineColor: UIColor.init(named: "accent")!), for: .editing)
        t.setColorModel(ColorModel(with: .disabled), for: .disabled)
        
        /** set rightview always visible*/
        t.rightViewMode = .always
        
        
        if(!imagename.isEmpty)
        {
            /** construct right view for textfield */
            let imgcontainer = UIView(frame: CGRect(x: 5, y: 5, width: 40, height: 56))
            imgcontainer.backgroundColor = .clear
            let imageView = UIImageView(frame: CGRect(x: 5, y: 18, width: 20, height: 20))
            let image = UIImage(named: imagename)
            imageView.image = image
            imageView.tintColor = UIColor.init(named: "accent")
            imageView.contentMode = .scaleAspectFit
            imgcontainer.addSubview(imageView)
            t.rightView = imgcontainer
        }
    }
    
    /**Call back action method for filing button**/
    @IBAction func flingActionCallback(_ sender: FlingActionButton) {
        viewModel.register()
    }
    
    
    /**Text field delegate function when user click return button**/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /**This will dismiss keyboard and exit from textfield**/
        textField.resignFirstResponder()
        return true
    }
    
    /**Text field delegate function when user click on that textfield**/

    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
        
        if(textField == region)
        {
            
            print(selectedcountries)
            let popupVC = self.setPopupVC(storyboradID: "Main", viewControllerID: "CountryselectionViewController") as? CountryselectionViewController
            popupVC?.popupAlign = .center
            popupVC?.touchDismiss = true
            popupVC?.popupSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            popupVC?.popupCorner = 0
            popupVC?.selectedcountry.addObjects(from: selectedcountries as! [String] )
            popupVC?.regiondelegate = self;
            self.presentPopup(controller: popupVC!, completion: nil)
            self.view.endEditing(true)
        }
    }
    
    /**Text field delegate function called when user click finish editing  on that textfield**/
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
       
        return true
    }
    
    /**Delegate  and datasource method for picker views **/

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /**Delegate  and datasource method for picker views **/
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return genderpicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return genderpicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        gender.text = genderpicker[row]
        gender.resignFirstResponder()
        gender.sendActions(for: .editingChanged)
    }
}
