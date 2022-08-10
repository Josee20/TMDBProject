//
//  ContentsListViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/09.
//

import UIKit

import Kingfisher

class ContentsListViewController: UIViewController {

    let categoryList: [String] = ["최신영화", "외국영화", "한국영화", "애니메이션 영화", "예능", "미국드라마", "한국드라마"]
    let colorList: [UIColor] = [.red, .green, .yellow, .systemPink, .brown]

    var recommendMovieImageList: [[String]] = []
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        bannerCollectionView.isPagingEnabled = true
        
        RecommendMovieAPIManager.shared.requestPosterImage { value in
            dump(value)
            self.recommendMovieImageList = value
            self.mainTableView.reloadData()
        }
    }
}

extension ContentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .orange
        
        cell.titleLabel.text = "\(RecommendMovieAPIManager.shared.movieList[indexPath.section].0)과 비슷한 영화목록"
        
        cell.collectionTableView.backgroundColor = .lightGray
        cell.collectionTableView.delegate = self
        cell.collectionTableView.dataSource = self
        cell.collectionTableView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        cell.collectionTableView.tag = indexPath.section
        cell.collectionTableView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recommendMovieImageList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
}

extension ContentsListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = colorList[indexPath.item]
        } else {
            cell.cardView.posterImageView.backgroundColor = collectionView.tag.isMultiple(of: 2) ? .white : .yellow
            cell.cardView.contentLabel.text = ""
            cell.cardView.posterImageView.tag = indexPath.item
            let url = URL(string: "\(RecommendMovieAPIManager.shared.imageURL)\(recommendMovieImageList[collectionView.tag][indexPath.item])")!
            cell.cardView.posterImageView.kf.setImage(with: url)
            cell.cardView.posterImageView.contentMode = .scaleToFill
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? colorList.count : recommendMovieImageList[collectionView.tag].count
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}
