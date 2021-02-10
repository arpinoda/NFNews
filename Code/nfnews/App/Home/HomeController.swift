//
//  ViewController.swift
//  nfnews
//
//  Created by Work on 2/6/21.
//

import UIKit

class HomeController: UIViewController {

    public var coordinator: HomeCoordinator?
    
    /// A lazy closure allows us to reference "self" during var instantiation.
    /// We're "binding" to the view model by passing various callback functions
    fileprivate lazy var viewModel: HomeViewModel = {
        return HomeViewModel(
//            apiClient: LocalAPIService(),
            apiClient: RemoteAPIService(),
            onLoading: self.onLoading,
            onError: self.onError,
            onSuccess: self.onSuccess,
            onArticleTapped: self.onArticleTapped
        )
    }()
    
    // Animators
    fileprivate let headerAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .linear)
    fileprivate let logoAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn)
    
    // Views
    fileprivate var headerView = AppHeader()
    fileprivate var logoView = AppLogo()
    fileprivate var tableView = AppTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupAnimations()
        self.loadData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(headerView)
        view.addSubview(logoView)
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    private func setupAnimations() {
        headerAnimator.pausesOnCompletion = true
        headerAnimator.addAnimations {
            self.headerView.heightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        logoAnimator.scrubsLinearly = false
        logoAnimator.pausesOnCompletion = true
        logoAnimator.addAnimations {
            self.logoView.topConstraint.constant = 0.055 * UI.screenHeight * UI.screenScale
            self.view.layoutIfNeeded()
        }
        
        tableView.isScrollEnabled = false
    }
    
    @objc
    private func loadData() {
        viewModel.fetchHeadlines()
    }
    
    private func onSuccess() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            self.tableView.isScrollEnabled = true
        }
    }
    
    private func onError(message: String) {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true, completion: {
                self.tableView.isScrollEnabled = true
            })
        }
    }
    
    private func onLoading() {
        tableView.refreshControl?.beginRefreshing()
    }
    
    private func onArticleTapped(url: URL) {
        coordinator?.showArticleDetail(url: url)
    }
}

// MARK: - TableView boilerplate
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.heightForRowAt(indexPath: indexPath))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.modelForCell(at: indexPath)
        cell.model = model
        cell.borderHidden = indexPath.section == 0
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.isScrollEnabled {
            let insetTop = view.safeAreaInsets.top + scrollView.contentInset.top
            let scrollY = scrollView.contentOffset.y

            let logoFraction = 1 + (scrollY / insetTop)
            let headerFraction =
                1 + (scrollY + headerView.frame.minY) /
                    (insetTop - headerView.frame.minY)

            logoAnimator.fractionComplete = logoFraction
            headerAnimator.fractionComplete = headerFraction
        }
    }
}
