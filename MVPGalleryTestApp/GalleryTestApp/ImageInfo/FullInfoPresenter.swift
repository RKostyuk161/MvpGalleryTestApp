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
    let image: UIImage
    
    init(view: ImageInfoViewController, model: OutImageEntity, image: UIImage) {
        self.view = view
        self.model = model
        self.image = image
    }
        
    func viewDidLoad() {
        self.view.displayImage(image: image)
        self.view.display(name: self.model.name ?? "")
        self.view.display(description: self.model.description ?? "")
    }
}
