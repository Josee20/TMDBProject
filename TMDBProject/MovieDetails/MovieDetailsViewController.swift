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
    
    var movieID = 0
    var movieDetailsMovieTitle = ""
    var movieDetailPoster: URL?
    var movieDetailsBackgroundPoster: URL?
    var movieOverview = ""
    var isExpanded = false

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieBackgroundPosterImageView: UIImageView!
    @IBOutlet weak var movieSmallPosterImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "출연/제작"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        movieTitleLabel.text = movieDetailsMovieTitle
        movieSmallPosterImageView.kf.setImage(with: movieDetailPoster)
        movieBackgroundPosterImageView .kf.setImage(with: movieDetailsBackgroundPoster)
        
        let overviewCellNib = UINib(nibName: "OverviewTableViewCell", bundle: nil)
        tableView.register(overviewCellNib, forCellReuseIdentifier: "OverviewTableViewCell")
        
        let castCellNib = UINib(nibName: "CastTableViewCell", bundle: nil)
        tableView.register(castCellNib, forCellReuseIdentifier: "CastTableViewCell")
        
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

                } else {
                    print("에러가 발생했습니다")
                }
                
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewTableViewCell", for: indexPath) as? OverviewTableViewCell else { return UITableViewCell() }
            
            cell.overviewLabel.text = movieOverview
            
            if isExpanded == false {
                cell.overviewLabel.numberOfLines = 2
            } else {
                cell.overviewLabel.numberOfLines = 0
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell else { return UITableViewCell() }
            
            cell.castImageView.kf.setImage(with: castInfoList[indexPath.row].castPoster)
            cell.castNameLabel.text = castInfoList[indexPath.row].castName
            cell.castRoleLabel.text = castInfoList[indexPath.row].castRole
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Overview"
        } else {
            return "Cast"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return castInfoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 80.0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            isExpanded = !isExpanded
            tableView.reloadData()
        }
    }
}


