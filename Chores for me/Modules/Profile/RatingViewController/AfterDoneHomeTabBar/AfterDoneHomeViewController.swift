//
//  AfterDoneHomeViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 22/07/21.
//

import UIKit
import Designable
import SideMenu

class AfterDoneHomeViewController: HomeBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationIcon: DesignableButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Hello Rohit Kaushal"
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "BookingsTableViewCell", bundle: nil), forCellReuseIdentifier: "BookingsTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        locationIcon.addSpaceBetweenImageAndTitle(spacing: 10.0)
        navigationController?.navigationBar.isHidden = false
        navigationItem.setHidesBackButton(true, animated: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isHidden = false

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        navigate(.jobStatus)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTableViewCell") as? BookingsTableViewCell else {
                    fatalError()
                }

                return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }



}


// MARK: - UITableViewDataSource

//extension HomeViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingsTableViewCell") as? BookingsTableViewCell else {
//            fatalError()
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
