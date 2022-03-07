//
//  DateandTimeCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 15/07/21.
//

import UIKit

class DateandTimeCollectionViewCell: UICollectionViewCell {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mainView: UIView!

    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.label.textColor = UIColor.black
            }
            else
            {
                self.layer.borderWidth = 0.0
                self.layer.cornerRadius = 0.0
                self.label.textColor = UIColor.white
                mainView.backgroundColor = UIColor.init(red: 43, green: 48, blue: 56)
            }
        }
    }


    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
