//
//  FavoritesCVC.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 15/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit

class FavoritesCVC: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    func setUpPoster(url : String) {
        if let checkedUrl = URL(string: url) {
            posterImageView.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                completion(data, response, error)
                }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.posterImageView.image = UIImage(data: data)
            }
        }
    }
}
