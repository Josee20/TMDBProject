//
//  MovieDetailsViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/05.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class MovieDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var castInfoList: [MovieCastInfo] = []
//    var castInfoList2: [MovieCastInfo2] = []
    
    var movieID = 0
    var movieDetailsMovieTitle = ""
    var movieDetailPoster: URL?
    var movieDetailsBackgroundPoster: URL?

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieBackgroundPosterImageView: UIImageView!
    @IBOutlet weak var movieSmallPosterImageView: UIImageView!
    @IBOutlet weak var overviewInfoTableView: UITableView!
    @IBOutlet weak var castInfoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "출연/제작"
        
//        다중 셀은 어떻게???...
//        self.overviewInfoTableView.delegate = self
//        self.overviewInfoTableView.dataSource = self
        self.castInfoTableView.delegate = self
        self.castInfoTableView.dataSource = self
        
        movieTitleLabel.text = movieDetailsMovieTitle
        movieSmallPosterImageView.kf.setImage(with: movieDetailPoster)
        movieBackgroundPosterImageView .kf.setImage(with: movieDetailsBackgroundPoster)
        
//        let overviewCellNib = UINib(nibName: "OverviewTableViewCell", bundle: nil)
//        overviewInfoTableView.register(overviewCellNib, forCellReuseIdentifier: "OverviewTableViewCell")
        
        let castCellNib = UINib(nibName: "CastTableViewCell", bundle: nil)
        castInfoTableView.register(castCellNib, forCellReuseIdentifier: "CastTableViewCell")
        
        requestCastData()
    }
    
    func requestCastData() {
        
        let url = "\(EndPoint.castURL)\(movieID)/credits?api_key=\(APIKey.TMDBkey)"
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { response in
            switch response.result {
    
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 400
                
                if statusCode == 200 {
                    for cast in json["cast"].arrayValue {
                        let castPoster = cast["profile_path"].stringValue

                        guard let castPosterURL = URL(string: EndPoint.imageURL + castPoster) else {
                            return
                        }

                        let castName = cast["name"].stringValue
                        let castRole = cast["character"].stringValue

                        let movieCastInfo = MovieCastInfo(castPoster: castPosterURL, castName: castName, castRole: castRole)
                        self.castInfoList.append(movieCastInfo)
                    }

//                    map 함수는 어떻게 쓸까??
//                    let example1 = json["cast"].arrayValue.map { $0["name"].stringValue }
//                    let example2 = json["cast"].arrayValue.map { $0["character"].stringValue }
//                    let example3 = json["cast"].arrayValue.map { URL(string: EndPoint.imageURL + $0["profile_path"].stringValue)! }
//
//                    let movieCastInfo2 = MovieCastInfo2(castPoster: example3, castName: example1, castRole: example2)
//                    self.castInfoList2.append(movieCastInfo2)
//                    print(self.castInfoList2)
                } else {
                    print("에러가 발생했습니다")
                }
                
                self.castInfoTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell else {
            return UITableViewCell()
        }

        cell.castImageView.kf.setImage(with: castInfoList[indexPath.row].castPoster)
        cell.castNameLabel.text = castInfoList[indexPath.row].castName
        cell.castRoleLabel.text = castInfoList[indexPath.row].castRole

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cast"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castInfoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


