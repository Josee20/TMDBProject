//
//  MovieWebViewViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/07.
//

import UIKit
import WebKit

import Alamofire
import SwiftyJSON

class MovieWebViewController: UIViewController {

    var movieWebViewID = 766507
    
    var videoKey = ""
    let youtubeURL = "https://www.youtube.com/watch?v="

    @IBOutlet weak var webPage: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        requestData()
        
        print(movieWebViewID)
        
        
        
    }
    

    func requestData() {
        let url = EndPoint.videoURL + "\(movieWebViewID)/videos?api_key=\(APIKey.TMDBkey)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let key = json["results"][0]["key"].stringValue
                self.videoKey = key
                
                self.openWebPage(url: "\(self.youtubeURL)\(self.videoKey)")
                self.searchBar.text = "\(self.youtubeURL)\(self.videoKey)"
                
                
                
            case .failure(let error):
                print(error)
            }
//            self.openWebPage(url: "\(self.youtubeURL)\(self.videoKey)")
        }
//        self.openWebPage(url: "\(self.youtubeURL)\(self.videoKey)")
    }
    
    func openWebPage(url: String) {
        
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webPage.load(request)
        print(url)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func goBackButtonClicked(_ sender: Any) {
        webPage.goBack()
    }
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        webPage.reload()
    }
    
    @IBAction func goForwardButtonClicked(_ sender: Any) {
        webPage.goForward()
    }
}

extension MovieWebViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }
}
