//
//  ImageInfoViewController.swift
//  GalleryTestApp
//
//  Created by Роман on 09.04.2021.
//

import UIKit


class ImageInfoViewController: UIViewController, DisplayView {

    var presenter: FullImageInfoPresenter!
    
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
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
}

