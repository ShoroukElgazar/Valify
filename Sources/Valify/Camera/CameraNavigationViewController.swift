//
//  CameraNavigationViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit

public class CameraNavigationViewController: UINavigationController {
//    public var onCompleted: ((UIImage?, Error?) -> Void)?
    public var cameraDelegate: CameraHandler?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([CameraViewController()], animated: true)
    }

    public override func popViewController(animated: Bool) -> UIViewController? {
        guard let cameraViewController = viewControllers.first as? CameraViewController else {
            return nil
        }

        cameraViewController.onCompleted = { [weak self] image, error in
            if let error = error {
                   self?.cameraDelegate?.didFinishWithErrors(error: error)
               } else if let image = image {
                   self?.cameraDelegate?.didFinishSucceded(image: image)
               }
        }
//        onCompleted?(cameraViewController.capturedImage, cameraViewController.capturedError)

        return super.popViewController(animated: animated)
    }
}
public protocol CameraHandler {
    func didFinishSucceded(image: UIImage)
    func didFinishWithErrors(error: Error)
}
