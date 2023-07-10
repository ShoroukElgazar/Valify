//
//  ViewController.swift
//  CameraDemo
//
//  Created by Mac on 08/07/2023.
//

import UIKit
import Photos

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  
    @IBAction func open(_ sender: Any) {
        
        self.present(CameraViewController(), animated: true)
    }
}
