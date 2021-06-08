import Foundation

class GalleryConfigurator {
    func config(view: MainGalleryViewController, currentCollection: Int) {
        
        guard let collectionType = CollectionType(rawValue: currentCollection) else { return }
        let router = Router(view)
        let presenter = MainGalleryPresenter(view: view,
                                         router: router,
                                         currentCollection: collectionType)
        view.galleryPresenter = presenter
    }
}
