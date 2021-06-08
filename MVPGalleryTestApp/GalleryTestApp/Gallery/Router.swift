import UIKit

class Router {
    
    weak var view: UIViewController!
    
    
    init(_ view: MainGalleryViewController) {
        self.view = view
    }
    
    func openImageInfoView(model: OutImageEntity, image: UIImage) {
        if let navController = self.view.navigationController {
            ImageInfoConfigurator.open(navigationController: navController, model: model, image: image)
        }
    }
}
