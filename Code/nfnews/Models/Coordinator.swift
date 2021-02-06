//
//  Coordinator.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}
