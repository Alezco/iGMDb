//
//  SettingsTVC.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 15/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SettingsTVC: UITableViewController {

    @IBOutlet weak var fLabel: UILabel!
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil)
        {
            self.returnUserData();
        }
        else
        {
            fLabel.text = "Connect"
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            // create the alert
            let alert = UIAlertController(title: "Reset", message: "Do you confirm erasing your personal data ?", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { action in
                let defaults = UserDefaults.standard
                defaults.set([], forKey: "Favorites")
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else if (indexPath.row == 1) {
            if (FBSDKAccessToken.current() != nil)
            {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut() // this is an instance function
                fLabel.text = "Connect"
                self.tableView.reloadData()
            }
            else
            {
                FBSDKLoginManager().logIn(withReadPermissions: self.facebookReadPermissions, handler: { (result, error) -> Void in
                    if error != nil {
                        FBSDKLoginManager().logOut()
                    } else if (result?.isCancelled)! {
                        FBSDKLoginManager().logOut()
                    } else {
                        self.returnUserData()
                    }
                })
                self.tableView.reloadData()
            }
        }
    }
    
    
    /*public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            print("error")
        }
        else if result.isCancelled {
            print("canceled")
        }
        else {
            self.returnUserData()
        }
    }*/
    
    /*func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }*/
    
    func returnUserData()
    {
        let params = ["fields" : "email, name"]
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                print(result)
                var res = result as? [String: Any]
                self.fLabel.text = res?["name"] as? String
            }
        })
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
