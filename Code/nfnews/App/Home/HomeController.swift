//
//  ViewController.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

class HomeController: UIViewController {

    public var coordinator: HomeCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.title = "Home"
        self.coordinator?.testMethod()
    }
}
