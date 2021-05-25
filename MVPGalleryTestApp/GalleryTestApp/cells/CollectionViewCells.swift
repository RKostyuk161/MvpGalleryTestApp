//
//  CollectionViewCells.swift
//  GalleryTestApp
//
//  Created by Roma on 08.04.2021.
//

import UIKit
import Kingfisher

class CollectionViewCells: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(url: String) {
        let url = (URL(string: "http://gallery.dev.webant.ru/media/" + url))
        collectionViewImage.kf.setImage(with: url)
        collectionViewImage.layer.cornerRadius = 10
        collectionViewImage.layer.borderWidth = 0.7
        collectionViewImage.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 4.5
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
    }
}
