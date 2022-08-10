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

class RecommendMovieAPIManager {
    
    private init() { }
    
    static let shared = RecommendMovieAPIManager()
    
    var movieList = [
        ("너의이름은", 372058),
        ("인터스텔라", 157336),
        ("라라랜드", 313369),
        ("어벤져스", 299534),
        ("탑건매버릭", 361743),
        ("기생충", 496243),
        ("곡성", 293670)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func requestRecommendMovieData(query: Int, completionHandler: @escaping ([String]) -> () ) {
        
        let url = "\(URL.movieRecommendURL)\(query)/recommendations?api_key=\(APIKey.TMDBkey)&language=ko-KR&page=1"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let posterPathList = json["results"].arrayValue.map { $0["poster_path"].stringValue }
                
                completionHandler(posterPathList)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestPosterImage(completionHandler: @escaping ([[String]]) -> () ) {
        
        var posterImageList: [[String]] = []
        
        RecommendMovieAPIManager.shared.requestRecommendMovieData(query: movieList[0].1) { value in
            posterImageList.append(value)
            
            RecommendMovieAPIManager.shared.requestRecommendMovieData(query: self.movieList[1].1) { value in
                posterImageList.append(value)
                
                RecommendMovieAPIManager.shared.requestRecommendMovieData(query: self.movieList[2].1) { value in
                    posterImageList.append(value)
                    
                    RecommendMovieAPIManager.shared.requestRecommendMovieData(query: self.movieList[3].1) { value in
                        posterImageList.append(value)
                        
                        RecommendMovieAPIManager.shared.requestRecommendMovieData(query: self.movieList[4].1) { value in
                            posterImageList.append(value)
                            
                            RecommendMovieAPIManager.shared.requestRecommendMovieData(query: self.movieList[5].1) { value in
                                posterImageList.append(value)
                                
                                RecommendMovieAPIManager.shared.requestRecommendMovieData(query: self.movieList[6].1) { value in
                                    posterImageList.append(value)
                                    completionHandler(posterImageList)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
