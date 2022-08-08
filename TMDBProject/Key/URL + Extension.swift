//
//  URL + Extension.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/09.
//

import Foundation

extension URL {
    static let TrendingURL = "https://api.themoviedb.org/3/trending/"
    static let imageURL = "https://image.tmdb.org/t/p/original/"
    static let castAndVideoURL = "https://api.themoviedb.org/3/movie/"
    
    static func makeTrendingEndPointString(_ endpoint: String) -> String {
        return TrendingURL + endpoint
    }
    
    static func makeImageEndPointString(_ endpoint: String) -> String {
        return imageURL + endpoint
    }
    
    static func makeCastAndVideoEndPointString(_ endpoint: String) -> String {
        return castAndVideoURL + endpoint
    }
}
