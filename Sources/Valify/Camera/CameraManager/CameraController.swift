//
//  CameraController.swift
//  CameraDemo
//
//  Created by Mac on 08/07/2023.
//
import AVFoundation
import UIKit
import MLKitVision
import MLKitFaceDetection

class CameraController: NSObject {
    var captureSession: AVCaptureSession?
    
    var currentCameraPosition: CameraPosition? = .front
    
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var rearCamera: AVCaptureDevice?
    var rearCameraInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var flashMode = AVCaptureDevice.FlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var faceDetector = FaceDetector.faceDetector(options: getOptions())
    var delegate: FaceDetection?
    var visionPhoto: VisionImage?

}

extension CameraController {
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        let options = FaceDetectorOptions()
          options.performanceMode = .fast
          options.landmarkMode = .none
          options.classificationMode = .none
          self.faceDetector = FaceDetector.faceDetector(options: options)
        
      
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try self.configureCaptureDevices()
                try self.configureDeviceInputs()
                try self.configurePhotoOutput()
                try self.configureVideoDataOutput()
            }
                
            catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func configureCaptureDevices() throws {

        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front)

        
        
        let cameras = session.devices.compactMap { $0 }
        guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
        
        for camera in cameras {
            if camera.position == .front {
                self.frontCamera = camera
            }
            
            if camera.position == .back {
                self.rearCamera = camera
                
                try camera.lockForConfiguration()
                camera.focusMode = .continuousAutoFocus
                camera.unlockForConfiguration()
            }
        }
    }
    
    func configureDeviceInputs() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }

        if let frontCamera = self.frontCamera {
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)

            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                self.currentCameraPosition = .front
            } else if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)

                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
                    self.currentCameraPosition = .rear
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
            } else {
                throw CameraControllerError.noCamerasAvailable
            }
        }
    }

    func configureVideoDataOutput() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            
            let videoQueue = DispatchQueue(label: "videoQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue: videoQueue)
        } else {
            throw CameraControllerError.invalidOperation
        }
        
        // Set the desired lower resolution
        let desiredWidth = 640
        let desiredHeight = 480
        
        // Find and set the active format for the desired lower resolution
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            for format in videoDevice.formats {
                let formatDescription = format.formatDescription
                let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
                if dimensions.width <= desiredWidth && dimensions.height <= desiredHeight {
                    do {
                        try videoDevice.lockForConfiguration()
                        videoDevice.activeFormat = format
                        videoDevice.unlockForConfiguration()
                        break
                    } catch {
                        throw CameraControllerError.invalidOperation
                    }
                }
            }
        }
    }

    func configurePhotoOutput() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }

        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)

        if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
        captureSession.startRunning()
    }
    
    
    func displayPreview(on view: UIView) throws {
        
        
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }

  
    private func removePreviewLayer() {
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
      
        self.photoCaptureCompletionBlock = completion
    }
    
    static func getOptions() -> FaceDetectorOptions {
        // High-accuracy landmark detection and face classification
        let options = FaceDetectorOptions()
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.classificationMode = .all
        options.contourMode = .all
         return options
    }

}

extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        // Get the current video orientation
        let videoOrientation = connection.videoOrientation

       visionPhoto = VisionImage(buffer: sampleBuffer)
        visionPhoto?.orientation = UIImage.Orientation.fromAVCaptureVideoOrientation(videoOrientation)
        do {
            let faces = try faceDetector.results(in: visionPhoto!)
            if faces.count > 0 {
                for face in faces {
                    let bounds = face.frame
                    delegate?.faceDetected(true)
                }
            } else {
                delegate?.faceDetected(false)
            }
        } catch {
            print("Failed to detect faces: \(error)")
            delegate?.faceDetected(false)
        }

    }
    
    
}


extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            self.photoCaptureCompletionBlock?(nil, error)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData),
              let currentCameraPosition = currentCameraPosition,
              currentCameraPosition == .front else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
            return
        }
        
        // Apply horizontal flip transformation to the image
        if let cgImage = image.cgImage {
            let flippedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
            self.photoCaptureCompletionBlock?(flippedImage, nil)
        } else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}


extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}
