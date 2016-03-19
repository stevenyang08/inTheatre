//
//  ViewController.swift
//  InTheatre
//
//  Created by Steven Yang on 3/14/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var movieTableView: UITableView!

    var movies = [NSDictionary]?()
    var movieStars = [NSDictionary]?()
    var apiKey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.delegate = self
        movieTableView.dataSource = self
        navigationController?.navigationBar.barTintColor = UIColor.darkGrayColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
//        http://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed
        let url = NSURL(string:"http://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request) { (dataOrNil, response, error) -> Void in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
//                    NSLog("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.movieTableView.reloadData()
                }
            }
        }
        task.resume()
        
    }

    
    // MARK: -Tableview
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("detailSegue", sender: self)
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let releaseDate = movie["release_date"] as! String
        cell.movieTitle.text = title
        cell.movieYear.text = releaseDate
        cell.movieDescription.text = overview
        
        if let rating = movie["vote_average"] as? NSNumber {
            cell.movieRating.text = ("\(rating.stringValue)/10.00")
        }
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterString = movie["poster_path"] as? String{
            let poster = NSURL(string: baseUrl + posterString)
            cell.movieImage.setImageWithURL(poster!)
        }
        
        return cell
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    // MARK: -Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! MovieCell
        let indexPath = movieTableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        let destination = segue.destinationViewController as! DetailViewController
        destination.movie = movie
        
    }

    // MARK: -Functions
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
                    self.movieTableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
}


