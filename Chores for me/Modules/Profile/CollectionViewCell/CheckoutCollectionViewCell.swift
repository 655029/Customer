//
//  CheckoutCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 17/07/21.
//

import UIKit

class CheckoutCollectionViewCell: UICollectionViewCell {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var imageName: UILabel!
    @IBOutlet weak private var selectedImageView: UIImageView!


    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
//        let rendring = selectedImageView.image?.withRenderingMode(.alwaysTemplate)
//        selectedImageView.image = rendring
//        selectedImageView.backgroundColor = .white
//        selectedImageView.tintColor = .white
//        selectedImageView.layer.masksToBounds = true
//        selectedImageView.layer.borderWidth = 2.0
//        selectedImageView.layer.borderColor = UIColor.red.cgColor
//        selectedImageView.layer.cornerRadius = selectedImageView.bounds.width/2

    }


    //MARK: - Helpers
    func populateUI(sender: Property) {
        image.image = UIImage(named: sender.image) 
        imageName.text = sender.nameOfImage
        selectedImageView.image = sender.isSelected ? UIImage(named: "selectedImage") : UIImage(named: "deselectedButton")
    }

}
