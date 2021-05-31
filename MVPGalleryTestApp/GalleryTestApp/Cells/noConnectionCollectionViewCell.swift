//
//  noConnectionCollectionViewCell.swift
//  GalleryTestApp
//
//  Created by Роман on 20.04.2021.
//

import UIKit

class noConnectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var noInternetImage: UIImageView!
    
    @IBOutlet weak var firstNoInternetLabel: UILabel!
    @IBOutlet weak var secondNoInternetLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "NoInternet")
        noInternetImage.image = image
        firstNoInternetLabel.text = "Oh Shucks!"
        secondNoInternetLabel.numberOfLines = 2
        secondNoInternetLabel.text = "Slow or not internet connection. Please check your internet settings"
    }
}
