//
//  HomeDetailController.swift
//  nfnews
//
//  Created by Work on 2/9/21.
//

import UIKit
import WebKit

class HomeDetailController: UIViewController {
    fileprivate var url:URL
    var coordinator: HomeCoordinator?
    
    lazy var webView: WKWebView = {
        let wv = WKWebView()
        wv.navigationDelegate = self
        return wv
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.color = a.tintColor
        a.hidesWhenStopped = true
        return a
    }()
    
    lazy var acitivityBarItem: UIBarButtonItem = {
        let activity = UIBarButtonItem(customView: self.activityIndicator)
        return activity
    }()
    
    lazy var backBarItem: UIBarButtonItem = {
       let back = UIBarButtonItem(
            title: "Done",
            style:.plain,
            target: self,
            action: #selector(goBack)
        )
        return back
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.loadWebpage(url: url)
    }
    
    @objc
    private func goBack() {
        self.dismiss(animated: true, completion: nil)
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
    
    private func setupUI() {
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.navigationItem.rightBarButtonItem = self.acitivityBarItem
        self.navigationItem.leftBarButtonItem = self.backBarItem
        self.hidesBottomBarWhenPushed = true
    }
}

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

