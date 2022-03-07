//
//  SecondCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 29/07/21.
//

import UIKit

class SecondCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainView: UIView!


    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.dateLabel.textColor = UIColor.black
            }
            else
            {
                self.layer.borderWidth = 0.0
                self.layer.cornerRadius = 0.0
                self.dateLabel.textColor = UIColor.white
                mainView.backgroundColor = UIColor.init(red: 43, green: 48, blue: 56)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    

    
}
