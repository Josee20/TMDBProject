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


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var movieInfoList: [MovieInfo] = []
    // 딕셔너리 이렇게 안바꾸고 그대로 API에서 가져와서 바꾸는 방법이 있을까?
    var genreIDDic = [28:"Action", 12:"Adventure", 16:"Animation", 35:"Comedy", 80:"Crime", 99:"Documentary", 18:"Drama", 10751:"Family", 14:"Fantasy", 36:"History", 27:"Horror", 10402:"Music", 9648:"Mystery", 10749:"Romance", 878:"Science Fiction", 10770:"TV Movie", 53:"Thriller", 10752:"War", 37:"Western"]
    
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
        let space: CGFloat = 20
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
                        let genre = movie["genre_ids"][0].intValue
                        let poster = movie["poster_path"].stringValue
                        let title = movie["title"].stringValue
                        
                        let format = DateFormatter()
                        format.dateFormat = "yyyy-MM-dd"
                        let date = format.date(from: releaseDate)
                        
                        format.dateFormat = "MM/dd/yyyy"
                        let newDate = format.string(from: date!)
                        
                        let posterImageURL = URL(string: EndPoint.imageURL + "\(poster)")!
                        
                        let movieInfo = MovieInfo(movieReleaseDate: newDate, movieGenre: "#\(self.genreIDDic[genre]!)", moviePoster: posterImageURL, movieTitle: title)
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
    
        cell.movieTitleLabel.text = movieInfoList[indexPath.row].movieTitle
        cell.moviePosterImageView.kf.setImage(with: movieInfoList[indexPath.row].moviePoster)
        
        // 뷰 그림자
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        cell.layer.masksToBounds = false
        
        
        // 이미지뷰 cornerRadius
        cell.moviePosterImageView.layer.cornerRadius = 10
        cell.moviePosterImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        cell.totalView.layer.cornerRadius = 10
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableView.identifier, for: indexPath) as! CollectionReusableView
            
            headerView.movieReleaseDateLabel.text = movieInfoList[indexPath.section].movieReleaseDate
            headerView.movieGenreLabel.text = String(movieInfoList[indexPath.section].movieGenre)
            
            print(indexPath)
            return headerView
        default:
            return CollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieInfoList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return movieInfoList.count
    }
}



