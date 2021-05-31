//
//  ImageInfoViewController.swift
//  GalleryTestApp
//
//  Created by Роман on 09.04.2021.
//

import UIKit


class ImageInfoViewController: UIViewController, DisplayView {

    var presenter: FullImageInfoPresenter!
    
    
    @IBOutlet weak var noInternetStackView: UIStackView!
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.takeImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func displayImage(image: UIImage) {
        fullImage.image = image
    }
    
    func display(name: String) {
        imageName.text = name
    }
    
    func display(description: String) {
        imageDescription.text = description
    }
    
    func display(loadActivity: Bool) {
        spin(isNeedToSpin: loadActivity)
    }
    
    func spin(isNeedToSpin: Bool) {
        
        if isNeedToSpin {
            fullImage.isHidden = true
            imageName.isHidden = true
            imageDescription.isHidden = true
            loadingActivity.isHidden = false
            loadingActivity.startAnimating()
        } else {
            fullImage.isHidden = false
            imageName.isHidden = false
            imageDescription.isHidden = false
            loadingActivity.isHidden = true
            loadingActivity.stopAnimating()
        }
    }
}

