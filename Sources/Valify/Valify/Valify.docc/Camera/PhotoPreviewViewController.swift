//
//  PhotoPreviewViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    var imageView : UIImage?

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    
    var onCompleted: ((UIImage?,Error?) -> Void)? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      
    }
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       override func viewDidLoad() {
           super.viewDidLoad()
           imagePreview.image = imageView
           // Configure the image view constraints or frame as desired
       }

    @IBAction func retakePhoto(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        guard let image = imageView else {return}

        onCompleted?(image, nil)
        self.navigationController?.popToRootViewController(animated: true)

    }
}
