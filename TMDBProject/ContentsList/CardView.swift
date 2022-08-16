//
//  ContentesListView.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/09.
//

import UIKit

public class CardView: UIView {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        
        // xml파일을 nib파일로 변환시켜서 UIView에 등록해주는 과정???
        // CardCollectionViewCell의 UIView에 CardView를 등록해주기 위해
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView 
        view.frame = bounds
        view.backgroundColor = .lightGray
        addSubview(view)
    }
}
