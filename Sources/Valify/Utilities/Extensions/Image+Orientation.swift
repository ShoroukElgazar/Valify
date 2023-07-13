//
//  Image+Orientation.swift
//  Valify
//
//  Created by Mac on 13/07/2023.
//

import AVFoundation
import UIKit

extension UIImage.Orientation {
    static func fromAVCaptureVideoOrientation(_ orientation: AVCaptureVideoOrientation) -> UIImage.Orientation {
        switch orientation {
        case .portrait:
            return .right
        case .portraitUpsideDown:
            return .left
        case .landscapeLeft:
            return .up
        case .landscapeRight:
            return .down
        default:
            return .right
        }
    }
}

