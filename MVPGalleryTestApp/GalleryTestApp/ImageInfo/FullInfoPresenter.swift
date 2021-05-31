//
//  ImageInfoPresenter.swift
//  GalleryTestApp
//
//  Created by Роман on 28.05.2021.
//

import Foundation
import UIKit
import Alamofire
import RxSwift
import RxAlamofire

protocol ImageInfoPresenterProtocol {
    func viewDidLoad()
}

class FullImageInfoPresenter: ImageInfoPresenterProtocol {
    
    weak var view: ImageInfoViewController!
    let model: OutImageEntity
    
    init(view: ImageInfoViewController, model: OutImageEntity) {
        self.view = view
        self.model = model
    }
    
    var disposeBag = DisposeBag()
    
    var baseUrl = "http://gallery.dev.webant.ru/media/"
    
    
    typealias imageCallBack = (_ getInfo: UIImage?, _ message: String) -> Void
    
    func viewDidLoad() {
        self.view.noInternetStackView.isHidden = true
    }
    
    func takeImage() {
        getFullImageRequest(model: self.model) {
            [weak self] (getInfo, message) in
            switch message {
            case "200":
                guard let self = self else { return }
                guard let allGettingInfo = getInfo else { return }
                self.view.noInternetStackView.isHidden = true
                self.view.fullImage.isHidden = false
                self.view.imageName.isHidden = false
                self.view.imageDescription.isHidden = false
                self.view.displayImage(image: allGettingInfo)
                self.view.display(name: self.model.name ?? "")
                self.view.display(description: self.model.description ?? "")
            case "no connection":
                self?.view.fullImage.isHidden = true
                self?.view.imageName.isHidden = true
                self?.view.imageDescription.isHidden = true
                self?.view.noInternetStackView.isHidden = false
                self?.createAlertForBadRequest(message: message)
            default:
                self?.createAlertForBadRequest(message: message)
            }
        }
    }
    
    func getFullImageRequest(model: OutImageEntity, callback: @escaping imageCallBack) {
        
        guard let imageName = model.image?.name else { return }
        let imageRequestUrl = self.baseUrl + String(describing: imageName)
    
        RxAlamofire.data(.get, imageRequestUrl)
            .debug()
            .do(onSubscribe: { [weak self] in
                self?.view.spin(isNeedToSpin: true)
            }, onDispose: { [ weak self ] in
                self?.view.spin(isNeedToSpin: false)
            })
            .subscribe { response in
                guard let data = UIImage(data: response) else { return }
                callback(data, "200")
            } onError: { (error) in
                callback(nil, "no connection")
            }
            .disposed(by: disposeBag)
    }
    
    func createAlertForBadRequest(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel, handler: nil)
        let tryRequest = UIAlertAction(title: "Повторить запрос", style: UIAlertAction.Style.default) { (tryRequest) -> Void in
            self.takeImage()
        }
        alert.addAction(tryRequest)
        alert.addAction(cancel)
        view.present(alert, animated: true, completion: nil)
    }
}
