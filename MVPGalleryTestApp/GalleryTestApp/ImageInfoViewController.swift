//
//  ImageInfoViewController.swift
//  GalleryTestApp
//
//  Created by Роман on 09.04.2021.
//

import UIKit

protocol ViewPresent {
    var fullImageEntity: UIImage? { get }
    var imageNameEntity: String? { get }
    var imageDescriptionEntity: String? { get }
}

class ImageInfoViewController: UIViewController {

    var presenter = FullImagePresenter()

    
    
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fullImage = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func spin() {
        if !loadingActivity.isHidden {
            loadingActivity.isHidden = true
            loadingActivity.startAnimating()
        } else {
            loadingActivity.isHidden = false
            loadingActivity.stopAnimating()
        }
    }
}

