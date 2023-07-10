//
//  ViewController.swift
//  CameraDemo
//
//  Created by Mac on 08/07/2023.
//

import UIKit
import Photos

class ViewController: UIViewController {

    let cameraController = CameraController()
    @IBOutlet fileprivate var capturePreviewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  
}
