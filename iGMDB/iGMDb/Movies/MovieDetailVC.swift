//
//  MoviedetailVC.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 12/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit
import YouTubePlayer
import pop

class MovieDetailVC: UIViewController {

    var movie : MovieModel?;
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var youtubePlayer: YouTubePlayerView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = movie?.title;
        self.yearLabel.text = movie?.realeased;
        self.genreLabel.text = movie?.genre;
        self.directorLabel.text = movie?.director;
        self.actorsLabel.text = movie?.actors;
        self.countryLabel.text = movie?.country;
        self.languageLabel.text = movie?.language;
        self.plotLabel.text = movie?.plot;
        downloadImage(url: URL(string: (movie?.poster)!)!);
        let urlArray: [String] = (movie?.Youtube.components(separatedBy: "/"))!
        youtubePlayer.loadVideoID(urlArray[urlArray.count - 1])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onFavoriteClick(_ sender: Any) {
            if let springAnimation = POPSpringAnimation(propertyNamed:
                kPOPViewScaleXY){
                springAnimation.toValue = NSValue(cgPoint: CGPoint(x:2, y:2))
                springAnimation.velocity = NSValue(cgPoint: CGPoint(x:1, y:1))
                springAnimation.springBounciness = 20.0
                springAnimation.completionBlock = {(animation, end) in
                    if let springAnimation2 = POPSpringAnimation(propertyNamed:
                        kPOPViewScaleXY){
                        springAnimation2.toValue = NSValue(cgPoint: CGPoint(x:1, y:1))
                        springAnimation2.velocity = NSValue(cgPoint: CGPoint(x:1, y:1))
                        springAnimation2.springBounciness = 20.0
                    self.favoriteButton.pop_add(springAnimation2, forKey:"springAnimation")
                    }
                }
                
                self.favoriteButton.pop_add(springAnimation, forKey:"springAnimation")
            }
    }
}
