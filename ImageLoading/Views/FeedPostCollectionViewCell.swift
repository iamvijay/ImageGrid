//
//  FeedPostCollectionViewCell.swift
//  ImageLoading
//
//  Created by V!jay on 13/05/24.
//

import UIKit

class FeedPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil // Reset the image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupCellUI (post : HomeFeedPosts) {
        guard !post.thumbnailImageURL.isEmpty else {
            thumbnailImageView.image = UIImage(named: "placeholder-image.png")
            return
        }
        thumbnailImageView.loadImageWithURL(from: post.thumbnailImageURL)
    }

}
