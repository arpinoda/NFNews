//
//  ViewController.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

class HomeController: UIViewController {

    public var coordinator: HomeCoordinator?
    
    // A lazy closure allows us to reference "self" during var instantiation
    fileprivate lazy var viewModel: HomeViewModel = {
        return HomeViewModel(
            apiClient: LocalAPIService(),
//            apiClient: RemoteAPIService(),
            onLoading: self.onLoading,
            onError: self.onError,
            onSuccess: self.onSuccess
        )
    }()
    
    // Views
    fileprivate var tableView = HomeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.setupUI()
        self.loadData()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.title = "Home"
        view.addSubview(tableView)
    }
    
    private func loadData() {
        viewModel.fetchHeadlines()
    }
    
    private func onSuccess(response: NFNResponse) {
        self.tableView.reloadData()
        print("Success!")
    }
    
    private func onError(message: String) {
        print(message)
    }
    
    private func onLoading() {
        print("loading")
    }
}

// MARK: - TableView boilerplate
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: IndexPath) {
        cell.textLabel?.text = viewModel.textLabelForItem(at: indexPath)
    }
}
