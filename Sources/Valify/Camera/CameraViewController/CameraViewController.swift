//
//  CameraViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit
import Photos

public class CameraViewController: UIViewController {
    let cameraController = CameraController()
    public var onCompleted: ((UIImage?,Error?) -> Void)? = nil
    var onDismiss: (() -> Void) = {}
    public var previewView : UIView!
    var boxView:UIView!
    let myButton: UIButton = UIButton()
    public var capturedImage: UIImage?
    public var capturedError: Error?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        configureCameraController()
     
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.cameraController.captureSession?.startRunning()
        }
    }
    
    private func setupView() {
       setpPreviewView()
        setpBoxView()
        setpCaptureButton()
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
        handleCapturingImage()
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
    
    private  func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.previewView)
        }
    }
    

}
