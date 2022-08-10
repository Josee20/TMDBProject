//
//  ContentsListViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/09.
//

import UIKit

class ContentsListViewController: UIViewController {

    let categoryList: [String] = ["최신영화", "외국영화", "한국영화", "애니메이션 영화", "예능", "미국드라마", "한국드라마"]
    let colorList: [UIColor] = [.red, .green, .yellow, .systemPink, .brown]
    let contentsList: [[String]] = [
        ["탑건", "범죄도시2", "한산", "외계인", "비상선언"],
        ["인터스텔라", "아바타", "라라랜드", "타짜", "인턴", "악마는 프라다를 입는다", "어바웃타임"],
        ["전우치", "마녀", "타짜", "내부자들", "베테랑", "신과함께", "극한직업", "괴물", "명량", "실미도", "태극기 휘날리며"],
        ["너의 이름은", "날씨의 아이", "센과 치히로의 행방불명", "쿵푸팬더", "하울의 움직이는 성"],
        ["1박 2일", "무한도전", "런닝맨", "지구오락실", "유퀴즈", "놀면뭐하니", "패밀리가 떴다", "라디오 스타", "아는형님"],
        ["프렌즈", "모던패밀리", "왕좌의게임", "종이의집", "굿플레이스", "김씨네편의점", "워킹데드", "슈츠"],
        ["이상한 변호사 우영우", "우리들의 블루스", "나의 해방일지", "나의 아저씨", "또 오해영", "이태원 클라쓰", "연모", "사랑의 불시착", "도깨비", "파리의 연인", "일지매", "꽃보다 남자", "장보고", "해신", "주몽", "태양의 후예"]
    ]
    
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
    }
}

extension ContentsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = .orange
        
        cell.titleLabel.text = categoryList[indexPath.section]
        
        cell.collectionTableView.backgroundColor = .lightGray
        cell.collectionTableView.delegate = self
        cell.collectionTableView.dataSource = self
        cell.collectionTableView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        cell.collectionTableView.tag = indexPath.section
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contentsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
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
            cell.cardView.contentLabel.text = "\(contentsList[collectionView.tag][indexPath.item])"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
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
