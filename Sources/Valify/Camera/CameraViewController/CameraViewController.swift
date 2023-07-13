//
//  CameraViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit
import MLKitFaceDetection


protocol FaceDetection {
    func faceDetected(_ isDetected: Bool)
}

public class CameraViewController: UIViewController, FaceDetection {
    
    private var isFaceDetected = false
    private let cameraController = CameraController()
    public var onCompleted: ((UIImage?,Error?) -> Void)? = nil
    var onDismiss: (() -> Void) = {}
    var onFaceDetected: (() -> Void) = {}
    public var previewView : UIView!
    private var boxView:UIView!
    private var squareView:UIView!
    private let myButton: UIButton = UIButton()
    public var capturedImage: UIImage?
    public var capturedError: Error?
    private var visionImage: UIImage?
    private var toastView: ToastView!
 
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureCameraController()
        cameraController.delegate = self
    
    }

    public override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.cameraController.captureSession?.startRunning()
        }
    }
    
    private func setupView() {
        setpPreviewView()
        setpBoxView()
        setupToastView()
        setupSquareView()
        setpCaptureButton()
    }
    
    private func showToastMessage(msg: String) {
        toastView.showMessage(msg)
    }
    
    func faceDetected(_ isDetected: Bool)  {
        DispatchQueue.main.async {
            if isDetected{
                self.squareView.isHidden = false
                self.isFaceDetected = true
                self.toastView.isHidden = true

            }else{
                self.squareView.isHidden = true
                self.isFaceDetected = false
            }
        }
    }

    private func setupSquareView() {
        squareView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        squareView.center = view.center
        squareView.layer.borderWidth = 2
        squareView.layer.borderColor = UIColor.red.cgColor
        view.addSubview(squareView)
    }
    
    private func setupToastView() {
        toastView = ToastView()
        toastView.backgroundColor = UIColor.black
        toastView.alpha = 0.8
        toastView.layer.cornerRadius = 10
        toastView.frame = CGRect(x: view.bounds.width / 4, y: 80, width: 200, height: 100)
        toastView.isHidden = true
        view.addSubview(toastView)
    }
    
    private func setpPreviewView() {
        previewView = UIView(frame:
        CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,
                height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
    }
    
    private func setpBoxView() {
        boxView = UIView(frame: self.view.frame)
        view.addSubview(boxView)
    }
    
    private func setpCaptureButton() {
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 40
        let xPosition = (self.view.bounds.width - buttonWidth) / 2
        let yPosition = self.view.bounds.height - 100

        let captureButton = UIButton(title: "done", frame: CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight),backgroundColor: UIColor.red)

        captureButton.addTarget(self, action: #selector(self.onClickCaptureButton), for: .touchUpInside)
        
        view.addSubview(captureButton)
    }
    
  
    @objc func onClickCaptureButton(sender: UIButton){
        if isFaceDetected {
            handleCapturingImage()
        }else{
            showToastMessage(msg: "No Face is detected")
            self.toastView.isHidden = false
        }
       
    }
    
    
    private func handleCapturingImage() {
        cameraController.captureImage { image, error in
            guard let image = image else {
                print(error ?? "Image capture error")
                self.onCompleted?(nil,error)
                return
            }
            
            let photoPreviewVC = PhotoPreviewViewController()
            photoPreviewVC.imageView.image = image
            
            photoPreviewVC.onCompleted = { [weak self] image, error in
                self?.capturedImage = image
                self?.capturedError = error
                self?.onCompleted?(image, nil)
                
                self?.dismiss(animated: true)
            }
            
            photoPreviewVC.onDismiss  = {
                DispatchQueue.global(qos: .background).async {
                    self.cameraController.captureSession?.startRunning()
                }
            }
            photoPreviewVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(photoPreviewVC, animated: true)
        }
    }
    
    private func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.previewView)
        }
    }
    

}
