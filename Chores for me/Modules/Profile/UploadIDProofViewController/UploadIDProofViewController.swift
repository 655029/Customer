//
//  UploadIDProofViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/04/21.
//

import UIKit

class UploadIDProofViewController: ServiceBaseViewController {

    // MARK: - Outlets

    // MARK: - Properties

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Upload your Document"
        stepLabel.text = "6/6"
    }

    // MARK: - Layout

    // MARK: - User Interaction

    @IBAction func submitButtonAction(_ sender: Any) {
        RootRouter().loadMainHomeStructure()
    }

    // MARK: - Additional Helpers

}
