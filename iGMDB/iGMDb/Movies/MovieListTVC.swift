//
//  MovieListTVC.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 12/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MovieListTVC: UITableViewController, UISearchResultsUpdating {

    var originalMovies : Array<MovieModel> = []
    var movies : Array<MovieModel> = []
    let searchController = UISearchController(searchResultsController: nil)
    var selectedIndex : IndexPath = IndexPath();
    var sections : [String] = ["Actors", "Directors", "Title", "Year"]
    var searchingText : String = "";
    var searchItems = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        loadMovies();
        self.tableView.register(UINib(nibName: "ListItemViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        self.tableView.register(UINib(nibName: "SearchListItemCell", bundle: nil), forCellReuseIdentifier: "searchCell")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.searchingText = searchText
            
            self.searchItems = []
            for i in sections{
                print(i)
                var subArray = [MovieModel]()
                for j in originalMovies
                {
                    if (i == "Actors") {
                        if (j.actors.contains(searchText)) {
                            subArray.append(j)
                        }
                    }
                    else if (i == "Directors") {
                        if (j.director.contains(searchText)) {
                            subArray.append(j)
                        }
                    }
                    else if (i == "Title") {
                        if (j.title.contains(searchText)) {
                            subArray.append(j)
                        }
                    }
                    else if (i == "Year")
                    {
                        if let year = Double(searchText)
                        {
                            if (j.year == year)
                            {
                                subArray.append(j)
                            }
                        }
                        else
                        {
                            print("Not a valid number: ")
                        }
                    }
                }
                searchItems.append(subArray)
            }
            /*movies = originalMovies.filter {
                return $0.title.contains(searchText)
            }*/
        } else {
            self.searchingText = ""
            movies = originalMovies
        }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func loadMovies() {
        self.originalMovies = databaseLink.getAllMovies();
        self.movies = self.originalMovies;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (self.searchingText.characters.count > 0) {
            return sections.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.searchingText.characters.count > 0) {
            return 20
        }
        return 0

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchingText.characters.count > 0) {
            return self.searchItems[section].count
        }
        return self.movies.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.searchingText.characters.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell;
            cell.movie = self.searchItems[indexPath.section][indexPath.row] as! MovieModel
            cell.setMovie();
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MovieTableViewCell;
            cell.movie = self.movies[indexPath.row];
            cell.setMovie();
            return cell
        }

    }
 

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath;
        
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a variable that you want to send
        if (segue.identifier == "showDetail") {
            let destinationVC = segue.destination as! MovieDetailVC;
            if (self.searchingText.characters.count > 0) {
                let movieToPass = self.searchItems[selectedIndex.section][selectedIndex.row] as! MovieModel
                destinationVC.movie = movieToPass;
            } else {
                let movieToPass = movies[selectedIndex.row];
                destinationVC.movie = movieToPass;
            }
        }
    }
 

}
