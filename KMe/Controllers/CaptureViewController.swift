//
//  CaptureViewController.swift
//  KMe
//
//  Created by CSS on 27/09/23.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController,AVCapturePhotoCaptureDelegate {
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
    func startcamera()
    {
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
    
    func captureDocument()
    {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        
        self.captureSession?.stopRunning()
        
        
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
    }
    func showcamearaccessalert()
    {
        
        let alert = UIAlertController(title: "", message: "Don't have permission to access back camera", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
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
        if(!isfrontcaptured)
        {
            //   previewView.isHidden = false;
            capturedImage.isHidden = true
            cameraview.isHidden = false;
            continuebtn.setTitle("Confirm", for: .normal)
            btnview.isHidden = true
            isfrontcaptured = true
            DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
                self.captureSession.startRunning()
            }
        }else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
