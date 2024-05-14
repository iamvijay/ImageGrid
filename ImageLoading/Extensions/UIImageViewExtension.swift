//
//  UIImageViewExtension.swift
//  SocialFeed
//
//  Created by V!jay on 13/05/24.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    private static var taskKey: Int = 0

    private var currentTask: URLSessionDataTask? {
        get { objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionDataTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func loadImageWithURL(from urlString: String) {
        // Cancel the current task if it exists
        if let task = currentTask {
            task.cancel()
            //print("Cancelled task for URL: \(task.originalRequest?.url?.absoluteString ?? "unknown URL")")
        }

        // Set a placeholder image
        self.image = UIImage(named: "placeholder-image.png")

        // Check if image is cached
        if let cachedImage = ImageCacheManager.shared.getCachedImage(for: urlString) {
            self.image = cachedImage
            return
        }

        // Ensure URL is valid
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            // Check if the task was cancelled after network response
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                //print("Network task was cancelled for URL: \(urlString)")
                return
            }

            guard let imageData = data, error == nil, let downloadedImage = UIImage(data: imageData) else {
                print("Failed to load image data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Process image in the background
            DispatchQueue.global(qos: .userInitiated).async {
                let resizedImage = downloadedImage.resizeImage(targetSize: CGSize(width: 200, height: 200))
                if let resizedImageAvailable = resizedImage {
                    ImageCacheManager.shared.cacheImage(image: resizedImageAvailable, for: urlString)
                    DispatchQueue.main.async {
                        self.image = resizedImageAvailable
                    }
                }
            }
        }

        // Set the task and start it
        currentTask = task
        task.resume()
    }
}

extension UIImage {
    /// This function is to resize the image before stroring in cache
    /// - Parameter targetSize: You need to pass what size you want to resize the image, default is 100 x 100
    /// - Returns: FInally it returns resized image
    func resizeImage(targetSize : CGSize = CGSize(width: 100, height: 100)) -> UIImage? {
        let image = self
        let size = image.size
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize : CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        return newImage
    }
}
