//
//  Configurator.swift
//  GalleryTestApp
//
//  Created by Роман on 25.05.2021.
//

import UIKit


class Configurator {
    
    func configure(view: ImageInfoViewController, model: OutImageEntity) {
        let presenter = FullImageInfoPresenter(view: view, model: model)
        view.presenter = presenter
    }
    
    static func open(navigationController: UINavigationController, model: OutImageEntity) {
        guard let view = UIStoryboard(name: "ImageInfoStoryBoard", bundle: nil)
                .instantiateViewController(identifier: "ImageInfoViewController") as? ImageInfoViewController else { return }
        Configurator().configure(view: view, model: model)
        navigationController.pushViewController(view, animated: true)
        
    }
}
