//
//  File.swift
//  scratch
//
//  Created by Work on 2/15/21.
//

import UIKit
import WebKit

fileprivate struct Lang {
    static let coordinatorNotSet = "Coordinator has not been initialized"
    static let emptyViewModel = "News Article has an empty view model"
}

class HomeDetailController: UIViewController {
 
    // MARK: - Properties
    var viewModel: HomeDetailViewModel?
    
    private lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.navigationDelegate = self
        return wv
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.color = a.tintColor
        a.hidesWhenStopped = true
        return a
    }()
    
    private lazy var acitivityBarItem: UIBarButtonItem = {
        let activity = UIBarButtonItem(customView: self.activityIndicator)
        return activity
    }()
    
    private lazy var backBarItem: UIBarButtonItem = {
       let back = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        return back
    }()
    
    // MARK: - UIViewContoller
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupUI()
        
        if let url = viewModel?.article.sourceURL {
            self.loadWebpage(url: url)
        } else {
            print(Lang.emptyViewModel)
        }
        
    }
    
    // MARK: - Actions
    @objc
    private func goBack() {
        
        if let viewModel = viewModel {
            viewModel.didCloseArticle()
        } else {
            print(Lang.emptyViewModel)
        }
        
    }
    
    private func loadWebpage(url: URL) {
        self.updateActivity(visible: true)
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        self.webView.load(request)
    }
    
    private func updateActivity(visible: Bool) {
        if visible {
            self.activityIndicator.startAnimating()
            self.navigationItem.rightBarButtonItem = self.acitivityBarItem
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - WKNavigation Delegate
extension HomeDetailController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.updateActivity(visible: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.updateActivity(visible: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.updateActivity(visible: false)
    }
}

// MARK: - UI Setup
extension HomeDetailController {
    private func setupUI() {
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.title = viewModel?.article.title
        
        self.navigationItem.rightBarButtonItem = self.acitivityBarItem
        self.navigationItem.leftBarButtonItem = self.backBarItem
        self.hidesBottomBarWhenPushed = true
    }
}
