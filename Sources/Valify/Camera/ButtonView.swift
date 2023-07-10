//
//  ButtonView.swift
//  Valify
//
//  Created by Mac on 10/07/2023.
//

import UIKit
import Foundation

class ButtonView: UIView{
    let title: String
    var buttonFrame: CGRect
    let buttonWidth: CGFloat
    let buttonHeight: CGFloat
    let buttonSpacing: CGFloat
    let button = UIButton(type: .system)
    var view: UIView
    var onClickButton: (() -> Void) = {}
    
    init(title: String,buttonFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 40),buttonWidth: CGFloat = 150 , buttonHeight: CGFloat = 40, buttonSpacing: CGFloat = 20 , view: UIView, onClickButton: @escaping () -> Void) {
        self.title = title
        self.buttonFrame = buttonFrame
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        self.buttonSpacing = buttonSpacing
        self.view = view
        self.onClickButton = onClickButton
        // Call the designated initializer of the superclass
              super.init(frame: CGRect.zero)
              
              createButton() // Create the button after calling super.init
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButton() {
        button.frame = buttonFrame
        button.backgroundColor = UIColor.red
        button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = buttonHeight / 2
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    @objc func onClick(sender: UIButton){
        onClickButton()
    }
    
}
