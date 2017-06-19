//
//  SearchCollectionViewCell.swift
//  iGMDb
//
//  Created by hadrien de lamotte on 19/06/2017.
//  Copyright © 2017 epita. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    var movie: MovieModel?;
    
    @IBOutlet weak var searchMathchLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib();
    }

    
    func setCell(mathSearch : String) {
        self.favoriteImage.isHidden = !isFavorite()
        self.searchMathchLabel.text = mathSearch;
        self.titleLabel.text = movie?.title;
        downloadImage(url: URL(string: (movie?.poster)!)!);
    }
    
    func isFavorite() -> Bool {
        let defaults : UserDefaults = UserDefaults.standard
        let favorites = defaults.array(forKey: "Favorites")
        let currID : Int = Int(truncatingBitPattern: (self.movie?.id)!)
        let index = favorites?.index(where: { $0 as! Int == currID })
        if (index == nil) {
            return false
        }
        else
        {
            return true
        }
    }
    
    override func prepareForReuse() {
        self.favoriteImage.isHidden = true;
        self.titleLabel.text = "";
        self.searchMathchLabel.text = ""
        self.posterImageView.image = UIImage(named:"posterPlaceholder")
        super.prepareForReuse()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.posterImageView.image = UIImage(data: data)
            }
        }
    }

}
