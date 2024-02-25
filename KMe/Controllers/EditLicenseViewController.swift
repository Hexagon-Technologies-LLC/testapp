//
//  EditLicenseViewController.swift
//  KMe
//
//

import UIKit
import SVProgressHUD

class EditLicenseViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbFirstName: MaterialOutlinedTextField!
    @IBOutlet weak var lbLastName: MaterialOutlinedTextField!
    @IBOutlet weak var lbGender: MaterialOutlinedTextField!
    @IBOutlet weak var lbDateIssue: MaterialOutlinedTextField!
    @IBOutlet weak var lbDateExpired: MaterialOutlinedTextField!
    @IBOutlet weak var lbDOB: MaterialOutlinedTextField!
    
    @IBOutlet weak var lbLicenseNo: MaterialOutlinedTextField!
    @IBOutlet weak var lbRegion: MaterialOutlinedTextField!
    @IBOutlet weak var lbHeight: MaterialOutlinedTextField!
    @IBOutlet weak var lbWeight: MaterialOutlinedTextField!
    @IBOutlet weak var lbEye: MaterialOutlinedTextField!
    @IBOutlet weak var lbStreet: MaterialOutlinedTextField!
    @IBOutlet weak var lbCity: MaterialOutlinedTextField!
    @IBOutlet weak var lbState: MaterialOutlinedTextField!
    @IBOutlet weak var lbPostalCode: MaterialOutlinedTextField!
    @IBOutlet weak var btnSubmit: FlingActionButton!
    
    weak var delegate: EditDocumentControllerDelegate?
    let DOBdatePicker = UIDatePicker()
    let issueDatePicker = UIDatePicker()
    let expiredDatePicker = UIDatePicker()
    
    var genderPickerView = UIPickerView()
    let genderPicker = ["Male","Female","Other"]
    @LazyInjected var appState: AppStore<AppState>
    var viewModel: EditDocumentViewModel!
    private var cancelBag = CancelBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingToViewModel()
        subscription()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.endEditing(true)
        
        guard let editingLicense = viewModel.editingLicense, let data = editingLicense.data  else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        updateTextfield(t: lbFirstName, label: data.first_name, placeholder: "First Name", imagename: "")
        updateTextfield(t: lbLastName, label: data.last_name, placeholder: "Last Name", imagename: "")
        updateTextfield(t: lbGender, label: data.sexString, placeholder: "Gender", imagename: "gender")
        updateTextfield(t: lbDateIssue, label: data.date_of_issue, placeholder: "Date of issue", imagename: "calendar")
        updateTextfield(t: lbDateExpired, label: data.date_of_expiration, placeholder: "Date of expiration", imagename: "calendar")
        updateTextfield(t: lbDOB, label: data.date_of_birth, placeholder: "Date of birth", imagename: "calendar")
        
        updateTextfield(t: lbLicenseNo, label: data.document_number, placeholder: "License No", imagename: "")
        updateTextfield(t: lbRegion, label: data.region, placeholder: "Region", imagename: "")
        updateTextfield(t: lbHeight, label: data.height, placeholder: "Height", imagename: "")
        updateTextfield(t: lbWeight, label: data.weight, placeholder: "Weight", imagename: "")
        updateTextfield(t: lbEye, label: data.eye_color, placeholder: "Eye", imagename: "")
        updateTextfield(t: lbStreet, label: data.street_address, placeholder: "Street", imagename: "")
        updateTextfield(t: lbCity, label: data.city, placeholder: "City", imagename: "")
        updateTextfield(t: lbState, label: data.state, placeholder: "State", imagename: "")
        updateTextfield(t: lbPostalCode, label: data.postal_code, placeholder: "Postal Code", imagename: "")
        
        configureDOBDatePicker()
        configureIssueDatePicker()
        configureExpiredDatePicker()
        configureGenderDatePicker()
    }
    
    func bindingToViewModel() {
        lbFirstName.textPublisher
            .assign(to: \.firstName, on: viewModel)
              .store(in: cancelBag)
        lbLastName.textPublisher
              .assign(to: \.lastName, on: viewModel)
              .store(in: cancelBag)
        lbGender.textPublisher
              .assign(to: \.gender, on: viewModel)
              .store(in: cancelBag)
        lbDateIssue.textPublisher
              .assign(to: \.dateIssue, on: viewModel)
              .store(in: cancelBag)
        lbDateExpired.textPublisher
              .assign(to: \.dateExpired, on: viewModel)
              .store(in: cancelBag)
        lbDOB.textPublisher
              .assign(to: \.dateOfBirth, on: viewModel)
              .store(in: cancelBag)
        
        lbLicenseNo.textPublisher
            .assign(to: \.licenseNo, on: viewModel)
              .store(in: cancelBag)
        lbRegion.textPublisher
              .assign(to: \.region, on: viewModel)
              .store(in: cancelBag)
        lbHeight.textPublisher
              .assign(to: \.height, on: viewModel)
              .store(in: cancelBag)
        lbWeight.textPublisher
              .assign(to: \.weight, on: viewModel)
              .store(in: cancelBag)
        lbEye.textPublisher
              .assign(to: \.eye, on: viewModel)
              .store(in: cancelBag)
        lbStreet.textPublisher
              .assign(to: \.street, on: viewModel)
              .store(in: cancelBag)
        lbCity.textPublisher
            .assign(to: \.city, on: viewModel)
              .store(in: cancelBag)
        lbState.textPublisher
              .assign(to: \.state, on: viewModel)
              .store(in: cancelBag)
        lbPostalCode.textPublisher
              .assign(to: \.postalCode, on: viewModel)
              .store(in: cancelBag)
    }
    
    func subscription() {
        cancelBag.collect {
            viewModel.$loadingState.dropFirst()
                .receive(on: RunLoop.main)
                .sink { state in
                    switch state {
                    case .loading:
                        SVProgressHUD.show()
                    case .done:
                        SVProgressHUD.dismiss()
                    default: break
                    }
                }
            
            viewModel.$errorMessage.dropFirst()
                .receive(on: RunLoop.main)
                .sink { error in
                    KMAlert.alert(title: "", message: error) { _ in
                    }
                }
            
            viewModel.$documentIDAdded.dropFirst()
                .receive(on: RunLoop.main)
                .sink { _ in
                    KMAlert.alert(title: "", message: "Document Upload Successfully") { _ in
                        self.delegate?.reloadCardsAfterUpload()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
        }
    }
    
    func updateTextfield(t: MaterialOutlinedTextField, label:String, placeholder: String = "", imagename: String)  {
        t.label.text = label
        t.placeholder = placeholder
        t.clearButtonMode = .whileEditing
        t.setColorModel(ColorModel(textColor: .white, floatingLabelColor: UIColor.init(named: "textFieldBorder")!, normalLabelColor: UIColor.init(named: "textFieldBorder")!, outlineColor: UIColor.init(named: "textFieldBorder")!), for: .normal)
        t.setColorModel(ColorModel(textColor: .white, floatingLabelColor: UIColor.init(named: "accent")!, normalLabelColor: .white, outlineColor: UIColor.init(named: "accent")!), for: .editing)
        t.setColorModel(ColorModel(with: .disabled), for: .disabled)
        
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
            
            if(t.tag == 1000)
            {
                
                t.leftViewMode = .always
                
                t.leftView = imgcontainer
            }else
            {
                t.rightViewMode = .always
                
                t.rightView = imgcontainer
            }
        }
    }
    
    @IBAction func flingActionDone(_ sender: Any) {
        Task {
          await viewModel.submitLicenseDocument()
        }
    }
    
    @IBAction func backnavigation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditLicenseViewController {
    func configureGenderDatePicker() {
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneGenderPicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.tintColor = .black
        lbGender.inputAccessoryView = toolbar
        lbGender.inputView = genderPickerView
    }
    
    func configureDOBDatePicker() {
        //Formate Date
        DOBdatePicker.datePickerMode = .date
        DOBdatePicker.preferredDatePickerStyle = .inline
        DOBdatePicker.datePickerMode = .date
        DOBdatePicker.preferredDatePickerStyle = .inline
        DOBdatePicker.backgroundColor = .clear
        DOBdatePicker.tintColor = .black
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = .black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDOBDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        lbDOB.inputAccessoryView = toolbar
        lbDOB.inputView = DOBdatePicker
    }
    
    func configureIssueDatePicker() {
        //Formate Date
        issueDatePicker.datePickerMode = .date
        issueDatePicker.preferredDatePickerStyle = .inline
        issueDatePicker.datePickerMode = .date
        issueDatePicker.preferredDatePickerStyle = .inline
        issueDatePicker.backgroundColor = .clear
        issueDatePicker.tintColor = .black
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = .black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneIssueDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        lbDateIssue.inputAccessoryView = toolbar
        lbDateIssue.inputView = issueDatePicker
    }
    
    func configureExpiredDatePicker() {
        //Formate Date
        expiredDatePicker.datePickerMode = .date
        expiredDatePicker.preferredDatePickerStyle = .inline
        expiredDatePicker.datePickerMode = .date
        expiredDatePicker.preferredDatePickerStyle = .inline
        expiredDatePicker.backgroundColor = .clear
        expiredDatePicker.tintColor = .black
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = .black
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneExpiredDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        lbDateExpired.inputAccessoryView = toolbar
        lbDateExpired.inputView = expiredDatePicker
    }
    
    @objc func doneGenderPicker(){
        lbGender.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func doneDOBDatePicker() {
        if viewModel.isAgeInvalid(DOBdatePicker.date) {
            // Age under 18
            KMAlert.alert(title: "Invalid Age", message: "You must be over 18 years old ") { _ in
                
            }
            self.view.endEditing(true)
            return
        }
        lbDOB.text = DOBdatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        lbDOB.sendActions(for: .editingChanged)
        self.view.endEditing(true)
    }
    
    @objc func doneIssueDatePicker() {
        lbDateIssue.text = issueDatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        lbDateIssue.sendActions(for: .editingChanged)
       
        self.view.endEditing(true)
    }
    
    @objc func doneExpiredDatePicker() {
        lbDateExpired.text = expiredDatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        lbDateExpired.sendActions(for: .editingChanged)
        self.view.endEditing(true)
    }
}

extension EditLicenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return APPCONTENT.getgender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return APPCONTENT.getgender[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lbGender.text = APPCONTENT.getgender[row] as? String
        lbGender.sendActions(for: .editingChanged)
    }
}

