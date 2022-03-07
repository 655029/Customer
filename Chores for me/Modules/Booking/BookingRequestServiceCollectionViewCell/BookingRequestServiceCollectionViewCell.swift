//
//  BookingRequestServiceCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit

class BookingRequestServiceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var selectedServiceName: UILabel!
    @IBOutlet weak var selectedServiceImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populateUI(_ sender: SelectedServiceNameOrImage) {
        selectedServiceImage.image = UIImage(named: sender.image)
        selectedServiceName.text = sender.name

    }

}
