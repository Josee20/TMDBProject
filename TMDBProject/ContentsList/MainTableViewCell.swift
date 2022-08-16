//
//  MainTableViewCell.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/10.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    var category: [String] = ["최신영화", "외국영화", "한국영화", "애니메이션 영화", "예능", "드라마"]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionTableView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        
    }

    private func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.text = "넷플릭스 인기 콘텐츠"
        titleLabel.backgroundColor = .clear
        
        collectionTableView.backgroundColor = .lightGray
        collectionTableView.collectionViewLayout = collectionTableViewLayout()
    }
    
    private func collectionTableViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 260)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        return layout
    }
}
