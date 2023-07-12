//
//  FaceDetection.swift
//  Valify
//
//  Created by Mac on 13/07/2023.
//
import AVFoundation
import CoreVideo
import MLKit
import UIKit

class FaceDetection {
    static func getOptions() -> FaceDetectorOptions {
        // High-accuracy landmark detection and face classification
        let options = FaceDetectorOptions()
        options.performanceMode = .accurate
        options.landmarkMode = .all
        options.classificationMode = .all
         return options
        // Real-time contour detection of multiple faces
        // options.contourMode = .all
    }
    static func createImage(image: UIImage ) -> VisionImage {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        return visionImage
    }
    
  
          
}
