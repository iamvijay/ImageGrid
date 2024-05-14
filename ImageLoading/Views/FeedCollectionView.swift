//
//  FeedCollectionView.swift
//  ImageLoading
//
//  Created by V!jay on 13/05/24.
//

import UIKit

/// Protocol to communicate feed interactions and network result states.
protocol FeedPostDelegate : AnyObject {
    func didFeedCardClick(post : HomeFeedPosts)
    func didFeedRequestSuccess()
    func didFeedRequestFailed()
}

class FeedCollectionView: UICollectionView {
    
    // MARK: - Private Properties
    private var feedDataSource : UICollectionViewDiffableDataSource<Int, HomeFeedPosts>!
    weak var feedDelegate : FeedPostDelegate?
    private var currentLimit : String = Constants.defaultLimit
    
    // Initializes the collection view with specified frame and layout.
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupCollectionView()
    }
    
    // Required initializer from the NSCoder, used when initializing from storyboard.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI Configuration and Data Handling
extension FeedCollectionView {
    private func setupCollectionView () {
        self.delegate = self
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        
        let uiNib = UINib(nibName: "FeedPostCollectionViewCell", bundle: .main)
        self.register(uiNib, forCellWithReuseIdentifier: Constants.feedPostCellReuseIdentifier)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.refreshFeed), for: .valueChanged)
        self.refreshControl?.tintColor = .gray
        
        configureDataSource()
        loadHomeFeed()
    }
    
    /// Initiates a request to load feed posts based on the provided limit.
    func loadHomeFeed(limit : String = Constants.defaultLimit) {
        APIManager.homeFeed(limit: limit) { [weak self] (response: APIResult<[HomeFeedPosts]>) in
            guard let self = self else { return }
            switch response {
            case .success(let feedResponse):
                self.feedDelegate?.didFeedRequestSuccess()
                self.handleResponse(response: feedResponse)
            case .failure(_):
                self.feedDelegate?.didFeedRequestFailed()
            }
        }
    }
    
    /// Handles the successful loading of feed posts by updating the UI.
    private func handleResponse(response : [HomeFeedPosts]) {
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing() // Ensure to stop the refresh control here.
            
            var snapshot = NSDiffableDataSourceSnapshot<Int, HomeFeedPosts>()
            snapshot.appendSections([0]) // Make sure '0' is your intended section.
            snapshot.appendItems(response, toSection: 0)
            self.feedDataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    /// Refreshes the feed by reloading data with the current limit.
    @objc
    func refreshFeed () {
        reloadFeed(limit: currentLimit)
    }
    
    /// Reloads the feed with a specific item limit, updating the UI accordingly.\
    func reloadFeed(limit : String = Constants.defaultLimit) {
        var snapshot = self.feedDataSource.snapshot()
        snapshot.deleteAllItems()
        self.feedDataSource.apply(snapshot, animatingDifferences: false)
        self.currentLimit = limit
        self.loadHomeFeed(limit: self.currentLimit)
    }
}

// MARK: - DataSource Configuration
extension FeedCollectionView {
    private func configureDataSource () {
        feedDataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: { collectionView, indexPath, feedPost in
            guard let feedPostCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.feedPostCellReuseIdentifier, for: indexPath) as? FeedPostCollectionViewCell else {
                fatalError("Could not dequeue FeedPostCollectionViewCell")
            }
            
            feedPostCell.setupCellUI(post: feedPost)
            return feedPostCell
        })
    }
}

// MARK: - UICollectionViewDelegate Implementation
extension FeedCollectionView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let feedPost = feedDataSource.itemIdentifier(for: indexPath) {
            feedDelegate?.didFeedCardClick(post: feedPost)
        }
    }
}
