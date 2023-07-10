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
    @IBOutlet public var capturePreviewView: UIView!
    public var onCompleted: ((UIImage?,Error?) -> Void)? = nil
    var onDismiss: (() -> Void) = {}
    public var previewView : UIView!
    var boxView:UIView!
    let myButton: UIButton = UIButton()
    public  var  capturedImage: UIImage?
    public  var  capturedError: Error?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        configureCameraController()
     
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .background).async {
            self.cameraController.captureSession?.startRunning()
        }
    }
    
    func setupUI() {
        previewView = UIView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: UIScreen.main.bounds.size.width,
                                           height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        
        //Add a view on top of the cameras' view
        boxView = UIView(frame: self.view.frame)
        
        myButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.setTitle("press me", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:200)
        myButton.addTarget(self, action: #selector(self.onClickMyButton(sender:)), for: .touchUpInside)
        
        view.addSubview(boxView)
        view.addSubview(myButton)
    }
    
    @objc func onClickMyButton(sender: UIButton){
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
    
    
    
    public func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.previewView)
        }
    }
    
}
