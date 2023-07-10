//
//  Button+Layout.swift
//  Valify
//
//  Created by Mac on 10/07/2023.
//

import UIKit

extension UIButton {
    convenience init(title: String, frame: CGRect , buttonWidth: CGFloat = 150, buttonHeight: CGFloat = 40, buttonSpacing: CGFloat = 20, backgroundColor: UIColor) {
        self.init(type: .system)
        
        self.frame = frame
        self.backgroundColor = backgroundColor
        self.layer.masksToBounds = true
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = buttonHeight / 2
    }
}
