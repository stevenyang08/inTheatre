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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieStarring: UILabel!
    var apiKey = String()
    var movieStars = NSMutableArray()
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: movieView.frame.origin.y + movieView.frame.size.height)
        print(movie)
        apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        

        movieTitle.text = movie["title"] as? String
        movieOverview.text = movie["overview"] as? String
//        movieOverview.sizeThatFits(CGSize(width: 304, height: 144))
        movieOverview.sizeToFit()
        releaseDate.text = movie["release_date"] as? String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let rating = movie["vote_average"] as? Float {
            let ratingMain = String(format: "%.2f", rating)
            movieRating.text = ("\(ratingMain)/10.00")
        }
        
        if let posterString = movie["poster_path"] as? String{
            let poster = NSURL(string: baseUrl + posterString)
            posterView.setImageWithURL(poster!)
        }
        
        
        if let movieId = movie["id"] as? NSNumber {
            movieStarApi("\(movieId.stringValue)")
        }

        
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
                        var castDictionary = [NSDictionary]()
                        castDictionary = (responseDictionary["cast"] as? [NSDictionary])!
                        if castDictionary.count >= 3 {
                            for i in 0 ..< 3 {
                                self.movieStars.addObject(castDictionary[i]["name"]!)
//                                print(self.movieStars)
                            }
                        } else if castDictionary.count == 2 {
                                for i in 0 ..< 2 {
                                    self.movieStars.addObject(castDictionary[i]["name"]!)
//                                  print(self.movieStars)
                            }
                        } else if castDictionary.count == 1 {
                                self.movieStars.addObject(castDictionary[0]["name"]!)
//                                  print(self.movieStars)
                    }
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        // do some task
                        dispatch_async(dispatch_get_main_queue()) {
                            
                        }
                    }
                    self.populateActors()
                }
            }
        }
        task.resume()
    }
    
    func populateActors() {
        if self.movieStars.count >= 3 {
            self.movieStarring.text = "\(self.movieStars[0]), \(self.movieStars[1]), \(self.movieStars[2])"
        } else if self.movieStars.count == 2 {
            self.movieStarring.text = "\(self.movieStars[0]), \(self.movieStars[1])"
        } else if self.movieStars.count == 1 {
            self.movieStarring.text = "\(self.movieStars[0])"
        }
    }
    
}
