//
//  Configurator.swift
//  GalleryTestApp
//
//  Created by Роман on 25.05.2021.
//

import UIKit

class TariffSelectionConfigurator {
    func configure(view: TariffSelectionViewController) {
        let router = TariffSelectionRouter(view)
        let presenter = TariffSelectionPresenterImp(view,
                                                    router,
                                                    DI.resolve())
        view.presenter = presenter
    }

    static func open(navigationController: UINavigationController) {
        guard let view = R.storyboard.tariffSelectionStoryboard.instantiateInitialViewController() else {
            return
        }
        TariffSelectionConfigurator().configure(view: view)
        navigationController.pushViewController(view, animated: true)
    }
}
