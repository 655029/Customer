//
//  BookingsHistoryTableViewCell.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 16/09/21.
//

import UIKit
import Cosmos

class BookingsHistoryTableViewCell: UITableViewCell {


    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryname: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var selectedDay: UILabel!
    @IBOutlet weak var selectedPrice: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var starRating: CosmosView!
    @IBOutlet weak var copyIconButton: UIButton!
    @IBOutlet weak var dateCreatedAt: UILabel!


    //MARK: - Properties
    var arrSubCatgeory = [JobsSubcategoryId]()


    //MARK: - Awake From Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        starRating.settings.updateOnTouch = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BookingRequestServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookingRequestServiceCollectionViewCell")
        cancelLabel.isHidden = true
        checkButton.isHidden = true
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

    }

}


// MARK: - UICollectionViewDelegate
extension BookingsHistoryTableViewCell: UICollectionViewDelegate {

}


// MARK: - UICollectionViewDataSource
extension BookingsHistoryTableViewCell: UICollectionViewDataSource {
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

        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension BookingsHistoryTableViewCell: UICollectionViewDelegateFlowLayout {
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

