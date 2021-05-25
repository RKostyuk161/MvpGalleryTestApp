//
//  FullImagePresenter.swift
//  GalleryTestApp
//
//  Created by Роман on 25.05.2021.
//

import Foundation
import UIKit
import Alamofire
import RxSwift
import RxAlamofire

class FullImagePresenter {
    
    var fullImage: ImageInfoViewController!
    
    var id: Int?
    
    var disposeBag = DisposeBag()
    
    var numberOfPage = 1
    var countOfPages = 1
    
    var isLoading = false
    var isLoadFail = false
    
    typealias imageCallBack = (_ getInfo: OutImageEntity?, _ message: String) -> Void
    
    func getFullImageRequest(id: Int, indexPath: IndexPath, callback: @escaping imageCallBack)  {

        let imageRequestUrl = "http://gallery.dev.webant.ru/api/photos/\(id)"
        
    
        RxAlamofire.data(.get, imageRequestUrl)
            .debug()
            .do(onSubscribe: {

                self.fullImage.spin()
            }, onDispose: {
                
                self.fullImage.spin()
            })
            .subscribe { [weak self] response in
                guard self != nil else {
                    print("pizdec")
                    return
                }
                print("my response is \(response)")
                do {
                    let data = try JSONDecoder().decode(OutImageEntity.self, from: response)
                    callback(data, "200")
                    print("my data is \(data)")
                    
                } catch  let error {
                    callback(nil, error.localizedDescription)
                }
                
            } onError: { (error) in
                print(error)
                
                callback(nil, "no connection")
                
            }
            .disposed(by: disposeBag)
    }
    func takeImage(indexPath: IndexPath)  {
        guard let currentId = id else { return }
        getFullImageRequest(id: currentId, indexPath: indexPath) {
            [weak self] (getInfo, message) in
            switch message {
            
            case "200":
                
                guard let self = self else { return }
                guard let allGettingInfo = getInfo,
                      let imageName = allGettingInfo.name,
                      let imageDescription = allGettingInfo.description  else { return }
                
                self.isLoading = false
                self.isLoadFail = false
                
            case "no connection":
                return
//                self?.isLoading = false
//                self?.gallery.imageCollectionView.backgroundView = UINib(nibName: "NoInternet", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
//                if self?.gallery.collectionViewRefreshControl.isRefreshing != nil {
//                    self?.imageArray.removeAll()
//                    self?.gallery.collectionViewRefreshControl.endRefreshing()
//                    self?.isLoadFail = true
//                    self?.gallery.imageCollectionView.reloadData()
//                }
                
            default:
                return
//                self?.isLoading = false
//                self?.gallery.imageCollectionView.isHidden = true
//                self!.gallery.badRequest(message: message)
            }
        }
    }
    
}
