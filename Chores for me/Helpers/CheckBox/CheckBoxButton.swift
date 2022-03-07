//
//  CheckBoxButton.swift
//  Back2Life
//
//  Created by Bright on 23/07/21.
//

import Foundation
import UIKit

class CheckBoxButton: UIButton {

    // Images
    let checkedImage = UIImage(named: "check (1)")! as UIImage
    let uncheckedImage = UIImage(named: "circle.empty")! as UIImage

    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for:.normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBoxButton.buttonClick(sender:)), for: UIControl.Event.touchUpInside)
       // self.addTarget(self, action: #selector(CheckBoxButton.buttonClick(_:)), forControlEvents: UIControl.Event.TouchUpInside)
        self.isChecked = false
    }

  @objc  func buttonClick(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }

}
