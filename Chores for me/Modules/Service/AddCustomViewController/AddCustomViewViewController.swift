//
//  AddCustomViewViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 05/08/21.
//

import UIKit

protocol ViewControllerDelegateForDissmiss: class {
    func didTapPlusButton(controller: ServiceBaseViewController)
}

class AddCustomViewViewController: ServiceBaseViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: ViewControllerDelegateForDissmiss?


    //MARK: - Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topLabel: UILabel!


    //MARK: - Properties
    override var navigationController: BaseNavigationController? {
        return super.navigationController
    }
    var service: Service!
    var nameArray: [String] = []
    static var selectedServicesTitle: String?


    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesigns()
        self.applyFinishingTouchesToUIElements()
        topLabel.text = "Create" + service.title + "Job"
        topLabel.text = service.title
        AddCustomViewViewController.selectedServicesTitle = "\(topLabel.text ?? "") Job"
        nameArray.append("Lown Mowing")
        nameArray.append("Weed Removal")
        nameArray.append("Planting")
        nameArray.append("Gutter Service")
        nameArray.append("other")
        tabBarController?.tabBar.isHidden = true
    }


    //MARK: - Interface Builder Actions


    //MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCustomlTableViewCell") as! AddCustomlTableViewCell

        cell.addButton.addTarget(self, action: #selector(addButtonAction(_:)), for: .touchUpInside)

        return cell
    }
    
    //MARK: - Helpers
    private func applyDesigns() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "AddCustomlTableViewCell", bundle: nil), forCellReuseIdentifier: "AddCustomlTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func applyFinishingTouchesToUIElements() {
        let barButton = UIBarButtonItem(image: UIImage(named: "NEXT"), style: .done, target: self, action: #selector(rightButton(_:)))
        navigationItem.rightBarButtonItem = barButton

    }

    @objc func rightButton(_ Sender: UIBarButtonItem) {
        navigate(.uploadProfilePicture)
    }

    @objc func addButtonAction(_ sender: UIButton) {
//        navigate(.addCustomCategory)
        delegate?.didTapPlusButton(controller: self)
        self.dismiss(animated: true, completion: nil)

    }

}
