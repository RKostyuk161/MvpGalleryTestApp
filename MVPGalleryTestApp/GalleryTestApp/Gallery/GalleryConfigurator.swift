//
//  GalleryConfigurator.swift
//  GalleryTestApp
//
//  Created by Роман on 28.05.2021.
//

import Foundation

class GalleryConfigurator {
    func config(view: MainGalleryViewController, currentCollection: Int) {
        
        guard let collectionType = CollectionType(rawValue: currentCollection) else { return }
        let router = Router(view)
        let presenter = GalleryPresenter(view: view,
                                         router: router,
                                         currentCollection: collectionType)
        view.galleryPresenter = presenter
    }
}
