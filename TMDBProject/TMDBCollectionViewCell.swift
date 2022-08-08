//
//  TMDBCollectionViewCell.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/03.
//

import UIKit

class TMDBCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TMDBCollectionViewCell"

    @IBOutlet weak var totalView: UIView!
    
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
}
