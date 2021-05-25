//
//  Presenter.swift
//  GalleryTestApp
//
//  Created by Роман on 24.05.2021.
//

import Foundation
import UIKit
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


class GalleryPresenter {
    
    
    var gallery: MainGalleryViewController!
    var currentCollection: CollectionType!
    
    var imageArray = [OutImageEntity]()
    var disposeBag = DisposeBag()
    
    var numberOfPage = 1
    var countOfPages = 1
    
    var isLoading = false
    var isLoadFail = false
    
    var baseUrl = "http://gallery.dev.webant.ru/api/"
    var endPoint = "photos"
    
    
    typealias dataCallBack = (_ getInfo: ImagePaginationEntity?, _ message: String) -> Void
    
    
    
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
                    callback(nil, error.localizedDescription)
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
                        if self.gallery.collectionViewRefreshControl.isRefreshing {
                            self.imageArray.removeAll()
                            self.gallery.collectionViewRefreshControl.endRefreshing()
                        }
                        self.gallery.imageCollectionView.backgroundView = nil
                        self.countOfPages = pages
                        self.imageArray.append(contentsOf: images)
                        self.numberOfPage += 1
                        self.isLoading = false
                        self.isLoadFail = false
                        self.gallery.imageCollectionView.reloadData()
                        
                    case "no connection":
                        self?.isLoading = false
                        self?.gallery.imageCollectionView.backgroundView = UINib(nibName: "NoInternet", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
                        if self?.gallery.collectionViewRefreshControl.isRefreshing != nil {
                            self?.imageArray.removeAll()
                            self?.gallery.collectionViewRefreshControl.endRefreshing()
                            self?.isLoadFail = true
                            self?.gallery.imageCollectionView.reloadData()
                        }
                        
                    default:
                        self?.isLoading = false
                        self?.gallery.imageCollectionView.isHidden = true
                        self!.gallery.badRequest(message: message)
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
            let cell = gallery.imageCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCells", for: indexPath) as! CollectionViewCells
            let image = imageArray[indexPath.item]
            cell.setupCell(url: (image.image?.name)!)
            return cell
        case 1:
            let cell = gallery.imageCollectionView.dequeueReusableCell(withReuseIdentifier: "BottomLoadCollectionViewCell", for: indexPath) as! BottomLoadCollectionViewCell
            cell.bottomLoading(isNeedLoading: self.numberOfPage <= self.countOfPages)
            return cell
        default:
            fatalError()
        }
    }

    
    
    func setupSizeForCell(indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            if UIDevice.current.orientation.isLandscape {
                return CGSize(width: gallery.imageCollectionView.frame.width / 4-15, height: gallery.imageCollectionView.frame.width / 4-15)
            } else {
                return CGSize(width: gallery.imageCollectionView.frame.width / 2-15, height: gallery.imageCollectionView.frame.width / 2-15)
            }
        case 1:
            return CGSize(width: gallery.imageCollectionView.frame.width, height: 50)
        default:
            fatalError()
        }
    }
    
    func pushFullImageController(indexPath: IndexPath)  {
        if self.isLoading {
            return
        }
        self.isLoading = true
        guard let id = self.imageArray[indexPath.item].id else { return }
        
        
        let vc = UIStoryboard(name: "ImageInfoStoryBoard", bundle: nil).instantiateViewController(identifier: "ImageInfoViewController") as? ImageInfoViewController
        guard let viewController = vc else { return }
        
        self.gallery.navigationController?.pushViewController(viewController, animated: true)
        self.gallery.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
    
    func createAlertForBadRequest(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (tryRequest) -> Void in
            self.gallery.imageCollectionView.isHidden = false
            self.numberOfPage = 1
            if !self.isLoading {
                self.getGalleryRequest()
            }
        }
        alert.addAction(ok)
        gallery.present(alert, animated: true, completion: nil)
    }
}

