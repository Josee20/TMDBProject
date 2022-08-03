//
//  ViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/03.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var movieInfoList: [MovieInfo] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        
        setLayout()

    }
    
    func setLayout() {
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        let width = UIScreen.main.bounds.width - (space * 2)
        
        layout.itemSize = CGSize.init(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        
        collectionView.collectionViewLayout = layout
        requestData()
        
    }
    
    func requestData() {
//        let url = "https://api.themoviedb.org/3/trending/all/day?api_key=e541ad05330f9c1d3341bb5a516b7b28"
        let url = "\(EndPoint.TMDBURL)/movie/week?api_key=\(APIKey.TMDBkey)"
        
        AF.request(url, method: .get).validate(statusCode: 200...400).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 400
                
                if statusCode == 200 {
                    for movie in json["results"].arrayValue {
                        let releaseDate = movie["release_date"].stringValue
                        let genre = movie["genre_ids"].stringValue
                        let poster = movie["poster_path"].stringValue
                        let title = movie["title"].stringValue
                        
                        let posterImageURL = URL(string: poster)!
                        
                        let movieInfo = MovieInfo(movieReleaseDate: releaseDate, movieGenre: genre, moviePoster: posterImageURL, movieTitle: title)
                        self.movieInfoList.append(movieInfo)
                    }
                } else {
                    print("에러가 발생했습니다.")
                }
                
                self.collectionView.reloadData()
                        
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.identifier, for: indexPath) as? TMDBCollectionViewCell else {
            return TMDBCollectionViewCell()
        }
        cell.movieGenreLabel.text = movieInfoList[indexPath.row].movieGenre
        cell.movieTitleLabel.text = movieInfoList[indexPath.row].movieTitle
        cell.movieReleaseDateLabel.text = movieInfoList[indexPath.row].movieReleaseDate
        cell.moviePosterImageView.kf.setImage(with: movieInfoList[indexPath.row].moviePoster)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieInfoList.count
    }

}

