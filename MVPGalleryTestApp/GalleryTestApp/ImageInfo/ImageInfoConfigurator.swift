import UIKit


class ImageInfoConfigurator {
    
    func configure(view: ImageInfoViewController, model: OutImageEntity, image: UIImage) {
        let presenter = ImageInfoPresenter(view: view, model: model, image: image)
        view.presenter = presenter
    }
    
    static func open(navigationController: UINavigationController, model: OutImageEntity, image: UIImage) {
        guard let view = UIStoryboard(name: "ImageInfoStoryBoard", bundle: nil)
                .instantiateViewController(identifier: "ImageInfoViewController") as? ImageInfoViewController else { return }
        ImageInfoConfigurator().configure(view: view, model: model, image: image)
        navigationController.pushViewController(view, animated: true)
        
    }
}
