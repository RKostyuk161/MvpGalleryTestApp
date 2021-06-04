//
//  ImageInfoViewController.swift
//  GalleryTestApp
//
//  Created by Роман on 09.04.2021.
//

import UIKit


class ImageInfoViewController: UIViewController, DisplayView, UIScrollViewDelegate {

    var presenter: FullImageInfoPresenter!
    
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageDescription: UILabel!
    @IBOutlet weak var fuillImageScrollView: UIScrollView!
    @IBOutlet weak var fullImageStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fuillImageScrollView.delegate = self
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.reloadInputViews()
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImageStackView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageName.isHidden = true
        imageDescription.isHidden = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(1, animated: true)
        self.imageName.isHidden = false
        self.imageDescription.isHidden = false
        self.reloadInputViews()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
}

