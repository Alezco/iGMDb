//
//  SplashViewController.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 14/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit
import SQLite

class SplashViewController: UIViewController {


    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
            
        
        databaseLink.initDatabaseConnection()
        let res = databaseLink.deleteMovietable();
        _ = databaseLink.populateDB();
            databaseLink.setUserFavorites();
            if (res) {
                print("DB connection succed")
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.goToHomePage();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToHomePage() {
        self.performSegue(withIdentifier: "launchApp", sender: self)
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
