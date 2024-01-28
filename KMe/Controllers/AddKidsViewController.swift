//
//  AddKidsViewController.swift
//  KMe
//
//  Created by CSS on 05/10/23.
//

import UIKit
import SSCustomTabbar

class AddKidsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate,regionselectiondelegate {
    
    /**Delegate function definition for region pickers**/
    func regionclosed() {
        self.dismissPopup(completion: nil)

    }
    
    /**Delegate function definition for region pickers**/
    func regionselectionapplied(countries: NSMutableArray) {
       
        /**customized the view after selecting country**/
        region.text = countries.componentsJoined(by: ",")
        selectedcountries.removeAllObjects()
        selectedcountries.addObjects(from: countries as! [String])
        if(selectedcountries.count > 0)
        {
            regionlayout.isHidden = false
            regionview.isHidden = false
            region.isHidden = true
        }else
        {
            regionlayout.isHidden = true
            region.isHidden = false
            regionview.isHidden = true
        }
        
        /**show selected country flags**/
        updateselectedflag()
        self.dismissPopup(completion: nil)
    }
    
    /**Declare all iboutlet components**/
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var regionlayout: UIStackView!
    @IBOutlet weak var flaglayout: UIStackView!
    @IBOutlet weak var regionview: UIView!
    @IBOutlet weak var firstname: MaterialOutlinedTextField!
    @IBOutlet weak var middlename: MaterialOutlinedTextField!
    @IBOutlet weak var lastname: MaterialOutlinedTextField!
    @IBOutlet weak var dateofbirth: MaterialOutlinedTextField!
    @IBOutlet weak var gender: MaterialOutlinedTextField!
    @IBOutlet weak var region: MaterialOutlinedTextField!
    @IBOutlet weak var relations: MaterialOutlinedTextField!

    
    var selectedcountries : NSMutableArray = NSMutableArray()
    var isExpand:Bool = false

    
    /**Master values for relation and genders**/
    let relationmaster = ["Mother", "Father", "Son", "Wife", "Cousin", "Uncle", "Friend", "Other"]
    let genderpicker = ["Male","FeMale","Other"]

    
    var pickerView = UIPickerView()
    var relationpickerView = UIPickerView()

    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        let countrygesture = UITapGestureRecognizer(target: self, action:  #selector (self.chooseCountry (_:)))
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        regionview.isUserInteractionEnabled = true
        regionview.addGestureRecognizer(countrygesture)
    }
    
    /**Click action for regionview**/
    @objc func chooseCountry(_ sender:UITapGestureRecognizer){
        /**Open the country picker popover**/
        let popupVC = self.setPopupVC(storyboradID: "Main", viewControllerID: "CountryselectionViewController") as? CountryselectionViewController
            popupVC?.popupAlign = .center
               popupVC?.touchDismiss = true
               popupVC?.popupSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 80)
               popupVC?.popupCorner = 0
         popupVC?.selectedcountry.addObjects(from: selectedcountries as! [String] )
         popupVC?.regiondelegate = self;
           self.presentPopup(controller: popupVC!, completion: nil)
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
       
        /**add rightview for uitextfield**/
        updatetextfield(t: firstname,label: "First name",imagename: "")
        updatetextfield(t: middlename,label: "Middle name",imagename: "")
        updatetextfield(t: lastname,label: "Last name",imagename: "")
        updatetextfield(t: relations,label: "Relationship",imagename: "gender")
        updatetextfield(t: gender,label: "Gender",imagename: "gender")
        updatetextfield(t: dateofbirth,label: "Date of birth",imagename: "calendar")
        updatetextfield(t: region,label: "Select regions",imagename: "regions")
        
        /**Delegate and datasource method for form components**/
        firstname.delegate = self
        lastname.delegate = self
        middlename.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        relationpickerView.delegate = self
        relationpickerView.dataSource = self
        
        
        /**Toolbar for genderpicker**/
        let toolbar = UIToolbar();
        toolbar.sizeToFit()

         let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
       let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donegenderPicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.tintColor = .black
        gender.inputAccessoryView = toolbar
        gender.inputView = pickerView
        
        /**Add inputt accessory view for relationship picker**/
        relations.inputAccessoryView = toolbar
        relations.inputView = relationpickerView
        
        /**call function to setup datepicker**/
        showDatePicker()
        region.delegate = self
       
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    
    @objc func donegenderPicker(){
        gender.resignFirstResponder()
        self.view.endEditing(true)

    }
    
      @objc func donedatePicker(){

       
          print("datapicker")
          print(datePicker.date)
          
       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"
          dateofbirth.text = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
     }
    
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = .clear
        datePicker.tintColor = .black
       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
         toolbar.tintColor = .black
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)

        dateofbirth.inputAccessoryView = toolbar
        dateofbirth.inputView = datePicker

     }

 
     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateselectedflag()
    {
        flaglayout.subviews.forEach({ $0.removeFromSuperview() })
        print(selectedcountries)
        for countryname in selectedcountries {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.clear
            imageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage.init(named: countryname as! String)
            if(flaglayout.subviews.count < 4)
            {
                flaglayout.addArrangedSubview(imageView)
            }
        }
        if(selectedcountries.count > 4)
        {
            let label:UILabel = UILabel()
            label.textColor=UIColor.white
            label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            label.text = "+\(selectedcountries.count - 4)"
            label.sizeToFit()
            flaglayout.addArrangedSubview(label)
        }
    }
    func updatetextfield(t: MaterialOutlinedTextField,label:String,imagename: String)  {
        t.label.text = label
        t.placeholder = label
        t.clearButtonMode = .whileEditing
        t.setColorModel(ColorModel(textColor: .white, floatingLabelColor: UIColor.init(named: "textFieldBorder")!, normalLabelColor: UIColor.init(named: "textFieldBorder")!, outlineColor: UIColor.init(named: "textFieldBorder")!), for: .normal)
        t.setColorModel(ColorModel(textColor: .white, floatingLabelColor: UIColor.init(named: "accent")!, normalLabelColor: .white, outlineColor: UIColor.init(named: "accent")!), for: .editing)
        t.setColorModel(ColorModel(with: .disabled), for: .disabled)
        t.rightViewMode = .always
     
        if(!imagename.isEmpty)
        {
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
    @IBAction func flingActionCallback(_ sender: FlingActionButton){
        print("clicked")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController  = storyBoard.instantiateViewController(withIdentifier: "SSCustomTabBarViewController") as! SSCustomTabBarViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("done clicked")
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
     
        
        if(textField == region)
        {
            self.view.endEditing(true)
            
            print(selectedcountries)

            let popupVC = self.setPopupVC(storyboradID: "Main", viewControllerID: "CountryselectionViewController") as? CountryselectionViewController
                  popupVC?.popupAlign = .center
                  popupVC?.touchDismiss = true
            popupVC?.popupSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - 80)

                  popupVC?.popupCorner = 16
            popupVC?.selectedcountry.addObjects(from: selectedcountries as! [String] )
            popupVC?.regiondelegate = self;
              self.presentPopup(controller: popupVC!, completion: nil)

            
            
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController  = storyBoard.instantiateViewController(withIdentifier: "CountryselectionViewController") as! CountryselectionViewController
//            self.present(nextViewController, animated:true)
        }
       

    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }

  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
       {
           if(pickerView == relationpickerView)
           {
               return relationmaster.count
           }
           return APPCONTENT.getgender.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
       {
           if(pickerView == relationpickerView)
           {
               return relationmaster[row]
           }else
           {
               return APPCONTENT.getgender[row] as? String
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
       {
           if(pickerView == relationpickerView)
           {
               relations.text = relationmaster[row]
           }else
           {
               gender.text = APPCONTENT.getgender[row] as? String
           }
       }
    @IBAction func backnavigation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

