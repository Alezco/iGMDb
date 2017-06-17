//
//  MovieModel.swift
//  GoodMovieApplication
//
//  Created by hadrien de lamotte on 12/06/2017.
//  Copyright © 2017 hadrien de lamotte. All rights reserved.
//

import UIKit

class MovieModel: NSObject {
    
    let id : Int64;
    let title : String;
    let year : Double;
    let rated : String;
    let realeased : String;
    let runtime : String;
    let genre : String;
    let director : String;
    let writer : String;
    let actors : String;
    let plot : String;
    let language : String;
    let country : String;
    let awards : String;
    let poster : String;
    let metascore : Double;
    let imdbRating : String;
    let imdbVotes : String;
    let boxOffice : String;
    let Youtube : String;
    let liked : Bool;
    let viewed : Bool;
    
    init(data : Array<Any>) {
        id = data[0] as! Int64
        title = data[1] as! String
        year = data[2] as! Double
        rated = data[3] as! String
        realeased = data[4] as! String
        runtime = data[5] as! String
        genre = data[6] as! String
        director = data[7] as! String
        writer = data[8] as! String
        actors = data[9] as! String
        plot = data[10] as! String
        language = data[11] as! String
        country = data[12] as! String
        awards = data[13] as! String
        poster = data[14] as! String
        metascore = data[15] as! Double
        imdbRating = data[16] as! String
        imdbVotes = data[17] as! String
        boxOffice = data[18] as! String
        Youtube = data[19] as! String
        liked = false
        viewed = false
    }
}
