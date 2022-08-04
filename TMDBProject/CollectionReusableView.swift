//
//  CollectionReusableView.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/04.
//

import UIKit

class CollectionReusableView: UICollectionReusableView {
    static let identifier = "CollectionReusableView"
    
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    
}
