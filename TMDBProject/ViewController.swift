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
    var currentPage = 1
    var totalPages = 0
    
    var genreIDDic = [28:"Action", 12:"Adventure", 16:"Animation", 35:"Comedy", 80:"Crime", 99:"Documentary", 18:"Drama", 10751:"Family", 14:"Fantasy", 36:"History", 27:"Horror", 10402:"Music", 9648:"Mystery", 10749:"Romance", 878:"Science Fiction", 10770:"TV Movie", 53:"Thriller", 10752:"War", 37:"Western"]
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        
        setLayout()
        showMovieInfo()
//        fetchData()
    }
    
    func setLayout() {
        
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 10
        let width = UIScreen.main.bounds.width - (space * 2)
        
        layout.itemSize = CGSize.init(width: width, height: width * 1.2)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        
        collectionView.collectionViewLayout = layout
    }
    
//    func fetchData() {
//
////        let url = "\(EndPoint.TMDBURL)/movie/week?api_key=\(APIKey.TMDBkey)&page=\(currentPage)"
//        let url = "\(EndPoint.trending.requestURL)\(APIKey.TMDBkey)&page=\(currentPage)"
//
//        AF.request(url, method: .get).validate(statusCode: 200...400).responseData { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//
//                let statusCode = response.response?.statusCode ?? 400
//                self.totalPages = json["total_pages"].intValue
//
//                if statusCode == 200 {
//                    for movie in json["results"].arrayValue {
//                        let releaseDate = movie["release_date"].stringValue
//                        let genre = movie["genre_ids"].arrayValue.map { $0.intValue }
//                        let poster = movie["poster_path"].stringValue
//                        let backgroundPoster = movie["backdrop_path"].stringValue
//                        let title = movie["title"].stringValue
//                        let ID = movie["id"].intValue
//                        let overview = movie["overview"].stringValue
//
//                        let format = DateFormatter()
//                        format.dateFormat = "yyyy-MM-dd"
//                        let date = format.date(from: releaseDate)
//                        format.dateFormat = "MM/dd/yyyy"
//                        let newDate = format.string(from: date!)
//
//                        let posterImageURL = URL(string: EndPoint.image.requestURL + "\(poster)")!
//                        let backgroundImageURL = URL(string: EndPoint.image.requestURL + "\(backgroundPoster)")!
//
//                        var genreStrArray: [String] = []
//
//                        for genre in genre {
//                            genreStrArray.append(self.genreIDDic[genre]!)
//                        }
//
//                        let movieInfo = MovieInfo(movieReleaseDate: newDate, movieGenre: genreStrArray, moviePoster: posterImageURL, movieBackgroundPoster: backgroundImageURL, movieTitle: title, movieID: ID, movieOverview: overview)
//                        self.movieInfoList.append(movieInfo)
//                    }
//                } else {
//                    print("에러가 발생했습니다.")
//                }
//
//                self.collectionView.reloadData()
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    func showMovieInfo() {
        MovieAPIManager.shared.requestMovieData(type: .trending, page: currentPage) { json in
            
            self.totalPages = json["total_pages"].intValue
            
            for movie in json["results"].arrayValue {
                let releaseDate = movie["release_date"].stringValue
                let genre = movie["genre_ids"].arrayValue.map { $0.intValue }
                let poster = movie["poster_path"].stringValue
                let backgroundPoster = movie["backdrop_path"].stringValue
                let title = movie["title"].stringValue
                let ID = movie["id"].intValue
                let overview = movie["overview"].stringValue
                
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd"
                let date = format.date(from: releaseDate)
                format.dateFormat = "MM/dd/yyyy"
                let newDate = format.string(from: date!)
                
                let posterImageURL = URL(string: EndPoint.image.requestURL + "\(poster)")!
                let backgroundImageURL = URL(string: EndPoint.image.requestURL + "\(backgroundPoster)")!
                
                var genreStrArray: [String] = []
                
                for genre in genre {
                    genreStrArray.append(self.genreIDDic[genre]!)
                }
                
                let movieInfo = MovieInfo(movieReleaseDate: newDate, movieGenre: genreStrArray, moviePoster: posterImageURL, movieBackgroundPoster: backgroundImageURL, movieTitle: title, movieID: ID, movieOverview: overview)
                self.movieInfoList.append(movieInfo)
            }
            self.collectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBCollectionViewCell.identifier, for: indexPath) as? TMDBCollectionViewCell else {
            return TMDBCollectionViewCell()
        }
    
        cell.movieReleaseDateLabel.text = movieInfoList[indexPath.row].movieReleaseDate
        
        for index in 0...movieInfoList[indexPath.row].movieGenre.count - 1 {
            if index < movieInfoList[indexPath.row].movieGenre.count - 1 {
                cell.movieGenreLabel.text! += movieInfoList[indexPath.row].movieGenre[index] + " & "
            } else {
                cell.movieGenreLabel.text! += movieInfoList[indexPath.row].movieGenre[index]
            }
        }
        cell.movieTitleLabel.text = movieInfoList[indexPath.row].movieTitle
        cell.moviePosterImageView.kf.setImage(with: movieInfoList[indexPath.row].moviePoster)
        cell.linkButton.tag = indexPath.row

        // 뷰 그림자
        cell.totalView.layer.masksToBounds = false
        cell.totalView.layer.borderWidth = 0.0
        cell.totalView.layer.shadowColor = UIColor.black.cgColor
        cell.totalView.layer.shadowRadius = 20
        cell.totalView.layer.shadowOpacity = 0.2
        cell.totalView.layer.shadowOffset = .zero
        
        // 이미지뷰 cornerRadius
        cell.moviePosterImageView.layer.cornerRadius = 10
        cell.moviePosterImageView.layer.maskedCorners = CACornerMask(arrayLiteral: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        cell.totalView.layer.cornerRadius = 10
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "MovieDetailsStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        
        vc.movieDetailsMovieTitle = movieInfoList[indexPath.row].movieTitle
        vc.movieDetailPoster = movieInfoList[indexPath.row].moviePoster
        vc.movieDetailsBackgroundPoster = movieInfoList[indexPath.row].movieBackgroundPoster
        vc.movieID = movieInfoList[indexPath.row].movieID
        vc.movieOverview = movieInfoList[indexPath.row].movieOverview

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func linkButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "MovieWebViewStoryboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MovieWebViewController") as! MovieWebViewController
        
        vc.movieWebViewID = movieInfoList[sender.tag].movieID
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
        
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if movieInfoList.count - 1 == indexPath.item && currentPage < totalPages {
                currentPage += 1
//                fetchData()
                showMovieInfo()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("==============취소: \(indexPaths)")
    }
}


