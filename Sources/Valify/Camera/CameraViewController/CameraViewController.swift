//
//  CameraViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit
import Photos
import MLKit

public class CameraViewController: UIViewController {
    let cameraController = CameraController()
    public var onCompleted: ((UIImage?,Error?) -> Void)? = nil
    var onDismiss: (() -> Void) = {}
    public var previewView : UIView!
    var boxView:UIView!
    let myButton: UIButton = UIButton()
    public var capturedImage: UIImage?
    public var capturedError: Error?
    let faceDetector = FaceDetector.faceDetector(options: FaceDetection.getOptions())
    public var visionImage: UIImage?
    
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
    
    func process() {
        weak var weakSelf = self
        faceDetector.process(FaceDetection.createImage(image: capturedImage!)) { faces, error in
          guard let strongSelf = weakSelf else {
            print("Self is nil!")
            return
          }
          guard error == nil, let faces = faces, !faces.isEmpty else {
            // ...
            return
          }

          // Faces detected
          // ...
            self.detectFace(faces: faces)
        }
    }
    func detectFace(faces: [Face]) {
        for face in faces {
          let frame = face.frame
          if face.hasHeadEulerAngleX {
            let rotX = face.headEulerAngleX  // Head is rotated to the uptoward rotX degrees
          }
          if face.hasHeadEulerAngleY {
            let rotY = face.headEulerAngleY  // Head is rotated to the right rotY degrees
          }
          if face.hasHeadEulerAngleZ {
            let rotZ = face.headEulerAngleZ  // Head is tilted sideways rotZ degrees
          }

          // If landmark detection was enabled (mouth, ears, eyes, cheeks, and
          // nose available):
          if let leftEye = face.landmark(ofType: .leftEye) {
            let leftEyePosition = leftEye.position
          }

          // If contour detection was enabled:
          if let leftEyeContour = face.contour(ofType: .leftEye) {
            let leftEyePoints = leftEyeContour.points
          }
          if let upperLipBottomContour = face.contour(ofType: .upperLipBottom) {
            let upperLipBottomPoints = upperLipBottomContour.points
          }

          // If classification was enabled:
          if face.hasSmilingProbability {
            let smileProb = face.smilingProbability
          }
          if face.hasRightEyeOpenProbability {
            let rightEyeOpenProb = face.rightEyeOpenProbability
          }

          // If face tracking was enabled:
          if face.hasTrackingID {
            let trackingId = face.trackingID
          }
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
