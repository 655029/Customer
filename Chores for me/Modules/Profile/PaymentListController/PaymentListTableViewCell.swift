//
//  PaymentListTableViewCell.swift
//  Chores for me
//
//  Created by Ios Mac on 20/11/21.
//

import UIKit

class PaymentListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cardHoldername: UILabel!
    
    @IBOutlet weak var cardNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
