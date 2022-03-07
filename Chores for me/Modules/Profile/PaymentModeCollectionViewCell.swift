//
//  PaymentModeCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 19/07/21.
//

import UIKit

class PaymentModeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var image: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func populateUI(sender: Images) {
        image.image = UIImage(named: sender.imageName)

    }

}
