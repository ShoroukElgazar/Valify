//
//  CameraViewModel.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit


//class CameraViewModel {
//    var vc : CameraViewController = CameraViewController()
//    var onCompleted: ((UIImage) -> Void)? = nil
//
//    func open(onCompleted: @escaping  ((UIImage) -> Void)) {
//        vc.onCompleted = { [weak self] image in
////            print("gggggg",image)
////               self?.imageExample.image = image
//            self?.onCompleted?(image)
//        }
//
//        vc.navigationController?.pushViewController(vc, animated: true)
//    }
//
//}
//class CameraViewModel {
//    
//    static func open(onCompleted: @escaping (UIImage?, Error?) -> Void) {
//        let vc = CameraViewController()
//        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
//                  fatalError("Unable to access the root navigation controller")
//              }
//              
//        vc.onCompleted = { image, error in
//            onCompleted(image,error)
//        }
//        navigationController.pushViewController(vc, animated: true)
//    }
//}
