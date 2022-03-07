//
//  ServiceCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/04/21.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var isSelectedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Additional Helper Functions

    func configure(with service: Service) {
        serviceImageView.image = service.image
        serviceTitleLabel.text = service.title
    }
    
}
