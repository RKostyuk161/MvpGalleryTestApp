//
//  Router.swift
//  
//
//  Created by Роман on 25.05.2021.
//


import UIKit

class Router {
    
    weak var view: UIViewController!
    
    
    init(_ view: MainGalleryViewController) {
        self.view = view
    }
    
    func openImageInfoView(model: OutImageEntity) {
        if let navController = self.view.navigationController {
            Configurator.open(navigationController: navController, model: model)
        }
    }
}
