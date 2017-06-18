//
//  favoriteVC.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 12/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit
import AVFoundation
import pop

class favoriteVC: UIViewController, iCarouselDataSource, iCarouselDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var noFavoritesTV: UILabel!
    var movies : Array<MovieModel> = []
    var currentIndex : Int = 0;
    @IBOutlet weak var carousel: iCarousel!
    var defaults : UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = databaseLink.getAllMovies();
        self.updateCarousel();
        carousel.type = .coverFlow2
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateCarousel();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return movies.count
    }
    
    func updateCarousel() {
        let favorites = defaults.array(forKey: "Favorites")
        movies = movies.filter { (movie : MovieModel) -> Bool in
            return favorites!.contains(where: {movie.id == $0 as! Int64})
        }
        if (movies.count == 0) {
            self.noFavoritesTV.isHidden = false;
        } else {
            self.noFavoritesTV.isHidden = true;
        }
        self.carousel.reloadData();
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
    
    
    @IBAction func onRemoveClick(_ sender: Any) {
        var favorites = defaults.array(forKey: "Favorites")
        if (movies.count > 0) {
            let deleteId = movies [currentIndex]
            favorites = favorites?.filter() { $0 as! Int64 != deleteId.id }
            defaults.set(favorites, forKey: "Favorites")
            defaults.synchronize()
            movies.remove(at: currentIndex)
            carousel.removeItem(at: currentIndex, animated: true)
            self.carousel.delegate?.carouselCurrentItemIndexDidChange!(self.carousel);
            if (favorites?.count == 0) {
                self.noFavoritesTV.isHidden = false;
            }
        } else {
            self.noFavoritesTV.isHidden = false;
            if let shake = POPSpringAnimation(propertyNamed: kPOPLayerPositionX){
                shake.springBounciness = 20.0
                shake.velocity = 1500
                self.noFavoritesTV.layer.pop_add(shake, forKey: "shakePassword")
            }
        }
    }

}
