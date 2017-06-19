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
import FBSDKShareKit
import FBSDKMessengerShareKit
import FaveButton

class MovieDetailVC: UIViewController, YouTubePlayerDelegate, FaveButtonDelegate {

    var movie : MovieModel?;
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var youtubePlayer: YouTubePlayerView!
    @IBOutlet weak var favoriteButton: FaveButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // begin receiving remote events
        UIApplication.shared.beginReceivingRemoteControlEvents()
        youtubePlayer.delegate = self;

        self.activityIndicator.isHidden = false;
        // Do any additional setup after loading the view.
        self.titleLabel.text = movie?.title;
        self.yearLabel.text = movie?.realeased;
        self.genreLabel.text = movie?.genre;
        self.directorLabel.text = movie?.director;
        self.actorsLabel.text = movie?.actors;
        self.countryLabel.text = movie?.country;
        self.languageLabel.text = movie?.language;
        self.plotTextView.text = movie?.plot;
        downloadImage(url: URL(string: (movie?.poster)!)!);
        let urlArray: [String] = (movie?.Youtube.components(separatedBy: "/"))!
        youtubePlayer.loadVideoID(urlArray[urlArray.count - 1])
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool){
    }
    
    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]?{
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults : UserDefaults = UserDefaults.standard
        var favorites = defaults.array(forKey: "Favorites")
        let currID : Int = Int(truncatingBitPattern: (self.movie?.id)!)
        let index = favorites?.index(where: { $0 as! Int == currID })
        if (index == nil) {
            self.favoriteButton.isSelected = false;
        }
        else
        {
            self.favoriteButton.isSelected = true;
        }
    }

    @IBAction func onFavoriteClick(_ sender: Any) {
        self.like();
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
    
    func playerReady(_ videoPlayer: YouTubePlayerView){
        print("Player Ready!")
        youtubePlayer.isHidden = false;
        activityIndicator.isHidden = true;
        self.shareButton.isEnabled = true;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func like() {
        let defaults : UserDefaults = UserDefaults.standard
        var favorites = defaults.array(forKey: "Favorites")
        let currID : Int = Int(truncatingBitPattern: (self.movie?.id)!)
        let index = favorites?.index(where: { $0 as! Int == currID })
        if (index == nil) {
            favorites?.append(currID);
            defaults.set(favorites, forKey: "Favorites")
            defaults.synchronize()
        } else {
            favorites = favorites?.filter() { $0 as! Int != currID }
            defaults.set(favorites, forKey: "Favorites")
            defaults.synchronize()
        }
    }
    
    /*@IBAction func onFavoriteClick(_ sender: Any) {
            self.like();
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
    }*/
    
    @IBAction func OnShareClick(_ sender: Any) {
        if (FBSDKAccessToken.current() == nil)
        {
            // create the alert
            let alert = UIAlertController(title: "Warning", message: "You are not connected. Please logIn in the settings", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        let result = FBSDKMessengerSharer.messengerPlatformCapabilities().rawValue & FBSDKMessengerPlatformCapability.image.rawValue
        if result != 0 {
            // ok now share
            let savedContentOffset = scrollView.contentOffset
            let savedFrame = scrollView.frame
            
            UIGraphicsBeginImageContext(scrollView.contentSize)
            scrollView.contentOffset = .zero
            self.view.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            
            scrollView.contentOffset = savedContentOffset
            scrollView.frame = savedFrame
            
            if let sharingImage = image {
                FBSDKMessengerSharer.share(sharingImage, with: nil)
            }
        } else {
            // not installed then open link. Note simulator doesn't open iTunes store.
            UIApplication.shared.openURL(URL(string: "itms://itunes.apple.com/us/app/facebook-messenger/id454638411?mt=8")!)
        }
    }
}
