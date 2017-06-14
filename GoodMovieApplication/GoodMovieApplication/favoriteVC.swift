//
//  favoriteVC.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 12/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit
import YouTubePlayer

class favoriteVC: UIViewController {

    @IBOutlet weak var youtubeView: YouTubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load video from YouTube URL
        let myVideoURL = NSURL(string: "https://www.youtube.com/watch?v=fyVz5vgqBhE")
        youtubeView.loadVideoURL(myVideoURL! as URL)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
