//
//  AppCoordinator.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {

    var navigationController: UINavigationController
    var listMoviesCoordinator: ListMoviesCoordinator?
    
    init(navigationController navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        listMoviesCoordinator = ListMoviesCoordinator(navigationController: self.navigationController)
        listMoviesCoordinator?.start()
    }
}
