//
//  MainGalleryViewController.swift
//  GalleryTestApp
//
//  Created by Роман on 12.04.2021.
//

import UIKit

class MainGalleryViewController: UIViewController {
    
    var galleryPresenter: GalleryPresenter!
    
    let collectionViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    } ()
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentCollection = self.tabBarController?.selectedIndex else { return }
        
        let config = GalleryConfigurator()
        config.config(view: self, currentCollection: currentCollection)
        
        prepeareForLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func prepeareForLoad() {
        galleryPresenter.getGalleryRequest()
        self.imageCollectionView.refreshControl = collectionViewRefreshControl
        self.imageCollectionView.register(UINib(nibName: "noConnectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "noConnectionCollectionViewCell")
        self.imageCollectionView.register(UINib(nibName: "BottomLoadCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BottomLoadCollectionViewCell")
        self.imageCollectionView.register(UINib(nibName: "CollectionViewCells", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCells")
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
        galleryPresenter.view = self
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.imageCollectionView.isHidden = false
        galleryPresenter.makeRefresh()
    }
    
    func badRequest(message: String) {
        galleryPresenter.createAlertForBadRequest(message: message)
    }
}


extension MainGalleryViewController: UICollectionViewDataSource,
                                     UICollectionViewDelegate,
                                     UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        galleryPresenter.setupNumberOfSellsPerSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        galleryPresenter.getNewPaginationRequest(indexPath: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        galleryPresenter.createCell(indexPath: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galleryPresenter.pushFullImageController(indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        galleryPresenter.setupSizeForCell(indexPath: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}
