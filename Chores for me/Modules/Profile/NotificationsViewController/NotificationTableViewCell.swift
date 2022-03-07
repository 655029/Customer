//
//  NotificationTableViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 27/07/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var ratingAndCheckReasonButton: UIButton!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!


    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
       payButton.isHidden = true
       ratingAndCheckReasonButton.isHidden = true
    }

}
