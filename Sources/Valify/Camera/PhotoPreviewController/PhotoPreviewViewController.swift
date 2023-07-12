//
//  PhotoPreviewViewController.swift
//  CameraDemo
//
//  Created by Mac on 09/07/2023.
//

import UIKit

public class PhotoPreviewViewController: UIViewController {
    
    var previewView : UIView!
    var boxView:UIView!
    var imageView =  UIImageView(
        frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,
        height: UIScreen.main.bounds.size.height))
    var onCompleted: ((UIImage?,Error?) -> Void)? = nil
    var onDismiss: (() -> Void) = {}
    
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public  override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    public func setupView() {
       
        setupPreviewView()
        setupBoxView()
        setupButtons()
        setupImage()
    }
    
    public func setupPreviewView() {
        previewView = UIView(frame:
        CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,
                height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
    }
    
    public func setupBoxView() {
        boxView = UIView(frame: self.view.frame)
        view.addSubview(boxView)
    }
    
    public func setupImage() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageView.image
        boxView.addSubview(imageView)
    }
    
    public func setupButtons() {
        // Create two buttons
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 20
        
        let doneButton = UIButton(title: "done", frame:  CGRect(x: (self.view.bounds.width - (buttonWidth * 2 + buttonSpacing)) / 2, y: self.view.bounds.height - 100, width: buttonWidth, height: buttonHeight),backgroundColor: UIColor.red)
        doneButton.addTarget(self, action: #selector(onClickDone), for: .touchUpInside)
        
        let retakeButton = UIButton(title: "Retake", frame: CGRect(x: doneButton.frame.origin.x + buttonWidth + buttonSpacing, y: self.view.bounds.height - 100, width: buttonWidth, height: buttonHeight),backgroundColor: UIColor.blue)
        retakeButton.addTarget(self, action: #selector(onClickRetake), for: .touchUpInside)
        
        
        view.addSubview(doneButton)
        view.addSubview(retakeButton)
    }
    
    @objc func onClickDone(sender: UIButton){
        onCompleted?(imageView.image, nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func onClickRetake(sender: UIButton){
        onDismiss()
        self.navigationController?.popViewController(animated: true)
    }
    
}

