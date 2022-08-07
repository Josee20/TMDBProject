//
//  Struct.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/03.
//

import Foundation

struct MovieInfo {
    let movieReleaseDate: String
    let movieGenre: [String]
    let moviePoster: URL
    let movieBackgroundPoster: URL
    let movieTitle: String
    let movieID: Int
}

struct MovieCastInfo {
    let castPoster: URL
    let castName: String
    let castRole: String
}

struct MovieCastInfo2 {
    let castPoster: [URL]
    let castName: [String]
    let castRole: [String]
}
