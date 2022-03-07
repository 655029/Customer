//
//  YardWorkViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 14/07/21.
//

import UIKit

class YardWorkViewController: UIViewController {


    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var mainTopView: UIView!
    @IBOutlet weak private var uploadImageButton: UIButton!
    @IBOutlet weak private var uploadedImage: UIImageView!


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyFinishingTouchesToUIElements()
    }


    //MARK: - Interface Builder Actions
    @IBAction func uploadImageButtonAction(_ sender: UIButton) {
        
    }


    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {

    }

}
