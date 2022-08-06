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
    
    var tempArr1 = ["a", "b", "c", "d", "e"]
    var tempArr2 = ["가", "나", "다", "라", "마"]
//    var tempArr3 = ["kingfisher-9.jpg", "kingfisher-1.jpg", "kingfisher-2.jpg", "kingfisher-3.jpg", "kingfisher-4.jpg"]
    
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
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let castCell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell else {
            return UITableViewCell()
        }
        
        
//        cell.castImageView.image = UIImage(named: tempArr3[indexPath.row])
        castCell.castNameLabel.text = tempArr1[indexPath.row]
        castCell.castRoleLabel.text = tempArr2[indexPath.row]

        return castCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cast"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

//@IBOutlet weak var castImageView: UIImageView!
//@IBOutlet weak var castNameLabel: UILabel!
//@IBOutlet weak var castRoleLabel: UILabel!
