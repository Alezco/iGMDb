//
//  favoriteVC.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 12/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit

class favoriteVC: UIViewController, iCarouselDataSource, iCarouselDelegate {
    var items: [Int] = []
    @IBOutlet weak var carousel: iCarousel!
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0 ... 10 {
            items.append(i)
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
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var myView: FavoritesCVC? = nil;
        var posterImageView : UIImageView;
        //reuse view if available, otherwise create a new view
        myView = UINib(nibName: "CarouselItem", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView as? FavoritesCVC
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        myView?.setUpPoster(url: "https://images-na.ssl-images-amazon.com/images/M/MV5BMTAwMjU5OTgxNjZeQTJeQWpwZ15BbWU4MDUxNDYxODEx._V1_SX300.jpg")
        
        return myView!
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
