//
//  Router.swift
//  
//
//  Created by Роман on 25.05.2021.
//


import UIKit

class TariffSelectionRouter/*: BaseRouter*/ {
    
    weak var view: UIViewController!
    
    init(_ view: MainGalleryViewController) {
        self.view = view
    }
    
    func openFinalBookingScene() {
        if let navController = self.view.navigationController {
            BookingFinalConfigurator.open(navigationController: navController,
                                          screenState: .payment)
        }
    }
    
    func openCompanionsSelectionScene() {
        if let navController = self.view.navigationController {
            CompanionsSelectionConfigurator.open(navigationController: navController)
        }
    }
}
