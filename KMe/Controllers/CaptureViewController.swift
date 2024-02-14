//
//  CaptureViewController.swift
//  KMe
//
//  Created by CSS on 27/09/23.
//

import UIKit
import AVFoundation
import SVProgressHUD

class CaptureViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    var isfrontcaptured: Bool!
    var isbackcaptured: Bool!
    @IBOutlet weak var btnview: UIStackView!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var cameraview: UIView!
    @IBOutlet weak var descriptionlbl: UILabel!
    
    @IBOutlet weak var retakebtn: UIButton!
    @IBOutlet weak var continuebtn: UIButton!
    
    @Injected var appState: AppStore<AppState>
    private var cancelBag = CancelBag()
    private var viewModel = CaptureViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentname = "Indian Passport";
        let profile_name = "Bruce"
        
        let textcontent = "Please make sure that you upload a valid Indian Passport for Bruce"
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 15.0)! ]
        let myString = NSMutableAttributedString(string: textcontent, attributes: myAttribute )
        let myRange = NSRange(location: textcontent.count - (documentname.count + profile_name.count + 5) , length: documentname.count) // range starting at location 17 with a lenth of 7: "Strings"
        let nameRange = NSRange(location: textcontent.count - ( profile_name.count) , length: profile_name.count)
        myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "accent")!, range: myRange)
        myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "accent")!, range: nameRange)
        
        descriptionlbl.attributedText = myString
        self.subscription()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isfrontcaptured = false;
        isbackcaptured = false;
        btnview.isHidden = true;
        cameraview.isHidden = false
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        startcamera()
        
    }
    
    func subscription() {
        cancelBag.collect {
            viewModel.$loadingState.dropFirst().sink { state in
                switch state {
                case .loading:
                    SVProgressHUD.show()
                case .done:
                    SVProgressHUD.dismiss()
                default: break
                }
            }
            
            viewModel.$errorMessage.dropFirst().sink { error in
                KMAlert.alert(title: "", message: error) { _ in
                }
            }
            
            viewModel.$documentJob.dropFirst().sink { documentData in
                KMAlert.alert(title: "Document Received", message: documentData.debugDescription) { _ in
                    
                }
            }
        }
    }
    
    func startcamera() {
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            self.showcamearaccessalert()
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            
            DispatchQueue.main.async {
                
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
        
    }
    @IBAction func takePhoto(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            captureDocument()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    self.captureDocument()
                } else {
                    //access denied
                }
            })
        }
       
    }
    
    func captureDocument() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
        cameraview.isHidden = true
        btnview.isHidden = false
        // previewView.isHidden = true;
        capturedImage.isHidden = false
    }
    
    @IBAction func toggleflash(_ sender: Any) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video),
              device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOn(level: 1.0)
            device.torchMode = device.isTorchActive ? .off : .on
            device.unlockForConfiguration()
        } catch {
            assert(false, "error: device flash light, \(error)")
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        
        let image = UIImage(data: imageData)
        capturedImage.image = image
        self.captureSession?.stopRunning()
    }
    
    func showcamearaccessalert() {
        KMAlert.alert(title: "", message: "Don't have permission to access back camera") { _ in
        }
    }
    
    @IBAction func backnavigation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func retaake(_ sender: Any) {
        cameraview.isHidden = false;
        //   previewView.isHidden = false;
        capturedImage.isHidden = true;
        btnview.isHidden = true;
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
        }
    }
    
    @IBAction func continuebtn(_ sender: Any) {
//        if !isfrontcaptured  {
            //   previewView.isHidden = false;
            capturedImage.isHidden = true
            cameraview.isHidden = false;
            continuebtn.setTitle("Confirm", for: .normal)
            btnview.isHidden = true
            isfrontcaptured = true
           
            if let imageData = capturedImage.image?.jpegData(compressionQuality: 1)?.base64EncodedString() {
                Task {
                    await viewModel.submitToProgressing(documentBase64: imageData)
                }
            }
//        } else {
//            self.navigationController?.popViewController(animated: true)
//        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
}
