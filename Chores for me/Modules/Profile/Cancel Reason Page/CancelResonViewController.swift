//
//  CancelResonViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 04/10/21.
//

import UIKit

class CancelResonViewController: UIViewController {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var cancelReasonLabel: UILabel!


    //MARK: - Properties
    var dicData: [NotificationData] = []


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        cancelReasonLabel.text = UserStoreSingleton.shared.cancelReason
    }

}
