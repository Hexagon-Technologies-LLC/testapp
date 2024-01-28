//
//  SendInviteViewController.swift
//  KMe
//
//  Created by CSS on 05/10/23.
//

import UIKit

class SendInviteViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var searchview: UIView!
    @IBOutlet weak var searchresulttableview: UITableView!
    @IBOutlet weak var userview: UIView!
    @IBOutlet weak var searchfield: UITextField!
    @IBOutlet weak var relationview: MaterialOutlinedTextField!
    
    
    let relationMaster = ["Mother", "Father", "Son", "Wife", "Cousin", "Uncle", "Friend", "Other"]
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchview.layer.borderWidth = 1.0
        searchview.layer.borderColor = UIColor.init(named: "accent")?.cgColor
        searchresulttableview.layer.cornerRadius = 10
        searchresulttableview.clipsToBounds = true
        // Do any additional setup after loading the view.
        searchfield.attributedPlaceholder = NSAttributedString(
            string: "Search by name or email id…",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        searchfield.tag = 1001
        searchfield.delegate = self
        searchresulttableview.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
        
        userview.isHidden = true
        searchresulttableview.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        updatetextfield(t: relationview,label: "Select Relationship",imagename: "gender")
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(chooseDatepicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.tintColor = .black
        relationview.inputAccessoryView = toolbar
        relationview.inputView = pickerView
        
        
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
    @objc func chooseDatepicker(){
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }  
    @IBAction func backnavigation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return relationMaster.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return relationMaster[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        relationview.text = relationMaster[row]
        // relationview.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APPCONTENT.getinvitemember.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchresulttableview.isHidden = true
        searchfield.resignFirstResponder()
        userview.isHidden = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        let memobj = APPCONTENT.getinvitemember[indexPath.row] as! InviteMember
        cell.profileimage.loadImageUsingCache(withUrl: memobj.image ?? "")
        cell.profilename.text = memobj.profileName
        cell.emailid.text = memobj.memberemail
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("done clicked")
        if(textField.tag == 1001)
        {
            searchresulttableview.isHidden = false
            userview.isHidden = true
        }
        textField.resignFirstResponder()
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.tag == 1001)
        {
            searchresulttableview.isHidden = false
            userview.isHidden = true
        }
        return true;
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        print("start editing")
        
        print(textField.tag)
        if(textField.tag == 1001)
        {
            searchresulttableview.isHidden = false
            userview.isHidden = true
            searchview.layer.borderColor = UIColor.init(named: "accent")?.cgColor
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        print("end editing")
        if(textField.tag == 1001)
        {
            //            searchresulttableview.isHidden = false
            //            userview.isHidden = true
            
        }
        searchview.layer.borderColor = UIColor.white.cgColor
        return true
    }
    
}
