//
//  CameraNavigationViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit

public class CameraNavigationViewController: UINavigationController {
    public var onCompleted: ((UIImage?, Error?) -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([CameraViewController()], animated: true)
        navigationItem.hidesBackButton = true

    }

    public override func popViewController(animated: Bool) -> UIViewController? {
        guard let cameraViewController = viewControllers.first as? CameraViewController else {
            return nil
        }

        onCompleted?(cameraViewController.capturedImage, cameraViewController.capturedError)

        return super.popViewController(animated: animated)
    }
}

