//
//  CameraViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit
import Photos

class CameraViewController: UIViewController {

    let cameraController = CameraController()
    @IBOutlet fileprivate var capturePreviewView: UIView!
    var onCompleted: ((UIImage?,Error?) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCameraController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .background).async {
              self.cameraController.captureSession?.startRunning()
          }
    }
    
    func configureCameraController() {
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
    }
    
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
//            try cameraController.switchCameras()
        }

        catch {
            print(error)
        }

    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        
        cameraController.captureImage { image, error in
            guard let image = image else {
                print(error ?? "Image capture error")
                 self.onCompleted?(nil,error)
                return
            }
            let photoPreviewVC = PhotoPreviewViewController()
                        photoPreviewVC.imageView = image
                        photoPreviewVC.onCompleted = { [weak self] image, error in
            
                            self?.onCompleted?(image, nil)
                        }
//                        self.navigationController?.pushViewController(photoPreviewVC, animated: true)
//            try? PHPhotoLibrary.shared().performChangesAndWait {
           ////                PHAssetChangeRequest.creationRequestForAsset(from: image)
                ///}
            
        }
    }
    
}
