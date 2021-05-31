//
//  BottomLoadCollectionViewCell.swift
//  GalleryTestApp
//
//  Created by Роман on 30.04.2021.
//

import UIKit

class BottomLoadCollectionViewCell: UICollectionViewCell {
    
    var isNeedLoading = Bool()

    @IBOutlet weak var bottomActivityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bottomLoading(isNeedLoading: Bool) {
        if isNeedLoading {
            bottomActivityIndicator.startAnimating()
        } else {
            bottomActivityIndicator.stopAnimating()
        }
    }
}
