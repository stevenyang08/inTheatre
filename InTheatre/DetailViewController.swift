//
//  DetailViewController.swift
//  InTheatre
//
//  Created by Steven Yang on 3/18/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieStarring: UILabel!
    var apiKey = String()
    var movieStars = [NSDictionary]?()
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        

        movieTitle.text = movie["title"] as? String
        movieOverview.text = movie["overview"] as? String
        releaseDate.text = movie["release_date"] as? String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let rating = movie["vote_average"] as? NSNumber {
            movieRating.text = ("\(rating.stringValue)/10.00")
        }
        
        if let posterString = movie["poster_path"] as? String{
            let poster = NSURL(string: baseUrl + posterString)
            posterView.setImageWithURL(poster!)
        }
        
        
//        let movieId = movie["id"] as? NSNumber
//        movieStarApi("\(movieId?.stringValue)")
//        
//        for var i = 0; i <= 2; i++ {
//            movieStarring.text = ""
//        }
        
        // Do any additional setup after loading the view.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func movieStarApi(movieId: String) {
        let url = NSURL(string: "http://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=\(self.apiKey)")!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request) { (dataOrNil, response, error) -> Void in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    //                    var castDictionary = [NSDictionary]()
                    //                    castDictionary = (responseDictionary["cast"] as? [NSDictionary])!
                    self.movieStars = responseDictionary["cast"] as? [NSDictionary]
                    //                        NSLog("\(castDictionary)")
                }
            }
        }
        task.resume()
    }
    

}
