//
//  ProviderListTableViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 15/07/21.
//

import UIKit
import Cosmos

class ProviderListTableViewCell: UITableViewCell {


    //MARK: - Properties
     var selectedIndex: Int = 0


    //MARK: - Interface Builder Outlets
    @IBOutlet  weak var productImage: UIImageView!
    @IBOutlet  weak var productNameLabel: UILabel!
    @IBOutlet  weak var productLocationLabel: UILabel!
    @IBOutlet  weak var viewProfileButton: UIButton!
    @IBOutlet  weak var firstButton: UIButton!
    @IBOutlet  weak var secondButton: UIButton!
    @IBOutlet  weak var thirdButton: UIButton!
    @IBOutlet  weak var fourthButton: UIButton!
    @IBOutlet  weak var fifthButton: UIButton!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var starRating: CosmosView!
    

    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.layer.cornerRadius = 4.0
        viewProfileButton.layer.cornerRadius = 4.0
        myView.layer.cornerRadius = 4.0
        starRating.settings.updateOnTouch = false

    }

    
    //MARK: - Interface Builder Actions
    @IBAction func firstButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedIndex = firstButton.tag
        self.buttonRating()
    }


    @IBAction func secondButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedIndex = secondButton.tag
        self.buttonRating()
    }


    @IBAction func thirdButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedIndex = thirdButton.tag
        self.buttonRating()
    }


    @IBAction func fourthButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedIndex = fourthButton.tag
        self.buttonRating()
    }


    @IBAction func fifthButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        selectedIndex = fifthButton.tag
        self.buttonRating()
    }

    @IBAction func viewProfileButtonAction(_ sender: UIButton) {
        
    }


    //MARK: - PopulateUI
    func populateUI(sender: Provider) {
        productNameLabel.text = sender.name
        productLocationLabel.text = sender.address
    }

    func SleectedIndexValue() -> Int{
        return selectedIndex
    }


    //MARK: - Helpers
    func buttonRating() {
        let buttons = [firstButton, secondButton, thirdButton, fourthButton, fifthButton]

        for(_, button) in buttons.enumerated() {
            if selectedIndex >= button?.tag ?? 0 {
                button?.isSelected = true
                let image = UIImage(named: "selectedStar")?.withRenderingMode(.alwaysTemplate)
                button?.setImage(image, for: .selected)
                button?.imageView?.tintColor = .blue
            }

            else {
                button?.isSelected = false
            }
        }
    }

    private func didTouchCosmos(_ cosmos: Double) {
        
    }

}
