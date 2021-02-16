//
//  ViewController.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import UIKit

fileprivate struct Lang {
    static let errorTitle = "Error"
    static let errorButtonTitle = "Okay"
}

enum HomeControllerState {
    case loading, error(String), done
}

class HomeController: UIViewController {

    // MARK: - Properties
    var viewModel: HomeViewModelType! {
        didSet {
            viewModel.viewDelegate = self
        }
    }
    
    var state: HomeControllerState = .done {
        didSet {
            switch state {
            case .loading:
                self.tableView.refreshControl?.beginRefreshing()
                break
            case .error(let message):
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.presentAlert(title: Lang.errorTitle, message: message)
                }
                break
            case .done:
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.isScrollEnabled = true
                }
                break
            }
        }
    }
    
    // Animators
    fileprivate var headerAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn)
    
    fileprivate var logoAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn)
    
    // Views
    fileprivate var headerView = HomeHeader()
    fileprivate var logoView = AppLogo()
    fileprivate var tableView = HomeTableView()
    
    // MARK: - UIViewContoller
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        viewModel.start()
    }

    // MARK: - Setup
    func setup() {
        self.setupUI()
        self.setupAnimations()
    }

    // MARK: - Actions
    @objc
    private func fetchHeadlines() {
        viewModel.fetchHeadlines()
    }
    
    private func presentAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: Lang.errorButtonTitle, style: .default, handler: nil))

        self.present(alert, animated: true, completion: {
            self.tableView.isScrollEnabled = true
        })
    }
}

// MARK: - ViewModel Delegate
extension HomeController: HomeViewModelViewDelegate {
    func updateScreen() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func updateState(_ state: HomeControllerState) {
        self.state = state
    }
}

// MARK: - UITableView Delegate & DataSource
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    fileprivate var topIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let viewData = viewModel.viewDataForCell(at: indexPath)
        cell.viewData = viewData
        cell.viewModel = self.viewModel
        cell.borderHidden = indexPath.section == 0
        cell.collectionView.scrollToItem(at: topIndexPath, at: .top, animated: false)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the %-complete for both animators
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

// MARK: - UI Setup
extension HomeController {
        
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(headerView)
        view.addSubview(logoView)
        view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchHeadlines), for: .valueChanged)
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
}
