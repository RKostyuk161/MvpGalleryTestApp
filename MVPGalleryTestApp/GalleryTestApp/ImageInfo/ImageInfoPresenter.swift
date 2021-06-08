import UIKit


class ImageInfoPresenter {
    
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
