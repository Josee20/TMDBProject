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

    @IBOutlet weak var webPage: WKWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var startingURL = "https://www.naver.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        openWebPage(url: startingURL)
    }
    
    func openWebPage(url: String) {
        
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webPage.load(request)
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
