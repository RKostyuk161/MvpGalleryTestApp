//
//  Configurator.swift
//  GalleryTestApp
//
//  Created by Роман on 25.05.2021.
//

import UIKit


class Configurator {
    
    func configure(view: ImageInfoViewController, model: OutImageEntity, image: UIImage) {
        let presenter = FullImageInfoPresenter(view: view, model: model, image: image)
        view.presenter = presenter
    }
    
    static func open(navigationController: UINavigationController, model: OutImageEntity, image: UIImage) {
        guard let view = UIStoryboard(name: "ImageInfoStoryBoard", bundle: nil)
                .instantiateViewController(identifier: "ImageInfoViewController") as? ImageInfoViewController else { return }
        Configurator().configure(view: view, model: model, image: image)
        navigationController.pushViewController(view, animated: true)
        
    }
}
