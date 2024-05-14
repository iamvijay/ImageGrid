//
//  HomeFeedViewController.swift
//  ImageLoading
//
//  Created by V!jay on 13/05/24.
//

import UIKit

class HomeFeedViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var limitControlChange: UISegmentedControl!
    
    // MARK: - Private Properties
    /// An activity indicator shown during data loading.
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
    
    /// A custom collection view displaying the feed posts.
    private lazy var homeFeedPostCollectionView : FeedCollectionView = {
        let screenWidth = (view.frame.width / 3) - 8
        let collectionViewLayOut = UICollectionViewFlowLayout()
        collectionViewLayOut.itemSize = CGSize(width: screenWidth, height: screenWidth)
        
        let collectionView = FeedCollectionView(frame: view.frame, collectionViewLayout: collectionViewLayOut)
        collectionView.feedDelegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var currentLimit : String = Constants.defaultLimit
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupFeedCollectionView()
    }
    
    // MARK: - Actions
    /// Attempts to reload the feed when the retry button is pressed.
    @IBAction func retryAction(_ sender: Any) {
        homeFeedPostCollectionView.reloadFeed(limit: currentLimit)
        errorView.isHidden = true
    }
    
    /// Updates the feed limit based on the user's selection in the segmented control.
    @IBAction func limitChangeAction(_ sender: UISegmentedControl) {
        if let limit = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            currentLimit = limit
            homeFeedPostCollectionView.reloadFeed(limit: currentLimit)
        }
    }
}

// MARK: - Private Methods
extension HomeFeedViewController {
    private func setupFeedCollectionView () {
        
        containerView.addSubview(homeFeedPostCollectionView)
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 100),
            activityIndicator.heightAnchor.constraint(equalToConstant: 100),
            
            homeFeedPostCollectionView.topAnchor.constraint(equalTo: self.containerView.safeAreaLayoutGuide.topAnchor, constant: 0),
            homeFeedPostCollectionView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
            homeFeedPostCollectionView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
            homeFeedPostCollectionView.bottomAnchor.constraint(equalTo: self.containerView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    /// Controls the visibility and animation of the activity indicator.
    private func setactivityIndicator(isAnimating: Bool) {
        isAnimating ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        activityIndicator.isHidden = !isAnimating
    }
}

// MARK: - FeedPostDelegate Implementation
extension HomeFeedViewController : FeedPostDelegate {
    /// Handles user interaction with a feed card.
    /// Opens the detail view for the selected post.
    /// - Parameter post: The `HomeFeedPosts` object that was selected
    func didFeedCardClick(post: HomeFeedPosts) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailViewController = storyBoard.instantiateViewController(identifier: "PostDetailViewController") as? PostDetailViewController, !post.coverageURL.isEmpty {
            detailViewController.feedPost = post
            detailViewController.modalPresentationStyle = .fullScreen
            self.present(detailViewController, animated: true)
        }
    }
    
    /// Called when the feed request successfully completes.
    /// This method hides any error views and stops the loader animation.
    func didFeedRequestSuccess() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.setactivityIndicator(isAnimating: false)
        }
    }
    
    /// Called when the feed request fails.
    /// This method shows an error view and stops the loader animation.
    func didFeedRequestFailed() {
        DispatchQueue.main.async {
            self.errorView.isHidden = false
            self.setactivityIndicator(isAnimating: false)
        }
    }
}
