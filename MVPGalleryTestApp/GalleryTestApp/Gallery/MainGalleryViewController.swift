import UIKit

class MainGalleryViewController: UIViewController {
    
    var galleryPresenter: MainGalleryPresenter!
    var setNumberOfCellsInRow: Int {
        UIDevice.current.orientation.isLandscape ? 4 : 2
    }
    
    let collectionViewRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    } ()
    
    @IBOutlet weak var fullImageLoading: UIActivityIndicatorView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var fullImageLoadingBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewIfNeed()
        self.prepeareForLoad()
    }
    
    func setupViewIfNeed() {
        guard self.galleryPresenter == nil,
              let currentCollection = self.tabBarController?.selectedIndex else { return }
        GalleryConfigurator().config(view: self, currentCollection: currentCollection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.reloadInputViews()
        self.imageCollectionView.reloadData()
    }
    
    func prepeareForLoad() {
        galleryPresenter.getGalleryRequest()
        self.imageCollectionView.refreshControl = collectionViewRefreshControl
        self.imageCollectionView.register(UINib(nibName: "noConnectionCollectionViewCell",
                                                bundle: nil),
                                          forCellWithReuseIdentifier: "noConnectionCollectionViewCell")
        self.imageCollectionView.register(UINib(nibName: "BottomLoadCollectionViewCell",
                                                bundle: nil), forCellWithReuseIdentifier: "BottomLoadCollectionViewCell")
        self.imageCollectionView.register(UINib(nibName: "CollectionViewCells",
                                                bundle: nil),
                                          forCellWithReuseIdentifier: "CollectionViewCells")
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
        self.fullImageLoading.isHidden = true
        self.fullImageLoadingBackgroundView.isHidden = true
        self.fullImageLoadingBackgroundView.layer.borderWidth = 0.5
        self.fullImageLoadingBackgroundView.layer.cornerRadius = 10
        self.fullImageLoadingBackgroundView.layer.masksToBounds = false
        self.fullImageLoadingBackgroundView.layer.shadowColor = UIColor.black.cgColor
        self.fullImageLoadingBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.fullImageLoadingBackgroundView.layer.shadowRadius = 6
        self.fullImageLoadingBackgroundView.layer.shadowOpacity = 1
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        self.imageCollectionView.isHidden = false
        galleryPresenter.makeRefresh()
    }
    
    func badRequest(message: String) {
        galleryPresenter.createAlertForBadRequest(message: message, isFullImageRequest: nil)
    }
    
    func spin(isNeedToSpin: Bool) {
        if isNeedToSpin {
            fullImageLoadingBackgroundView.isHidden = false
            fullImageLoading.isHidden = false
            fullImageLoading.startAnimating()
        } else {
            fullImageLoadingBackgroundView.isHidden = true
            fullImageLoading.isHidden = true
            fullImageLoading.stopAnimating()
        }
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
        galleryPresenter.setupSizeForCell(indexPath: indexPath, numberInRow: setNumberOfCellsInRow)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            self.setNumberOfCellsInRow = 4
//        } else {
//            self.setNumberOfCellsInRow = 2
//        }
//    }
}
