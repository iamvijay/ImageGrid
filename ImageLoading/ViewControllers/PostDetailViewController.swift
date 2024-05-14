//
//  PostDetailViewController.swift
//  ImageLoading
//
//  Created by V!jay on 13/05/24.
//

import UIKit
import WebKit

class PostDetailViewController: UIViewController {

    /// Clean up the web view resources on deinitialization.
    deinit {
        coverageWebView.stopLoading()
        coverageWebView.navigationDelegate = nil
        coverageWebView.uiDelegate = nil
        print("PostDetailViewController deinitialized")
    }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherName: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    @IBOutlet weak var webviewContainerView: UIView!
    
    // MARK: - Private Properties
    // Post data passed from another view controller
    var feedPost : HomeFeedPosts?
    
    /// Lazy-initialized WKWebView with default configuration.
    private lazy var coverageWebView : WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webview = WKWebView(frame: .zero, configuration: configuration)
        webview.translatesAutoresizingMaskIntoConstraints = false
        webview.navigationDelegate = self
        
        return webview
    }()
    
    /// Activity Indicator to show loading state when web content is being loaded.
    private lazy var activityIndicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.layer.cornerRadius = 10
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.backgroundColor = .black
        indicator.startAnimating()
        return indicator
    }()
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    // MARK: - Actions
    /// Dismisses the view controller.
    @IBAction func closeDetailView(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - Setup and Loading Functions
extension PostDetailViewController {
    private func setupView () {
        titleLabel.text = feedPost?.title ?? ""
        publisherName.text = feedPost?.publishedBy ?? ""
        publishedDate.text = "Published On : \(feedPost?.publishedAt ?? "")"
        
        loadCoverPageWebView()
    }
    
    /// Configures and adds the web view and activity indicator to the view hierarchy.
    private func loadCoverPageWebView () {
        webviewContainerView.addSubview(coverageWebView)
        webviewContainerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.webviewContainerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.webviewContainerView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            
            coverageWebView.topAnchor.constraint(equalTo: self.webviewContainerView.topAnchor, constant: 0),
            coverageWebView.leftAnchor.constraint(equalTo: self.webviewContainerView.leftAnchor),
            coverageWebView.rightAnchor.constraint(equalTo: self.webviewContainerView.rightAnchor),
            coverageWebView.bottomAnchor.constraint(equalTo: self.webviewContainerView.bottomAnchor, constant: 0)
        ])
        
        /// Loads the web view with the URL specified in `feedPost`.
        if let urlString = feedPost?.coverageURL, !urlString.isEmpty {
            if let coverURL = URL(string: urlString) {
                coverageWebView.load(URLRequest(url: coverURL))
            }
        }
    }
    
    /// Updates the visibility and animation state of the activity indicator.
    private func setactivityIndicator(isAnimating: Bool) {
        isAnimating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        activityIndicator.isHidden = !isAnimating
    }
}

// MARK: - WKNavigationDelegate Implementation
extension PostDetailViewController : WKNavigationDelegate {
    // WKNavigationDelegate methods
      func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
          setactivityIndicator(isAnimating: true)
      }

      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
          setactivityIndicator(isAnimating: false)
      }

      func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
          setactivityIndicator(isAnimating: false)
          print("Error loading web content: \(error.localizedDescription)")
      }
}
