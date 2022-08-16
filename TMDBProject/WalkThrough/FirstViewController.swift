//
//  FirstViewController.swift
//  TMDBProject
//
//  Created by 이동기 on 2022/08/17.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.alpha = 0
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = .boldSystemFont(ofSize: 15)
        
        bottomLine.backgroundColor = .black
        bottomLine.alpha = 0
        
        welcomeLabel.text = """
        TMDB에 오신것을 환영합니다!!!
        추천 영화와 정보를 마음껏 즐겨보세요~~!!!
        """
        UIView.animate(withDuration: 3) {
            self.welcomeLabel.alpha = 1
            
        } completion: { _ in
            self.animateBottomeLine()
        }

    }
    
    func animateBottomeLine() {
        UIView.animate(withDuration: 2) {
            self.bottomLine.frame.size.width += 100
            self.bottomLine.alpha = 1
            self.bottomLine.layoutIfNeeded()
        } completion: { _ in
                
        }

    }

}
