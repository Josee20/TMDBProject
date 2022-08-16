//
//  CardCollectionViewCell.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/09.
//

import UIKit

public class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        cardView.backgroundColor = .clear
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.starButton.tintColor = . systemGreen
    }
}
