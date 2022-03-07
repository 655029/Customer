//
//  BookingsTableViewCell.swift
//  Chores for me
//
//  Created by Amalendu Kar on 23/04/21.
//

import UIKit
import Designable
import Cosmos

struct SelectedServiceNameOrImage {
    var name: String
    var image: String
}

class BookingsTableViewCell: UITableViewCell {


    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryname: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var selectedDay: UILabel!
    @IBOutlet weak var selectedPrice: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var ratingStarView: CosmosView!
    @IBOutlet weak var hireButton: UIButton!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var copyIcon: UIButton!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
     @IBOutlet weak var buttonStack: UIStackView!
    
    @IBOutlet weak var mintLabel: UILabel!
    
    // MARK: - Properties
    var servicesArray: [SelectedServiceNameOrImage] = []
    var arrSubCatgeory = [JobsSubcategoryId]()


    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingStarView.settings.updateOnTouch = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BookingRequestServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingRequestServiceCollectionViewCell")
        userName.isHidden = true
        userImage.isHidden = true
        ratingStarView.isHidden = true
        hireButton.layer.cornerRadius = 5.0
        hireButton.isHidden = true
        deleteButton.isHidden = true
        editButton.isHidden = true

        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
           }

        
    }

}


// MARK: - UICollectionViewDelegate
extension BookingsTableViewCell: UICollectionViewDelegate {
    
}


// MARK: - UICollectionViewDataSource
extension BookingsTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrSubCatgeory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookingRequestServiceCollectionViewCell", for: indexPath) as? BookingRequestServiceCollectionViewCell else {
            fatalError()
        }
        cell.selectedServiceName.text = arrSubCatgeory[indexPath.row].name
//        collectionView.reloadData()
        
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension BookingsTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}
