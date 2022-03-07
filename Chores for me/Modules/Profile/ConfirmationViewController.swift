//
//  ConfirmationViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/07/21.
//

import UIKit

protocol DissmissConfirmationViewController: class {
    func didTapAgreeButton(controller: ConfirmationViewController)
}

class ConfirmationViewController: UIViewController {

    weak var delegate: DissmissConfirmationViewController?
    var ssImage = UIImage()


    @IBOutlet weak var backgroundImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
     //   navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }

    override func viewDidLayoutSubviews() {
        backgroundImage.image = ssImage
    }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }

    //MARK: - Additional Helpers
   
    lazy var blurredView: UIView = {
            // 1. create container view
            let containerView = UIView()
            // 2. create custom blur view
            let blurEffect = UIBlurEffect(style: .light)
            let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
            customBlurEffectView.frame = self.view.bounds
            // 3. create semi-transparent black view
            let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            dimmedView.frame = self.view.bounds

            // 4. add both as subviews
            containerView.addSubview(customBlurEffectView)
            containerView.addSubview(dimmedView)
            return containerView
        }()

    func setupView() {
            // 6. add blur view and send it to back
            view.addSubview(blurredView)
            view.sendSubviewToBack(blurredView)
        }

    //MARK: - Interface Builder Actions
    @IBAction func agreeButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.navigate(.checkOut)
            //self.dismiss(animated: true, completion: nil)
        }
        //delegate?.didTapAgreeButton(controller: self)
    }

    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func okayButtonAction(_ sender: UIButton) {
        RootRouter().loadMainHomeStructure()
        self.dismiss(animated: true, completion: nil)

    }
}
