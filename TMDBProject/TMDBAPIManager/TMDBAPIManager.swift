//
//  TMDBAPIManager.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/09.
//

import Foundation

import Alamofire
import SwiftyJSON

class MovieAPIManager {
    
    private init() { }
    
    static let shared = MovieAPIManager()
    
    func requestMovieData(type: EndPoint, page: Int, completionHandler: @escaping (JSON) -> () ) {
        let url = "\(type.requestURL)\(APIKey.TMDBkey)&page=\(page)"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                completionHandler(json)
                        
            case .failure(let error):
                print(error)
            }
        }
    }
}

class CastAPIManager {
    
    private init() { }
    
    static let shared = CastAPIManager()
    
    func requestCastData(type: EndPoint, ID: Int, completionHandler: @escaping (JSON) -> () ) {
        let url = "\(type.requestURL)\(ID)/credits?api_key=\(APIKey.TMDBkey)"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { response in
            switch response.result {
    
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
               completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

class WebAPIManager {
    
    private init() { }
    
    static let shared = WebAPIManager()
    
    func requestWebData(type: EndPoint, webViewID: Int, completionHandler: @escaping (JSON) -> () ) {

        let url = type.requestURL + "\(webViewID)/videos?api_key=\(APIKey.TMDBkey)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                completionHandler(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
