//
//  NewsViewController.swift
//  CryptoTracker
//
//  Created by Alexander Schüßling on 22.05.19.
//  Copyright © 2019 UTS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import SDWebImage

// The news part of this app is developed based on an existing news app on GitHub (https://github.com/johnnyperdomo/News-App)

class NewsViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    @IBAction func homeButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    var titleArray = [String]()
    var newsSourceArray = [String]()
    var imageURLArray = [String]()
    var newsStoryUrlArray = [String]()
    var searchTerms = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = (self as UITableViewDelegate)
        newsTableView.dataSource = (self as UITableViewDataSource)
        self.newsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSearchTerms()
        self.newsTableView.backgroundColor = UIColor.black
        getNewsData { (success) in
            if success {
                self.newsTableView.reloadData()
            } else {
                print("doesnt work ")
            }
        }
    }
    
    func updateSearchTerms() {
        searchTerms = [String]()
        for (coin, hold) in holdings {
            if hold > 0.0 {
                searchTerms.append(coin)
            }
        }
    }
}


extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageURLArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        var titles = String()
        var sources = String()
        
        if titleArray.count > 0 {
            titles = titleArray[indexPath.row ]
        } else {
            titles = ""
        }
        
        if newsSourceArray.count > 0 {
            sources = newsSourceArray[indexPath.row]
        } else {
            sources = ""
        }
        
        if imageURLArray.count > 0 {
            
//            cell.newsImage.sd_setImage(with: URL(string: imageURLArray[indexPath.row])) { (image, error, cache, urls) in
//                if (error != nil) {
//                    cell.newsImage.image = UIImage(named: "newsPlaceholder")
//                } else {
//                    cell.newsImage.image = image
//                }
//            }
            
        } else {
            cell.newsImage.image = UIImage(named: "newsPlaceholder")!
        }
        cell.newsImage.layer.cornerRadius = 10
        cell.configureCell(newsTitle: titles, newsSource: sources)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let urls = newsStoryUrlArray[(indexPath?.row)!]
        UIApplication.shared.open( URL(string: urls)!, options: [:] ) { (success) in
        }
    }
}

extension NewsViewController {
    
    func getNewsData(complete: @escaping (_ status: Bool) -> ()) {
        for term in searchTerms {
            var topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/top-headlines?")
            let secretAPIKey = URLQueryItem(name: "apiKey", value: "e1831a308c6d41aebe176ce12d35f743")
            topHeadLinesUrl?.queryItems?.append(secretAPIKey)
            let search = URLQueryItem(name: "q", value: term)
            topHeadLinesUrl?.queryItems?.append(search)
            Alamofire.request((topHeadLinesUrl?.url!)!, method: .get).responseJSON { (response) in
                guard let value = response.result.value else {
                    return
                }
                let json = JSON(value)
                for item in json["articles"].arrayValue {
                    self.titleArray.append(item["title"].stringValue)
                    self.newsSourceArray.append(item["source"]["name"].stringValue)
                    self.imageURLArray.append(item["urlToImage"].stringValue)
                    self.newsStoryUrlArray.append(item["url"].stringValue)
                }
                complete(true)
            }
        }
    }
    
    
}

