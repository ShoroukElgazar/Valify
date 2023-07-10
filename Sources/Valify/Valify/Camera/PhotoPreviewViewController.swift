//
//  PhotoPreviewViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    var previewView : UIView!
    var boxView:UIView!
    var imageView =  UIImageView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: UIScreen.main.bounds.size.width,
                                            height: UIScreen.main.bounds.size.height))

    var onCompleted: ((UIImage?,Error?) -> Void)? = nil
    var onDismiss: (() -> Void) = {}
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      
    }
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

       override func viewDidLoad() {
           super.viewDidLoad()
         setupView()
       }
   

    func setupView() {
        previewView = UIView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: UIScreen.main.bounds.size.width,
                                                height: UIScreen.main.bounds.size.height))
             previewView.contentMode = UIView.ContentMode.scaleAspectFit
             view.addSubview(previewView)

             //Add a view on top of the cameras' view
             boxView = UIView(frame: self.view.frame)


        // Create two buttons
            let buttonWidth: CGFloat = 150
            let buttonHeight: CGFloat = 40
            let buttonSpacing: CGFloat = 20

            let button1 = UIButton(type: .system)
            button1.frame = CGRect(x: (self.view.bounds.width - (buttonWidth * 2 + buttonSpacing)) / 2, y: self.view.bounds.height - 100, width: buttonWidth, height: buttonHeight)
            button1.backgroundColor = UIColor.red
            button1.layer.masksToBounds = true
            button1.setTitle("Done", for: .normal)
            button1.setTitleColor(UIColor.white, for: .normal)
            button1.layer.cornerRadius = buttonHeight / 2
            button1.addTarget(self, action: #selector(onClickButton1), for: .touchUpInside)

            let button2 = UIButton(type: .system)
            button2.frame = CGRect(x: button1.frame.origin.x + buttonWidth + buttonSpacing, y: self.view.bounds.height - 100, width: buttonWidth, height: buttonHeight)
            button2.backgroundColor = UIColor.blue
            button2.layer.masksToBounds = true
            button2.setTitle("Retake", for: .normal)
            button2.setTitleColor(UIColor.white, for: .normal)
            button2.layer.cornerRadius = buttonHeight / 2
            button2.addTarget(self, action: #selector(onClickButton2), for: .touchUpInside)

             view.addSubview(boxView)
             view.addSubview(button1)
             view.addSubview(button2)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image

        boxView.addSubview(imageView)

    }
    
    
    @objc func onClickButton1(sender: UIButton){
        onCompleted?(imageView.image, nil)
         
        self.navigationController?.popViewController(animated: true)
        
    }

    @objc func onClickButton2(sender: UIButton){
          onDismiss()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func retakePhoto(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//        guard let image = imageView else {return}
//
//        onCompleted?(image, nil)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
//        guard let image = imageView else {return}
//
//        onCompleted?(image, nil)
//        self.dismiss(animated: true, completion: nil)

//        self.navigationController?.popToRootViewController(animated: true)

    }
}
