//
//  Presenter.swift
//  GalleryTestApp
//
//  Created by Роман on 24.05.2021.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

enum CollectionType: Int {
    case new = 0
    case popular = 1
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .new
        case 1:
            self = .popular
        default:
            return nil
        }
    }
}

protocol DisplayView: class {
    func displayImage(image: UIImage)
    func display(name: String)
    func display(description: String)
}




class GalleryPresenter {
    
    weak var view: MainGalleryViewController!
    let router: Router
    let currentCollection: CollectionType
    
    var imageArray = [OutImageEntity]()
    var disposeBag = DisposeBag()
    var modelToRoute = OutImageEntity()
    var imageToRoute = UIImage()
    
    var numberOfPage = 1
    var countOfPages = 1
    
    var isLoading = false
    var isLoadFail = false
    
    var fullImageUrl = "http://gallery.dev.webant.ru/media/"
    let baseUrl = "http://gallery.dev.webant.ru/api/"
    let endPoint = "photos"
    
    init(view: MainGalleryViewController, router: Router, currentCollection: CollectionType) {
        self.view = view
        self.router = router
        self.currentCollection = currentCollection
        
    }
    
    typealias dataCallBack = (_ getInfo: ImagePaginationEntity?, _ message: String) -> Void
    typealias imageCallBack = (_ getInfo: UIImage?, _ message: String) -> Void
    
    
    func galleryDataRequest(numberOfPage: Int, currentCollection: CollectionType, callback: @escaping dataCallBack) {
        
        
        let parametrs: [String : Any]
        
        switch currentCollection {
        case .new:
            parametrs = ["page" : numberOfPage, "limit": 10, "new" : true]
        
        case .popular:
            parametrs = ["page" : numberOfPage, "limit": 10, "new" : false, "popular" : true]

        }
        RxAlamofire.data(.get, baseUrl+endPoint, parameters: parametrs)
            .debug()
            .subscribe { [weak self] response in
                
                guard self != nil else { return }
                do {
                    let data = try JSONDecoder().decode(ImagePaginationEntity.self, from: response)
                    callback(data, "200")
                } catch  let error {
                    callback(nil, String(describing: error.localizedDescription))
                }
                
            } onError: { (error) in
                
                callback(nil, "no connection")
            }
            
            .disposed(by: disposeBag)
    }
    
    func getGalleryRequest() {
        if self.numberOfPage <= countOfPages {
            if !self.isLoading {
                self.isLoading = true
                galleryDataRequest(numberOfPage: numberOfPage, currentCollection: currentCollection) {
                    [weak self] (getInfo, message) in
                    
                    switch message {
                    
                    case "200":
                        guard let self = self else { return }
                        guard let allGettingInfo = getInfo,
                              let images = allGettingInfo.data,
                              let pages = allGettingInfo.countOfPages else {return }
                        if self.view.collectionViewRefreshControl.isRefreshing {
                            self.imageArray.removeAll()
                            self.view.collectionViewRefreshControl.endRefreshing()
                        }
                        self.view.imageCollectionView.backgroundView = nil
                        self.countOfPages = pages
                        self.imageArray.append(contentsOf: images)
                        self.numberOfPage += 1
                        self.isLoading = false
                        self.isLoadFail = false
                        self.view.imageCollectionView.reloadData()
                        
                    case "no connection":
                        self?.isLoading = false
                        self?.view.imageCollectionView.backgroundView = UINib(nibName: "NoInternet", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
                        if self?.view.collectionViewRefreshControl.isRefreshing != nil {
                            self?.imageArray.removeAll()
                            self?.view.collectionViewRefreshControl.endRefreshing()
                            self?.isLoadFail = true
                            self?.view.imageCollectionView.reloadData()
                        }
                        
                    default:
                        self?.isLoading = false
                        self?.view.imageCollectionView.isHidden = true
                        self!.view.badRequest(message: message)
                    }
                }
            }
        }
    }
    
    func setupNumberOfSellsPerSection(section: Int) -> Int {
        switch section {
        case 0:
            return imageArray.count
        case 1:
            if isLoadFail {
                return 0
            }
            if self.numberOfPage < self.countOfPages {
                return 1
            } else {
                return 0
            }
        default:
            fatalError()
        }
    }
    
    func createCell(indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = view.imageCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCells", for: indexPath) as! CollectionViewCells
            let image = imageArray[indexPath.item]
            cell.setupCell(url: (image.image?.name)!)
            return cell
        case 1:
            let cell = view.imageCollectionView.dequeueReusableCell(withReuseIdentifier: "BottomLoadCollectionViewCell", for: indexPath) as! BottomLoadCollectionViewCell
            cell.bottomLoading(isNeedLoading: self.numberOfPage <= self.countOfPages)
            return cell
        default:
            fatalError()
        }
    }

    
    
    func setupSizeForCell(indexPath: IndexPath, numberInRow: Int) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: view.imageCollectionView.frame.width / CGFloat(numberInRow)-15, height: view.imageCollectionView.frame.width / CGFloat(numberInRow)-15)
            
        case 1:
            return CGSize(width: view.imageCollectionView.frame.width, height: 50)
        default:
            fatalError()
        }
    }
    
    func pushFullImageController(indexPath: IndexPath)  {
        
        let model = self.imageArray[indexPath.item]
            getFullImageRequest(model: model) {
                [weak self] (getInfo, message) in
                switch message {
                case "200":
                    guard let self = self else { return }
                    guard let allGettingInfo = getInfo else { return }
                    let image = allGettingInfo
                    self.modelToRoute = model
                    self.imageToRoute = image
                case "no connection":
                    self?.createAlertForBadRequest(message: message, isFullImageRequest: true)
                default:
                    self?.createAlertForBadRequest(message: message, isFullImageRequest: true)
                }
            
        }
    }

    func getFullImageRequest(model: OutImageEntity, callback: @escaping imageCallBack) {
        
        guard let imageName = model.image?.name else { return }
        let imageRequestUrl = self.fullImageUrl + String(describing: imageName)
    
        RxAlamofire.data(.get, imageRequestUrl)
            .debug()
            .do(afterCompleted: {
                self.router.openImageInfoView(model: self.modelToRoute, image: self.imageToRoute)
            },onSubscribe: { [weak self] in
                self?.view.spin(isNeedToSpin: true)
            }, onDispose: { [ weak self ] in
                self?.view.spin(isNeedToSpin: false)

            })
            .subscribe { response in
                guard let data = UIImage(data: response) else {
                    callback(nil, "Ошибка сервера")
                    return
                }
                callback(data, "200")
            } onError: { (error) in
                callback(nil, "no connection")
            }
            .disposed(by: disposeBag)
    }
    
    func getNewPaginationRequest(indexPath: IndexPath)  {
        if indexPath.item == imageArray.count - 1 {
            self.getGalleryRequest()
        }
    }
    
    func makeRefresh() {
        self.numberOfPage = 1
        if !isLoading {
            self.getGalleryRequest()
        }
    }
    
    func createAlertForBadRequest(message: String, isFullImageRequest: Bool?) {
        if let isFullImage = isFullImageRequest {
            if isFullImage {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(cancel)
                view.present(alert, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            let tryRequest = UIAlertAction(title: "Повторить запрос", style: UIAlertAction.Style.default) { (tryRequest) -> Void in
                self.view.imageCollectionView.isHidden = false
                self.numberOfPage = 1
                if !self.isLoading {
                    self.getGalleryRequest()
                }
            }
            alert.addAction(tryRequest)
            view.present(alert, animated: true, completion: nil)
        }
    }
}

