//
//  favoriteVC.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 12/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit
import AVFoundation

class favoriteVC: UIViewController, iCarouselDataSource, iCarouselDelegate,UIGestureRecognizerDelegate {
    
    var movies : Array<MovieModel> = []
    var currentIndex : Int = -1;
    @IBOutlet weak var carousel: iCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = databaseLink.getAllMovies();
        let defaults = UserDefaults.standard
        let favorites = defaults.array(forKey: "Favorites")
        movies = movies.filter { (movie : MovieModel) -> Bool in
            return favorites!.contains(where: {movie.id == $0 as! Int64})
        }
        self.carousel.reloadData();
        carousel.type = .coverFlow2
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return movies.count
    }
        
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var myView: FavoritesCVC? = nil;
        //reuse view if available, otherwise create a new view
        
        
        //reuse view if available, otherwise create a new view
        if let view = view as? FavoritesCVC {
            myView = view;
        } else {
            myView = UINib(nibName: "CarouselItem", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView as? FavoritesCVC
        }
        myView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        myView?.addGestureRecognizer(tapGesture)
        myView?.setUpPoster(url: self.movies [index].poster);
        
        return myView!
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        currentIndex = carousel.currentItemIndex;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a variable that you want to send
        if (segue.identifier == "custom") {
            let destinationVC = segue.destination as! MovieDetailVC;
            let movieToPass = movies[currentIndex];
            destinationVC.movie = movieToPass;
        }
    }

    
    func doubleTapped() {
        performSegue(withIdentifier: "custom", sender: self)
    }

}
