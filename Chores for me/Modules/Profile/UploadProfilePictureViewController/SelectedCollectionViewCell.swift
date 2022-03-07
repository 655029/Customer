//
//  SelectedCollectionViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 02/09/21.
//

import UIKit

class SelectedCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var selectedCategoryImage: UIImageView!
    @IBOutlet weak var selecetdCategoryName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populateUI(_ sender: SelectedData) {
        selectedCategoryImage.image = UIImage(named: sender.image)
        selecetdCategoryName.text = sender.name

    }

}
