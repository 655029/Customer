//
//  CancelRequestViewController.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit

class CancelRequestViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cancel Request"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CancelRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "CancelRequestTableViewCell")
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    // MARK: - Additional Helpers
    
}

// MARK: - UITableViewDelegate

extension CancelRequestViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension CancelRequestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CancelRequestTableViewCell") as? CancelRequestTableViewCell else {
            fatalError()
        }
        return cell
    }
}
