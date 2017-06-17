//
//  MovieTableViewCell.swift
//  iGMDb
//
//  Created by Admin on 17/06/2017.
//  Copyright © 2017 epita. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieFavorite: UIImageView!
    var isFavorite: Bool = false;
    var movie: MovieModel?;

    override func awakeFromNib() {
        super.awakeFromNib();
        //downloadImage(url: URL(string: (movie?.poster)!)!);
        //movieTitle.text = movie?.title;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                self.moviePoster.image = UIImage(data: data)
            }
        }
    }

}
