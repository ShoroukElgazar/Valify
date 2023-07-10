//
//  ExampleViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit

class ExampleViewController: UIViewController {

    
    @IBOutlet weak var imageExample: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func openImageController(_ sender: Any) {
        CameraViewModel.open { (image,error) in
            guard let image = image else {
                print("error:", error)
                return
            }
            self.imageExample.image = image
        }
    }

}

