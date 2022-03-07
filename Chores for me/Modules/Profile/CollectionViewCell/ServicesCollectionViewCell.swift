//
//  ServicesCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/07/21.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak  var image: UIImageView!
    @IBOutlet weak  var serviceName: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!


    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()

    }


    //MARK: - Connvince
    func populateUI(_ sender: DataStruct) {
        image.image = UIImage(named: sender.imageName)
        serviceName.text = sender.labelName
    }

}
